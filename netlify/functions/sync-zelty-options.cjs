/**
 * Netlify Scheduled Function: Sync Zelty catalog options → recettes.options
 * Runs every day at 06:00 UTC (07:00 Paris winter / 08:00 Paris summer)
 *
 * - Fetches all dishes + options from Zelty catalog
 * - For each recipe with zelty_product_id, classifies its dish's options
 * - Auto-classifies: taille/extra/sans/choix (unified RecetteOption model)
 * - Fuzzy-matches ingredients for impact_stock
 * - Preserves existing user-configured entries (by zelty_option_value_id)
 *
 * Schedule configured in netlify.toml
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 500;

function normalize(s) {
  return s.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').trim();
}

function cleanEmojis(s) {
  return s.replace(/[\p{Emoji_Presentation}\p{Extended_Pictographic}]/gu, '').trim();
}

/**
 * Guess coefficient for taille options based on name.
 */
function guessCoefficient(name) {
  const n = normalize(name);
  if (n.includes('grand') || n.includes('large') || n.includes('xl')) return 1.5;
  if (n.includes('petit') || n.includes('small')) return 0.7;
  return 1.0;
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

async function main() {
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

    // 4. Build dish → unified options list (DYNAMIC — no hardcoded IDs)
    //
    // Classification rules:
    //   a) Option group name contains "taille" → type 'taille' with auto-coefficient
    //   b) Option group name contains "n'aimez pas" → all values type 'sans'
    //   c) For other groups, per-value:
    //      - value name starts with "Sans " → type 'sans'
    //      - value price > 0 → type 'extra'
    //      - value price = 0 and not "Sans" → type 'choix' (free choice)
    //
    const dishOptionsMap = new Map();
    for (const dish of allDishes) {
      const dishId = String(dish.id);
      const optionValues = [];

      for (const optId of (dish.options || [])) {
        const opt = zeltyOptions.get(optId);
        if (!opt) continue;

        const optNameLower = normalize(opt.name);
        const isTailleGroup = optNameLower.includes('taille');
        const isSansGroup = opt.name.includes("n'aimez pas") || optNameLower.includes('sans');

        for (const v of (opt.values || [])) {
          const vName = cleanEmojis(v.name);
          const priceCents = typeof v.price === 'object'
            ? (v.price.original_amount_inc_tax || 0)
            : (v.price || 0);
          const isSansValue = /^Sans\s+/i.test(vName);

          let type, coefficient, prix_supplement;

          if (isTailleGroup) {
            type = 'taille';
            coefficient = guessCoefficient(vName);
          } else if (isSansGroup || isSansValue) {
            type = 'sans';
          } else if (priceCents > 0) {
            type = 'extra';
            prix_supplement = priceCents / 100; // centimes → euros
          } else {
            type = 'choix';
          }

          const entry = {
            zelty_option_value_id: v.id,
            nom: vName,
            type,
          };
          if (coefficient !== undefined) entry.coefficient = coefficient;
          if (prix_supplement !== undefined) entry.prix_supplement = prix_supplement;

          optionValues.push(entry);
        }
      }

      dishOptionsMap.set(dishId, optionValues);
    }

    // 5. Fetch recettes with zelty_product_id (read new 'options' column)
    const recettesResp = await fetch(
      `${SUPABASE_URL}/rest/v1/recettes?select=id,nom,zelty_product_id,options&zelty_product_id=not.is.null`,
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
    let updatedCount = 0;
    let skipped = 0;
    let unchanged = 0;

    for (const recette of recettes) {
      const dishOpts = dishOptionsMap.get(recette.zelty_product_id);
      if (!dishOpts || dishOpts.length === 0) {
        skipped++;
        continue;
      }

      const existing = recette.options || [];
      const existingZeltyIds = new Set(
        existing.map(o => o.zelty_option_value_id).filter(Boolean)
      );

      // Find new options not yet in recipe
      const newOpts = dishOpts.filter(
        ov => !existingZeltyIds.has(ov.zelty_option_value_id)
      );

      if (newOpts.length === 0) {
        unchanged++;
        continue;
      }

      // Fuzzy-match ingredients for sans/extra options
      for (const opt of newOpts) {
        if (opt.type === 'sans' || opt.type === 'extra') {
          const matched = findIngredient(opt.nom, ingredients);
          if (matched) {
            opt.impact_stock = [{
              ingredient_restaurant_id: matched.id,
              quantite: 0, // admin fills exact qty for extras later
              unite: matched.unite_stock || 'g',
            }];
          }
        }
      }

      // Merge: keep existing (preserve user edits) + add new
      const merged = [...existing, ...newOpts];

      const patchResp = await fetch(
        `${SUPABASE_URL}/rest/v1/recettes?id=eq.${recette.id}`,
        {
          method: 'PATCH',
          headers: supaHeaders,
          body: JSON.stringify({ options: merged }),
        }
      );
      if (!patchResp.ok) {
        const errText = await patchResp.text();
        console.error(`Failed to update ${recette.nom}: ${errText}`);
      } else {
        const types = newOpts.map(o => o.type);
        const counts = {};
        for (const t of types) counts[t] = (counts[t] || 0) + 1;
        const desc = Object.entries(counts).map(([t, c]) => `${c} ${t}`).join(' + ');
        console.log(`  ✓ ${recette.nom} → ${desc}`);
        updatedCount++;
      }
    }

    // 8. Log job success
    const durationMs = Date.now() - startTime;
    const summary = {
      recettes_total: recettes.length,
      updated: updatedCount,
      skipped_no_options: skipped,
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
}

// Netlify handler
exports.handler = async function (event) {
  return main();
};

// CLI: node netlify/functions/sync-zelty-options.cjs
if (require.main === module) {
  main()
    .then(r => {
      console.log('\nResult:', r.statusCode);
      console.log(r.body);
    })
    .catch(err => {
      console.error('FATAL:', err);
      process.exit(1);
    });
}
