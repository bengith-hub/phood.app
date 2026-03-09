/**
 * Netlify Function: Enrich suppliers from PennyLane
 *
 * POST /.netlify/functions/enrich-suppliers-pennylane
 * Body: { dry_run?: boolean, auto_apply?: boolean }
 *
 * Fetches all suppliers from PennyLane API, matches them to fournisseurs
 * by name (fuzzy), and optionally updates SIRET, address, phone,
 * payment conditions, and pennylane_supplier_id.
 *
 * Returns { matches, unmatched, applied, errors }
 */

const PENNYLANE_BASE_URL = 'https://app.pennylane.com/api/external/v2';

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const PENNYLANE_TOKEN = process.env.PENNYLANE_API_TOKEN;
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!PENNYLANE_TOKEN) {
    return { statusCode: 500, body: JSON.stringify({ error: 'PENNYLANE_TOKEN non configuré' }) };
  }
  if (!SUPABASE_URL || !SUPABASE_KEY) {
    return { statusCode: 500, body: JSON.stringify({ error: 'Configuration Supabase manquante' }) };
  }

  try {
    const body = JSON.parse(event.body || '{}');
    const dryRun = body.dry_run === true;
    const autoApply = body.auto_apply === true;

    const results = {
      pennylane_suppliers_total: 0,
      fournisseurs_total: 0,
      matches: [],
      unmatched_pennylane: [],
      unmatched_fournisseurs: [],
      applied: 0,
      errors: 0,
      dry_run: dryRun,
    };

    // 1. Fetch all suppliers from PennyLane (cursor-based pagination, v2 API)
    let allPLSuppliers = [];
    let cursor = null;
    let hasMore = true;

    while (hasMore) {
      const params = new URLSearchParams({ limit: '100' });
      if (cursor) params.set('cursor', cursor);

      const url = `${PENNYLANE_BASE_URL}/suppliers?${params}`;
      const resp = await fetch(url, {
        headers: {
          'Authorization': `Bearer ${PENNYLANE_TOKEN}`,
          'Accept': 'application/json',
        },
      });

      if (!resp.ok) {
        const errText = await resp.text();
        throw new Error(`PennyLane API error ${resp.status}: ${errText}`);
      }

      const data = await resp.json();
      const suppliers = data.items || data.suppliers || [];
      allPLSuppliers.push(...suppliers);

      hasMore = data.has_more === true;
      cursor = data.next_cursor || null;

      // Rate limiting
      if (hasMore) {
        await new Promise(r => setTimeout(r, 250));
      }
    }

    results.pennylane_suppliers_total = allPLSuppliers.length;

    // 2. Fetch all fournisseurs from Supabase
    const fournisseursResp = await fetch(
      `${SUPABASE_URL}/rest/v1/fournisseurs?select=id,nom,siret,adresse,telephone,conditions_paiement,pennylane_supplier_id,email_commande`,
      {
        headers: {
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'Accept': 'application/json',
        },
      }
    );

    if (!fournisseursResp.ok) {
      throw new Error(`Supabase fetch error: ${fournisseursResp.status}`);
    }

    const fournisseurs = await fournisseursResp.json();
    results.fournisseurs_total = fournisseurs.length;

    // 3. Match PennyLane suppliers to fournisseurs by name
    const normalize = (name) => {
      return (name || '')
        .toLowerCase()
        .trim()
        .replace(/\s+/g, ' ')
        .replace(/[éèêë]/g, 'e')
        .replace(/[àâä]/g, 'a')
        .replace(/[ùûü]/g, 'u')
        .replace(/[ôö]/g, 'o')
        .replace(/[îï]/g, 'i')
        .replace(/[ç]/g, 'c')
        .replace(/[-_.']/g, ' ')
        .replace(/\b(sarl|sas|sa|eurl|srl|scp)\b/g, '')
        .trim();
    };

    const matchedPLIds = new Set();
    const matchedFournisseurIds = new Set();

    for (const f of fournisseurs) {
      const fNorm = normalize(f.nom);

      // First: check if already linked by pennylane_supplier_id
      if (f.pennylane_supplier_id) {
        const plMatch = allPLSuppliers.find(
          pl => String(pl.id || pl.source_id) === String(f.pennylane_supplier_id)
        );
        if (plMatch) {
          matchedPLIds.add(pl_id(plMatch));
          matchedFournisseurIds.add(f.id);
          addMatch(results, f, plMatch, 'id_match');
          continue;
        }
      }

      // Second: fuzzy name matching
      let bestMatch = null;
      let bestScore = 0;

      for (const pl of allPLSuppliers) {
        if (matchedPLIds.has(pl_id(pl))) continue;

        const plNorm = normalize(pl.name);
        const score = nameSimilarity(fNorm, plNorm);

        if (score > bestScore && score >= 0.6) {
          bestScore = score;
          bestMatch = pl;
        }
      }

      if (bestMatch) {
        matchedPLIds.add(pl_id(bestMatch));
        matchedFournisseurIds.add(f.id);
        addMatch(results, f, bestMatch, `name_match (${Math.round(bestScore * 100)}%)`);
      }
    }

    // Unmatched
    results.unmatched_pennylane = allPLSuppliers
      .filter(pl => !matchedPLIds.has(pl_id(pl)))
      .map(pl => ({ name: pl.name, id: pl_id(pl) }));

    results.unmatched_fournisseurs = fournisseurs
      .filter(f => !matchedFournisseurIds.has(f.id))
      .map(f => ({ id: f.id, nom: f.nom }));

    // 4. Auto-apply enrichment if requested
    if (autoApply && !dryRun) {
      for (const match of results.matches) {
        if (!match.enrichment || Object.keys(match.enrichment).length === 0) continue;

        const updateResp = await fetch(
          `${SUPABASE_URL}/rest/v1/fournisseurs?id=eq.${match.fournisseur_id}`,
          {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              'apikey': SUPABASE_KEY,
              'Authorization': `Bearer ${SUPABASE_KEY}`,
              'Prefer': 'return=minimal',
            },
            body: JSON.stringify(match.enrichment),
          }
        );

        if (updateResp.ok) {
          results.applied++;
          match.status = 'applied';
        } else {
          results.errors++;
          match.status = 'error';
          match.error = await updateResp.text();
        }

        await new Promise(r => setTimeout(r, 100));
      }
    }

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(results),
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: err.message || 'Erreur interne' }),
    };
  }
};

/** Get the best ID from a PennyLane supplier (v2 uses id, v1 used source_id) */
function pl_id(pl) {
  return String(pl.id || pl.source_id || pl.v2_id || '');
}

/** Build an enrichment record from PennyLane data */
function addMatch(results, fournisseur, plSupplier, matchType) {
  const enrichment = {};

  // pennylane_supplier_id — always set if not already linked
  const plId = pl_id(plSupplier);
  if (plId && fournisseur.pennylane_supplier_id !== plId) {
    enrichment.pennylane_supplier_id = plId;
  }

  // SIRET from reg_no (SIREN = 9 digits, PennyLane returns SIREN)
  if (plSupplier.reg_no && !fournisseur.siret) {
    enrichment.siret = plSupplier.reg_no;
  }

  // Address
  const addressParts = [
    plSupplier.address,
    plSupplier.postal_code,
    plSupplier.city,
  ].filter(Boolean);
  if (addressParts.length > 0 && !fournisseur.adresse) {
    enrichment.adresse = addressParts.join(', ');
  }

  // Phone
  if (plSupplier.phone && !fournisseur.telephone) {
    enrichment.telephone = plSupplier.phone;
  }

  // Payment conditions
  const conditionsMap = {
    'upon_receipt': 'À réception',
    '15_days': '15 jours',
    '30_days': '30 jours',
    '45_days': '45 jours',
    '60_days': '60 jours',
    'custom': 'Personnalisé',
  };
  if (plSupplier.payment_conditions && !fournisseur.conditions_paiement) {
    enrichment.conditions_paiement = conditionsMap[plSupplier.payment_conditions] || plSupplier.payment_conditions;
  }

  results.matches.push({
    fournisseur_id: fournisseur.id,
    fournisseur_nom: fournisseur.nom,
    pennylane_name: plSupplier.name,
    pennylane_id: plId,
    match_type: matchType,
    enrichment,
    status: Object.keys(enrichment).length > 0 ? 'enrichable' : 'already_complete',
  });
}

/** Simple name similarity score (Jaccard on word tokens) */
function nameSimilarity(a, b) {
  if (a === b) return 1;
  if (!a || !b) return 0;

  const wordsA = new Set(a.split(/\s+/).filter(w => w.length > 1));
  const wordsB = new Set(b.split(/\s+/).filter(w => w.length > 1));

  if (wordsA.size === 0 || wordsB.size === 0) return 0;

  let intersection = 0;
  for (const w of wordsA) {
    if (wordsB.has(w)) intersection++;
    // Also check if any word in B contains this word or vice versa
    else {
      for (const wb of wordsB) {
        if (wb.includes(w) || w.includes(wb)) {
          intersection += 0.7;
          break;
        }
      }
    }
  }

  const union = wordsA.size + wordsB.size - intersection;
  return intersection / union;
}
