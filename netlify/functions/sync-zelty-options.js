/**
 * Netlify Scheduled Function: Sync Zelty catalog options → recettes variantes/modificateurs
 * Runs every day at 06:00 UTC (07:00 Paris winter / 08:00 Paris summer)
 *
 * - Fetches all dishes + options from Zelty catalog
 * - For each recipe with zelty_product_id, maps its dish's options
 * - Auto-classifies: Taille → variantes, "Sans X" → sans, price>0 → extra
 * - Fuzzy-matches ingredients for impact_stock
 * - Preserves existing user-configured entries (by zelty_option_value_id)
 *
 * Also callable manually via POST (from Paramètres or curl)
 *
 * Schedule configured in netlify.toml
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 500;

// Known Zelty option IDs
const TAILLE_OPTION_ID = 241667;
const TAILLE_NORMAL_VALUE = 1215713;
const TAILLE_GRAND_VALUE = 1215714;
const EXTRA_OPTION_IDS = [241669, 241943]; // "Un petit plus pour votre plat?" + Finger Phood

function normalize(s) {
  return s.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').trim();
}

function cleanEmojis(s) {
  return s.replace(/[\p{Emoji_Presentation}\p{Extended_Pictographic}]/gu, '').trim();
}

/**
 * Fuzzy-match an option name to an ingredient.
 * Strips "Sans " prefix, normalizes, then does bidirectional includes.
 */
function findIngredient(optionName, ingredients) {
  const cleaned = cleanEmojis(optionName).replace(/^Sans\s+/i, '');
  const n = normalize(cleaned);
  if (!n || n.length < 2) return null;

  // Exact match first
  const exact = ingredients.find(ing => normalize(ing.nom) === n);
  if (exact) return exact;

  // Bidirectional includes
  return ingredients.find(ing => {
    const ingN = normalize(ing.nom);
    return ingN.includes(n) || n.includes(ingN);
  }) || null;
}

exports.handler = async function (event) {
  const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
    console.error('Missing env vars');
    return { statusCode: 500, body: JSON.stringify({ error: 'Missing configuration' }) };
  }

  const supaHeaders = {
    'apikey': SUPABASE_KEY,
    'Authorization': `Bearer ${SUPABASE_KEY}`,
    'Content-Type': 'application/json',
  };

  const startTime = Date.now();
  let logId = null;

  try {
    // 1. Log job start
    const logResp = await fetch(
      `${SUPABASE_URL}/rest/v1/cron_logs`,
      {
        method: 'POST',
        headers: { ...supaHeaders, 'Prefer': 'return=representation' },
        body: JSON.stringify({ job_name: 'sync-zelty-options', status: 'running' }),
      }
    );
    if (logResp.ok) {
      const logs = await logResp.json();
      logId = logs[0]?.id;
    }

    // 2. Fetch Zelty catalog: dishes (paginated) + options
    let allDishes = [];
    let offset = 0;
    let hasMore = true;

    while (hasMore) {
      const url = `${ZELTY_BASE_URL}/catalog/dishes?limit=${PAGE_SIZE}&offset=${offset}&show_all=true`;
      const resp = await fetch(url, {
        headers: { 'Authorization': `Bearer ${ZELTY_API_KEY}`, 'Accept': 'application/json' },
      });
      if (!resp.ok) {
        const errText = await resp.text();
        throw new Error(`Zelty dishes API error ${resp.status}: ${errText}`);
      }
      const data = await resp.json();
      const dishes = data.dishes || [];
      allDishes.push(...dishes);
      hasMore = dishes.length >= PAGE_SIZE;
      offset += PAGE_SIZE;
    }

    const optionsResp = await fetch(`${ZELTY_BASE_URL}/catalog/options?limit=200`, {
      headers: { 'Authorization': `Bearer ${ZELTY_API_KEY}`, 'Accept': 'application/json' },
    });
    if (!optionsResp.ok) {
      throw new Error(`Zelty options API error ${optionsResp.status}`);
    }
    const optionsData = await optionsResp.json();

    // 3. Build options map
    const zeltyOptions = new Map();
    for (const opt of (optionsData.options || [])) {
      zeltyOptions.set(opt.id, opt);
    }

    // 4. Build dish → classified options map
    const dishOptionsMap = new Map();
    for (const dish of allDishes) {
      const dishId = String(dish.id);
      const info = { hasTaille: false, sansValues: [], extraValues: [] };

      for (const optId of (dish.options || [])) {
        const opt = zeltyOptions.get(optId);
        if (!opt) continue;

        if (optId === TAILLE_OPTION_ID) {
          info.hasTaille = true;
        } else if (EXTRA_OPTION_IDS.includes(optId)) {
          for (const v of (opt.values || [])) {
            info.extraValues.push({
              zelty_option_value_id: v.id,
              nom: cleanEmojis(v.name),
              prix: v.price || 0,
            });
          }
        } else if (opt.name.includes("n'aimez pas") || opt.name.toLowerCase().includes('sans')) {
          for (const v of (opt.values || [])) {
            info.sansValues.push({
              zelty_option_value_id: v.id,
              nom: cleanEmojis(v.name),
            });
          }
        }
      }

      dishOptionsMap.set(dishId, info);
    }

    // 5. Fetch recettes with zelty_product_id
    const recettesResp = await fetch(
      `${SUPABASE_URL}/rest/v1/recettes?select=id,nom,zelty_product_id,variantes,modificateurs&zelty_product_id=not.is.null`,
      { headers: supaHeaders },
    );
    if (!recettesResp.ok) throw new Error(`Supabase recettes fetch error: ${recettesResp.status}`);
    const recettes = await recettesResp.json();

    // 6. Fetch all active ingredients for fuzzy matching
    const ingResp = await fetch(
      `${SUPABASE_URL}/rest/v1/ingredients_restaurant?select=id,nom,unite_stock&actif=eq.true`,
      { headers: supaHeaders },
    );
    if (!ingResp.ok) throw new Error(`Supabase ingredients fetch error: ${ingResp.status}`);
    const ingredients = await ingResp.json();

    // 7. Process each recipe
    let updatedVariantes = 0;
    let updatedModificateurs = 0;
    let skipped = 0;
    let unchanged = 0;

    for (const recette of recettes) {
      const dishInfo = dishOptionsMap.get(recette.zelty_product_id);
      if (!dishInfo) {
        skipped++;
        continue;
      }

      const updates = {};

      // --- Variantes ---
      if (dishInfo.hasTaille) {
        const existing = recette.variantes || [];
        const hasNormal = existing.some(v => v.zelty_option_value_id === TAILLE_NORMAL_VALUE);
        const hasGrand = existing.some(v => v.zelty_option_value_id === TAILLE_GRAND_VALUE);

        if (!hasNormal || !hasGrand) {
          // Preserve manual entries (without zelty_option_value_id)
          const manualEntries = existing.filter(v => !v.zelty_option_value_id);
          // Preserve existing Zelty entries that are not Normal/Grand
          const otherZelty = existing.filter(v =>
            v.zelty_option_value_id &&
            v.zelty_option_value_id !== TAILLE_NORMAL_VALUE &&
            v.zelty_option_value_id !== TAILLE_GRAND_VALUE
          );

          // Keep user-configured coefficient if exists
          const existingNormal = existing.find(v => v.zelty_option_value_id === TAILLE_NORMAL_VALUE);
          const existingGrand = existing.find(v => v.zelty_option_value_id === TAILLE_GRAND_VALUE);

          updates.variantes = [
            existingNormal || { nom: 'Normal', zelty_option_value_id: TAILLE_NORMAL_VALUE, coefficient: 1.0 },
            existingGrand || { nom: 'Grand', zelty_option_value_id: TAILLE_GRAND_VALUE, coefficient: 1.5 },
            ...otherZelty,
            ...manualEntries,
          ];
          updatedVariantes++;
        }
      }

      // --- Modificateurs ---
      const existingMods = recette.modificateurs || [];
      const existingModIds = new Set(existingMods.map(m => m.zelty_option_value_id).filter(Boolean));
      const newMods = [...existingMods];
      let modsAdded = 0;

      // Add "sans" modificateurs
      for (const sv of dishInfo.sansValues) {
        if (!existingModIds.has(sv.zelty_option_value_id)) {
          const matched = findIngredient(sv.nom, ingredients);
          const mod = {
            nom: sv.nom,
            zelty_option_value_id: sv.zelty_option_value_id,
            type: 'sans',
            impact_stock: [],
            prix_supplement: 0,
          };
          if (matched) {
            mod.impact_stock = [{
              ingredient_restaurant_id: matched.id,
              quantite: 0,
              unite: matched.unite_stock || 'g',
            }];
          }
          newMods.push(mod);
          modsAdded++;
        }
      }

      // Add "extra" modificateurs
      for (const ev of dishInfo.extraValues) {
        if (!existingModIds.has(ev.zelty_option_value_id)) {
          const matched = findIngredient(ev.nom, ingredients);
          const mod = {
            nom: ev.nom,
            zelty_option_value_id: ev.zelty_option_value_id,
            type: 'extra',
            impact_stock: [],
            prix_supplement: (ev.prix || 0) / 100, // centimes → euros
          };
          if (matched) {
            mod.impact_stock = [{
              ingredient_restaurant_id: matched.id,
              quantite: 0, // admin fills exact qty later
              unite: matched.unite_stock || 'g',
            }];
          }
          newMods.push(mod);
          modsAdded++;
        }
      }

      if (modsAdded > 0) {
        updates.modificateurs = newMods;
        updatedModificateurs++;
      }

      // --- Apply updates ---
      if (Object.keys(updates).length > 0) {
        const patchResp = await fetch(
          `${SUPABASE_URL}/rest/v1/recettes?id=eq.${recette.id}`,
          {
            method: 'PATCH',
            headers: supaHeaders,
            body: JSON.stringify(updates),
          }
        );
        if (!patchResp.ok) {
          const errText = await patchResp.text();
          console.error(`Failed to update ${recette.nom}: ${errText}`);
        } else {
          const parts = [];
          if (updates.variantes) parts.push('variantes');
          if (updates.modificateurs) parts.push(`${modsAdded} modificateurs`);
          console.log(`  ✓ ${recette.nom} → ${parts.join(' + ')}`);
        }
      } else {
        unchanged++;
      }
    }

    // 8. Log job success
    const durationMs = Date.now() - startTime;
    const summary = {
      recettes_total: recettes.length,
      updated_variantes: updatedVariantes,
      updated_modificateurs: updatedModificateurs,
      skipped_no_match: skipped,
      unchanged,
    };

    console.log(`\n=== sync-zelty-options done ===`);
    console.log(JSON.stringify(summary, null, 2));

    if (logId) {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`,
        {
          method: 'PATCH',
          headers: supaHeaders,
          body: JSON.stringify({
            status: 'success',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
          }),
        }
      );
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, ...summary }),
    };
  } catch (err) {
    console.error('sync-zelty-options error:', err);

    const durationMs = Date.now() - startTime;
    if (logId) {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`,
        {
          method: 'PATCH',
          headers: supaHeaders,
          body: JSON.stringify({
            status: 'error',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
            error_message: err.message,
          }),
        }
      );
    } else {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs`,
        {
          method: 'POST',
          headers: supaHeaders,
          body: JSON.stringify({
            job_name: 'sync-zelty-options',
            status: 'error',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
            error_message: err.message,
          }),
        }
      ).catch(() => {});
    }

    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
