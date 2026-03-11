/**
 * Netlify Scheduled Function: Daily alert checks
 * Runs every day at 08:00 UTC (09:00 Paris winter / 10:00 Paris summer)
 *
 * Checks:
 * 1. stock_bas — stocks below tampon threshold
 * 2. avoir_sans_reponse — credit notes awaiting response past delay
 * 3. zelty_non_associe — Zelty products without a linked recipe
 * 4. composition_manquante — preparation ingredients missing "contient" field
 *
 * Creates notifications + sends grouped email alert.
 * Schedule configured in netlify.toml
 */

const { sendEmail } = require('./lib/gmail');

exports.handler = async function () {
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!SUPABASE_URL || !SUPABASE_KEY) {
    console.error('Missing env vars');
    return { statusCode: 500, body: JSON.stringify({ error: 'Missing configuration' }) };
  }

  const headers = {
    'apikey': SUPABASE_KEY,
    'Authorization': `Bearer ${SUPABASE_KEY}`,
    'Content-Type': 'application/json',
    'Prefer': 'return=minimal',
  };

  try {
    // Load config
    const configResp = await fetch(
      `${SUPABASE_URL}/rest/v1/config?select=*&limit=1`,
      { headers: { ...headers, 'Accept': 'application/vnd.pgrst.object+json' } },
    );
    const config = configResp.ok ? await configResp.json() : {};
    const seuilAvoirHeures = config.delai_alerte_avoir_heures || 48;
    const emailRecipients = config.destinataires_email_alertes || [];

    // Get all admin user IDs
    const adminsResp = await fetch(
      `${SUPABASE_URL}/rest/v1/profiles?select=id&role=eq.admin`,
      { headers },
    );
    const admins = adminsResp.ok ? await adminsResp.json() : [];
    if (admins.length === 0) {
      console.log('No admin users found, skipping');
      return { statusCode: 200, body: JSON.stringify({ skipped: true }) };
    }

    const alerts = [];

    // ── 1. Stock bas ──────────────────────────────────────────
    const stocksResp = await fetch(
      `${SUPABASE_URL}/rest/v1/stocks?select=ingredient_id,quantite`,
      { headers },
    );
    const stocks = stocksResp.ok ? await stocksResp.json() : [];

    const ingredientIds = stocks.map(s => s.ingredient_id);
    let ingredients = [];
    if (ingredientIds.length > 0) {
      // Fetch ingredients with tampon in batches (PostgREST URL limit)
      const ingResp = await fetch(
        `${SUPABASE_URL}/rest/v1/ingredients_restaurant?select=id,nom,stock_tampon,unite_stock,actif&actif=eq.true&stock_tampon=gt.0&id=in.(${ingredientIds.join(',')})`,
        { headers },
      );
      ingredients = ingResp.ok ? await ingResp.json() : [];
    }

    const ingMap = new Map(ingredients.map(i => [i.id, i]));
    const lowStocks = [];

    for (const s of stocks) {
      const ing = ingMap.get(s.ingredient_id);
      if (!ing) continue;
      if (s.quantite < ing.stock_tampon) {
        lowStocks.push({
          nom: ing.nom,
          quantite: s.quantite,
          tampon: ing.stock_tampon,
          unite: ing.unite_stock,
        });
      }
    }

    if (lowStocks.length > 0) {
      // Check for existing unread stock_bas notification (dedup)
      const existingResp = await fetch(
        `${SUPABASE_URL}/rest/v1/notifications?select=id&type=eq.stock_bas&lue=eq.false&created_at=gte.${todayISO()}`,
        { headers },
      );
      const existing = existingResp.ok ? await existingResp.json() : [];

      if (existing.length === 0) {
        const titre = `${lowStocks.length} stock(s) bas`;
        const message = lowStocks
          .sort((a, b) => (a.quantite / a.tampon) - (b.quantite / b.tampon))
          .slice(0, 10)
          .map(s => `${s.nom} : ${s.quantite} ${s.unite} (tampon : ${s.tampon})`)
          .join('\n');

        // Create notifications for all admins
        const notifs = admins.map(a => ({
          type: 'stock_bas',
          titre,
          message,
          lue: false,
          destinataire_id: a.id,
        }));
        await fetch(`${SUPABASE_URL}/rest/v1/notifications`, {
          method: 'POST',
          headers,
          body: JSON.stringify(notifs),
        });

        alerts.push({ type: 'stock_bas', titre, message });
        console.log(`Created stock_bas alert: ${lowStocks.length} items`);
      }
    }

    // ── 2. Avoir sans réponse ──────────────────────────────────
    const cutoffDate = new Date(Date.now() - seuilAvoirHeures * 3600 * 1000).toISOString();
    const avoirsResp = await fetch(
      `${SUPABASE_URL}/rest/v1/avoirs?select=id,fournisseur_id,montant_estime,created_at&statut=eq.envoyee&created_at=lt.${cutoffDate}`,
      { headers },
    );
    const avoirs = avoirsResp.ok ? await avoirsResp.json() : [];

    if (avoirs.length > 0) {
      // Check for existing unread avoir notification (dedup)
      const existingResp = await fetch(
        `${SUPABASE_URL}/rest/v1/notifications?select=id&type=eq.avoir_sans_reponse&lue=eq.false&created_at=gte.${todayISO()}`,
        { headers },
      );
      const existing = existingResp.ok ? await existingResp.json() : [];

      if (existing.length === 0) {
        const titre = `${avoirs.length} avoir(s) sans réponse`;
        const totalMontant = avoirs.reduce((sum, a) => sum + (a.montant_estime || 0), 0);
        const message = `${avoirs.length} avoir(s) en attente depuis plus de ${seuilAvoirHeures}h — Total estimé : ${totalMontant.toFixed(2)}€`;

        const notifs = admins.map(a => ({
          type: 'avoir_sans_reponse',
          titre,
          message,
          lue: false,
          destinataire_id: a.id,
        }));
        await fetch(`${SUPABASE_URL}/rest/v1/notifications`, {
          method: 'POST',
          headers,
          body: JSON.stringify(notifs),
        });

        alerts.push({ type: 'avoir_sans_reponse', titre, message });
        console.log(`Created avoir_sans_reponse alert: ${avoirs.length} items`);
      }
    }

    // ── 3. Zelty products not associated to a recipe ───────────
    // Ingredients linked to Zelty products but without a recipe
    try {
      const zeltyProductsResp = await fetch(
        `${SUPABASE_URL}/rest/v1/ingredients_restaurant?select=id,nom&actif=eq.true&zelty_product_id=not.is.null`,
        { headers },
      );
      const zeltyIngredients = zeltyProductsResp.ok ? await zeltyProductsResp.json() : [];

      if (zeltyIngredients.length > 0) {
        // Check which ones have recipes
        const recetteIngsResp = await fetch(
          `${SUPABASE_URL}/rest/v1/recette_ingredients?select=ingredient_id`,
          { headers },
        );
        const recetteIngs = recetteIngsResp.ok ? await recetteIngsResp.json() : [];
        const linkedIds = new Set(recetteIngs.map(ri => ri.ingredient_id));

        const unlinked = zeltyIngredients.filter(zi => !linkedIds.has(zi.id));

        if (unlinked.length > 0) {
          const existingResp = await fetch(
            `${SUPABASE_URL}/rest/v1/notifications?select=id&type=eq.zelty_non_associe&lue=eq.false&created_at=gte.${todayISO()}`,
            { headers },
          );
          const existing = existingResp.ok ? await existingResp.json() : [];

          if (existing.length === 0) {
            const titre = `${unlinked.length} produit(s) Zelty sans recette`;
            const message = unlinked.slice(0, 10).map(u => u.nom).join(', ');

            const notifs = admins.map(a => ({
              type: 'zelty_non_associe',
              titre,
              message,
              lue: false,
              destinataire_id: a.id,
            }));
            await fetch(`${SUPABASE_URL}/rest/v1/notifications`, {
              method: 'POST',
              headers,
              body: JSON.stringify(notifs),
            });
            alerts.push({ type: 'zelty_non_associe', titre, message });
            console.log(`Created zelty_non_associe alert: ${unlinked.length} items`);
          }
        }
      }
    } catch (e) {
      console.error('zelty_non_associe check failed:', e);
    }

    // ── 4. Ingredients with missing composition (contient) ─────
    // Pre-made items that should have a "contient" list for allergen search
    try {
      const prepIngsResp = await fetch(
        `${SUPABASE_URL}/rest/v1/ingredients_restaurant?select=id,nom&actif=eq.true&type=eq.preparation&contient=is.null`,
        { headers },
      );
      const missingCompo = prepIngsResp.ok ? await prepIngsResp.json() : [];

      if (missingCompo.length > 0) {
        const existingResp = await fetch(
          `${SUPABASE_URL}/rest/v1/notifications?select=id&type=eq.composition_manquante&lue=eq.false&created_at=gte.${todayISO()}`,
          { headers },
        );
        const existing = existingResp.ok ? await existingResp.json() : [];

        if (existing.length === 0) {
          const titre = `${missingCompo.length} ingredient(s) sans composition`;
          const message = missingCompo.slice(0, 10).map(i => i.nom).join(', ')
            + '\nRenseignez le champ "contient" pour la recherche allergenes.';

          const notifs = admins.map(a => ({
            type: 'composition_manquante',
            titre,
            message,
            lue: false,
            destinataire_id: a.id,
          }));
          await fetch(`${SUPABASE_URL}/rest/v1/notifications`, {
            method: 'POST',
            headers,
            body: JSON.stringify(notifs),
          });
          alerts.push({ type: 'composition_manquante', titre, message });
          console.log(`Created composition_manquante alert: ${missingCompo.length} items`);
        }
      }
    } catch (e) {
      console.error('composition_manquante check failed:', e);
    }

    // ── 5. Send grouped email if alerts found ─────────────────
    if (alerts.length > 0 && emailRecipients.length > 0) {
      const htmlParts = alerts.map(a => `
        <div style="margin-bottom:20px;padding:16px;border-left:4px solid #E85D2C;background:#fef9f7;">
          <h3 style="margin:0 0 8px;color:#E85D2C;">${a.titre}</h3>
          <p style="margin:0;white-space:pre-line;font-size:14px;color:#333;">${a.message}</p>
        </div>
      `);

      await sendEmail({
        to: emailRecipients,
        subject: `[Phood] ${alerts.length} alerte(s) du jour`,
        html: `
          <div style="font-family:sans-serif;max-width:600px;margin:0 auto;">
            <h2 style="color:#E85D2C;">Alertes PhoodApp</h2>
            ${htmlParts.join('')}
            <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
            <p style="color:#888;font-size:13px;">
              <a href="https://app.phood.fr/" style="color:#E85D2C;">Ouvrir PhoodApp</a>
            </p>
          </div>
        `,
      });
      console.log(`Alert email sent to ${emailRecipients.join(', ')}`);
    }

    return {
      statusCode: 200,
      body: JSON.stringify({
        checked: true,
        lowStocks: lowStocks.length,
        avoirsPending: avoirs.length,
        alertsCreated: alerts.length,
      }),
    };
  } catch (err) {
    console.error('check-alerts error:', err);
    return { statusCode: 500, body: JSON.stringify({ error: err.message }) };
  }
};

function todayISO() {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}T00:00:00`;
}
