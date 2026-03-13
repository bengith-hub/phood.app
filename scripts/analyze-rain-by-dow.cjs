/**
 * Analyse de l'impact de la pluie par jour de semaine
 * Hypothèse : le samedi pluvieux a un boost PLUS FORT que les autres jours
 *
 * Méthode :
 * 1. Charger 14 mois de ventes + météo
 * 2. Normaliser chaque jour par la moyenne de son DOW (isoler l'effet météo)
 * 3. Comparer les ratios par DOW × catégorie pluie
 * 4. Simuler l'impact sur la précision des prévisions avec coefficients différenciés
 */
const https = require('https')

const SUPABASE_URL = 'https://pfcvtpavwjchwdarhixc.supabase.co'
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'

function restGet(endpoint) {
  return new Promise((resolve, reject) => {
    const url = new URL(`/rest/v1/${endpoint}`, SUPABASE_URL)
    const options = {
      hostname: url.hostname,
      path: url.pathname + url.search,
      method: 'GET',
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
        'Content-Type': 'application/json',
      },
    }
    const req = https.request(options, (res) => {
      let body = ''
      res.on('data', (chunk) => body += chunk)
      res.on('end', () => {
        try { resolve(JSON.parse(body)) }
        catch { reject(new Error(`Parse error: ${body.slice(0, 200)}`)) }
      })
    })
    req.on('error', reject)
    req.end()
  })
}

const JOURS = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']

// Jours fériés 2025
function isJourFerie(dateStr) {
  const feries = [
    '2025-01-01', '2025-04-21', '2025-05-01', '2025-05-08',
    '2025-05-29', '2025-06-09', '2025-07-14', '2025-08-15',
    '2025-11-01', '2025-11-11', '2025-12-25',
    '2026-01-01', '2026-04-06', '2026-05-01', '2026-05-08',
    '2026-05-14', '2026-05-25', '2026-07-14', '2026-08-15',
    '2026-11-01', '2026-11-11', '2026-12-25',
  ]
  return feries.includes(dateStr)
}

function trimmedMean(arr, trimPct = 0.1) {
  if (arr.length < 3) return arr.reduce((a, b) => a + b, 0) / arr.length
  const sorted = [...arr].sort((a, b) => a - b)
  const trim = Math.max(1, Math.floor(sorted.length * trimPct))
  const trimmed = sorted.slice(trim, sorted.length - trim)
  return trimmed.reduce((a, b) => a + b, 0) / trimmed.length
}

function median(arr) {
  const sorted = [...arr].sort((a, b) => a - b)
  const mid = Math.floor(sorted.length / 2)
  return sorted.length % 2 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2
}

function stddev(arr) {
  const avg = arr.reduce((a, b) => a + b, 0) / arr.length
  return Math.sqrt(arr.reduce((s, v) => s + (v - avg) ** 2, 0) / arr.length)
}

async function main() {
  console.log('=== ANALYSE IMPACT PLUIE PAR JOUR DE SEMAINE ===\n')

  // 1. Load data
  const since = new Date()
  since.setMonth(since.getMonth() - 14)
  const sinceStr = since.toISOString().slice(0, 10)

  const ventes = await restGet(`ventes_historique?select=*&date=gte.${sinceStr}&order=date.asc`)
  const meteo = await restGet(`meteo_daily?select=*&date=gte.${sinceStr}&order=date.asc`)
  const evenements = await restGet(`evenements?select=*&order=date_debut.asc`)

  const validated = ventes.filter(v => v.cloture_validee && v.ca_ttc > 0)
  console.log(`Données: ${validated.length} jours validés, ${meteo.length} jours météo`)

  const meteoMap = new Map()
  for (const m of meteo) meteoMap.set(m.date, m)

  // Filter: exclude Mondays (closed), holidays, and days without meteo
  const data = validated
    .filter(v => {
      const d = new Date(v.date + 'T00:00:00')
      return d.getDay() !== 0 && d.getDay() !== 1 && !isJourFerie(v.date) && meteoMap.has(v.date)
    })
    .map(v => ({
      ...v,
      meteo: meteoMap.get(v.date),
      dow: new Date(v.date + 'T00:00:00').getDay(),
    }))

  console.log(`Jours exploitables (hors dim/lun/fériés, avec météo): ${data.length}\n`)

  // 2. Compute DOW averages (dry days only, to get a "neutral weather" baseline)
  const dryByDow = {}
  for (let d = 2; d <= 6; d++) dryByDow[d] = []

  for (const v of data) {
    const precip = v.meteo.precipitation_mm ?? 0
    if (precip < 1) dryByDow[v.dow]?.push(v.ca_ttc)
  }

  const dowDryAvg = {}
  for (let d = 2; d <= 6; d++) {
    const vals = dryByDow[d] || []
    dowDryAvg[d] = vals.length > 0 ? trimmedMean(vals) : null
  }

  console.log('--- Moyennes DOW (jours SECS, < 1mm) ---')
  for (let d = 2; d <= 6; d++) {
    console.log(`  ${JOURS[d]}: ${dowDryAvg[d] ? Math.round(dowDryAvg[d]) + '€' : 'N/A'}  (n=${(dryByDow[d] || []).length})`)
  }

  // Also compute overall DOW averages (all weather)
  const allByDow = {}
  for (let d = 2; d <= 6; d++) allByDow[d] = []
  for (const v of data) allByDow[v.dow]?.push(v.ca_ttc)

  const dowAllAvg = {}
  for (let d = 2; d <= 6; d++) {
    dowAllAvg[d] = allByDow[d].length > 0 ? trimmedMean(allByDow[d]) : null
  }

  // ============================================================
  // 3. IMPACT PLUIE PAR JOUR DE SEMAINE (normalisé par moyenne jours secs)
  // ============================================================
  console.log('\n' + '='.repeat(70))
  console.log('IMPACT PLUIE PAR JOUR DE SEMAINE (normalisé par moyenne jours secs du même DOW)')
  console.log('='.repeat(70))

  const rainCategories = [
    { name: 'Sec (<1mm)', min: 0, max: 1 },
    { name: 'Léger (1-5mm)', min: 1, max: 5 },
    { name: 'Fort (>5mm)', min: 5, max: 999 },
    { name: 'Toute pluie (≥1mm)', min: 1, max: 999 },
  ]

  for (const cat of rainCategories) {
    console.log(`\n  --- ${cat.name} ---`)
    const allRatios = []

    for (let d = 2; d <= 6; d++) {
      if (!dowDryAvg[d]) continue

      const matching = data.filter(v =>
        v.dow === d &&
        (v.meteo.precipitation_mm ?? 0) >= cat.min &&
        (v.meteo.precipitation_mm ?? 0) < cat.max
      )

      const ratios = matching.map(v => v.ca_ttc / dowDryAvg[d])

      if (matching.length === 0) {
        console.log(`    ${JOURS[d]}: aucune donnée`)
        continue
      }

      const avg = trimmedMean(ratios)
      const med = median(ratios)
      const sd = ratios.length > 2 ? stddev(ratios) : 0
      const pct = ((avg - 1) * 100).toFixed(1)
      const se = ratios.length > 2 ? (sd / Math.sqrt(ratios.length)) : 0
      const tStat = se > 0 ? ((avg - 1) / se) : 0
      const sig = Math.abs(tStat) > 2 ? '**' : Math.abs(tStat) > 1.5 ? '*' : ''

      console.log(`    ${JOURS[d]}: ratio=${avg.toFixed(3)} (${pct > 0 ? '+' : ''}${pct}%)  ` +
        `médiane=${med.toFixed(3)}  σ=${sd.toFixed(3)}  n=${matching.length}  t=${tStat.toFixed(2)} ${sig}`)

      if (cat.min >= 1) {
        for (const r of ratios) allRatios.push(r)
      }
    }

    if (cat.min >= 1 && allRatios.length > 0) {
      // Split samedi vs reste
      const samRatios = data
        .filter(v => v.dow === 6 && (v.meteo.precipitation_mm ?? 0) >= cat.min && (v.meteo.precipitation_mm ?? 0) < cat.max)
        .map(v => v.ca_ttc / dowDryAvg[6])
      const semaineRatios = data
        .filter(v => v.dow >= 2 && v.dow <= 5 && (v.meteo.precipitation_mm ?? 0) >= cat.min && (v.meteo.precipitation_mm ?? 0) < cat.max)
        .map(v => v.ca_ttc / dowDryAvg[v.dow])

      if (samRatios.length >= 3 && semaineRatios.length >= 3) {
        const avgSam = trimmedMean(samRatios)
        const avgSem = trimmedMean(semaineRatios)
        const diff = ((avgSam - avgSem) * 100).toFixed(1)

        // Welch t-test
        const sdSam = stddev(samRatios)
        const sdSem = stddev(semaineRatios)
        const pooledSE = Math.sqrt((sdSam ** 2 / samRatios.length) + (sdSem ** 2 / semaineRatios.length))
        const tWelch = pooledSE > 0 ? ((avgSam - avgSem) / pooledSE) : 0

        console.log(`\n    >>> SAMEDI vs SEMAINE: Sam=${(avgSam * 100 - 100).toFixed(1)}%  Sem=${(avgSem * 100 - 100).toFixed(1)}%  ` +
          `Δ=${diff}pts  t-Welch=${tWelch.toFixed(2)} ${Math.abs(tWelch) > 2 ? '**SIGNIF**' : Math.abs(tWelch) > 1.5 ? '*tendance*' : '(ns)'}`)
      }
    }
  }

  // ============================================================
  // 4. DÉTAIL SAMEDIS PLUVIEUX
  // ============================================================
  console.log('\n' + '='.repeat(70))
  console.log('DÉTAIL: TOUS LES SAMEDIS PLUVIEUX (≥1mm)')
  console.log('='.repeat(70))

  const samPluvieux = data
    .filter(v => v.dow === 6 && (v.meteo.precipitation_mm ?? 0) >= 1)
    .sort((a, b) => a.date.localeCompare(b.date))

  for (const v of samPluvieux) {
    const ratio = v.ca_ttc / dowDryAvg[6]
    const precip = v.meteo.precipitation_mm
    const sun = ((v.meteo.ensoleillement_secondes ?? 0) / 3600).toFixed(1)
    const cloud = v.meteo.couverture_nuageuse_pct
    console.log(`  ${v.date}  CA=${Math.round(v.ca_ttc).toString().padStart(5)}€  ` +
      `ratio=${ratio.toFixed(3)} (${((ratio - 1) * 100).toFixed(1).padStart(5)}%)  ` +
      `pluie=${precip.toFixed(1)}mm  soleil=${sun}h  nuages=${cloud}%`)
  }

  // ============================================================
  // 5. SIMULATION: coefficients pluie différenciés samedi vs semaine
  // ============================================================
  console.log('\n' + '='.repeat(70))
  console.log('SIMULATION: IMPACT SUR PRÉCISION AVEC COEFFICIENTS DIFFÉRENCIÉS')
  console.log('='.repeat(70))

  // Current coefficients (same for all days)
  const CURRENT = {
    light: 1.04,  // 1-5mm
    heavy: 1.07,  // >5mm
  }

  // Calculate optimal coefficients per group
  const samLight = data.filter(v => v.dow === 6 && (v.meteo.precipitation_mm ?? 0) >= 1 && (v.meteo.precipitation_mm ?? 0) < 5)
    .map(v => v.ca_ttc / dowDryAvg[6])
  const samHeavy = data.filter(v => v.dow === 6 && (v.meteo.precipitation_mm ?? 0) >= 5)
    .map(v => v.ca_ttc / dowDryAvg[6])
  const semLight = data.filter(v => v.dow >= 2 && v.dow <= 5 && (v.meteo.precipitation_mm ?? 0) >= 1 && (v.meteo.precipitation_mm ?? 0) < 5)
    .map(v => v.ca_ttc / dowDryAvg[v.dow])
  const semHeavy = data.filter(v => v.dow >= 2 && v.dow <= 5 && (v.meteo.precipitation_mm ?? 0) >= 5)
    .map(v => v.ca_ttc / dowDryAvg[v.dow])

  const optSamLight = samLight.length >= 3 ? trimmedMean(samLight) : CURRENT.light
  const optSamHeavy = samHeavy.length >= 3 ? trimmedMean(samHeavy) : CURRENT.heavy
  const optSemLight = semLight.length >= 3 ? trimmedMean(semLight) : CURRENT.light
  const optSemHeavy = semHeavy.length >= 3 ? trimmedMean(semHeavy) : CURRENT.heavy

  console.log('\n  Coefficients ACTUELS (identiques tous les jours):')
  console.log(`    Pluie légère (1-5mm): +${((CURRENT.light - 1) * 100).toFixed(0)}%`)
  console.log(`    Pluie forte (>5mm):   +${((CURRENT.heavy - 1) * 100).toFixed(0)}%`)

  console.log('\n  Coefficients OBSERVÉS (différenciés):')
  console.log(`    SEMAINE pluie légère: +${((optSemLight - 1) * 100).toFixed(1)}%  (n=${semLight.length})`)
  console.log(`    SEMAINE pluie forte:  +${((optSemHeavy - 1) * 100).toFixed(1)}%  (n=${semHeavy.length})`)
  console.log(`    SAMEDI  pluie légère: +${((optSamLight - 1) * 100).toFixed(1)}%  (n=${samLight.length})`)
  console.log(`    SAMEDI  pluie forte:  +${((optSamHeavy - 1) * 100).toFixed(1)}%  (n=${samHeavy.length})`)

  // Round to sensible increments
  const round5 = (v) => Math.round(v * 20) / 20 // Round to nearest 0.05
  const proposedSamLight = Math.max(1.0, Math.min(1.25, round5(optSamLight)))
  const proposedSamHeavy = Math.max(1.0, Math.min(1.30, round5(optSamHeavy)))
  const proposedSemLight = Math.max(1.0, Math.min(1.15, round5(optSemLight)))
  const proposedSemHeavy = Math.max(1.0, Math.min(1.20, round5(optSemHeavy)))

  console.log('\n  Coefficients PROPOSÉS (arrondis):')
  console.log(`    SEMAINE pluie légère: +${((proposedSemLight - 1) * 100).toFixed(0)}%`)
  console.log(`    SEMAINE pluie forte:  +${((proposedSemHeavy - 1) * 100).toFixed(0)}%`)
  console.log(`    SAMEDI  pluie légère: +${((proposedSamLight - 1) * 100).toFixed(0)}%`)
  console.log(`    SAMEDI  pluie forte:  +${((proposedSamHeavy - 1) * 100).toFixed(0)}%`)

  // ============================================================
  // 6. BACKTESTING: comparaison erreur avec les 2 systèmes
  // ============================================================
  console.log('\n' + '='.repeat(70))
  console.log('BACKTESTING: ERREUR DE PRÉVISION SUR 10 DERNIERS MOIS')
  console.log('='.repeat(70))

  const tenMonthsAgo = new Date()
  tenMonthsAgo.setMonth(tenMonthsAgo.getMonth() - 10)
  const cutoff = tenMonthsAgo.toISOString().slice(0, 10)

  const testData = data.filter(v => v.date >= cutoff)
  console.log(`\n  Période test: ${cutoff} → aujourd'hui (${testData.length} jours)`)

  let errorsCurrent = { all: [], sam: [], sem: [], samRain: [], semRain: [] }
  let errorsProposed = { all: [], sam: [], sem: [], samRain: [], semRain: [] }

  for (const v of testData) {
    const precip = v.meteo.precipitation_mm ?? 0
    const baseCA = dowDryAvg[v.dow]
    if (!baseCA) continue

    // Current system: same coeff for all days
    let coeffCurrent = 1
    if (precip >= 5) coeffCurrent = CURRENT.heavy
    else if (precip >= 1) coeffCurrent = CURRENT.light

    // Proposed system: different coeff for samedi
    let coeffProposed = 1
    if (v.dow === 6) {
      if (precip >= 5) coeffProposed = proposedSamHeavy
      else if (precip >= 1) coeffProposed = proposedSamLight
    } else {
      if (precip >= 5) coeffProposed = proposedSemHeavy
      else if (precip >= 1) coeffProposed = proposedSemLight
    }

    const prevCurrent = baseCA * coeffCurrent
    const prevProposed = baseCA * coeffProposed

    const errCurrent = (prevCurrent - v.ca_ttc) / v.ca_ttc
    const errProposed = (prevProposed - v.ca_ttc) / v.ca_ttc

    errorsCurrent.all.push(errCurrent)
    errorsProposed.all.push(errProposed)

    if (v.dow === 6) {
      errorsCurrent.sam.push(errCurrent)
      errorsProposed.sam.push(errProposed)
      if (precip >= 1) {
        errorsCurrent.samRain.push(errCurrent)
        errorsProposed.samRain.push(errProposed)
      }
    } else {
      errorsCurrent.sem.push(errCurrent)
      errorsProposed.sem.push(errProposed)
      if (precip >= 1) {
        errorsCurrent.semRain.push(errCurrent)
        errorsProposed.semRain.push(errProposed)
      }
    }
  }

  function printErrors(label, current, proposed) {
    if (current.length === 0) return
    const maeCurr = current.reduce((s, e) => s + Math.abs(e), 0) / current.length
    const maeProp = proposed.reduce((s, e) => s + Math.abs(e), 0) / proposed.length
    const biasCurr = current.reduce((s, e) => s + e, 0) / current.length
    const biasProp = proposed.reduce((s, e) => s + e, 0) / proposed.length
    const rmseCurr = Math.sqrt(current.reduce((s, e) => s + e * e, 0) / current.length)
    const rmseProp = Math.sqrt(proposed.reduce((s, e) => s + e * e, 0) / proposed.length)

    const improvement = ((maeCurr - maeProp) / maeCurr * 100).toFixed(1)

    console.log(`\n  ${label} (n=${current.length}):`)
    console.log(`    ACTUEL:   MAE=${(maeCurr * 100).toFixed(1)}%  Biais=${(biasCurr * 100).toFixed(1)}%  RMSE=${(rmseCurr * 100).toFixed(1)}%`)
    console.log(`    PROPOSÉ:  MAE=${(maeProp * 100).toFixed(1)}%  Biais=${(biasProp * 100).toFixed(1)}%  RMSE=${(rmseProp * 100).toFixed(1)}%`)
    console.log(`    Amélioration MAE: ${improvement}%`)
  }

  printErrors('TOUS LES JOURS', errorsCurrent.all, errorsProposed.all)
  printErrors('SAMEDIS uniquement', errorsCurrent.sam, errorsProposed.sam)
  printErrors('SEMAINE (mar-ven)', errorsCurrent.sem, errorsProposed.sem)
  printErrors('SAMEDIS PLUVIEUX', errorsCurrent.samRain, errorsProposed.samRain)
  printErrors('SEMAINE PLUVIEUSE', errorsCurrent.semRain, errorsProposed.semRain)

  // ============================================================
  // 7. ANALYSE PAR TRANCHE HORAIRE (samedi pluvieux vs sec)
  // ============================================================
  console.log('\n' + '='.repeat(70))
  console.log('BONUS: IMPACT PLUIE PAR JOUR (vue granulaire)')
  console.log('='.repeat(70))

  // Show all DOW with their rain effect for quick visual comparison
  for (let d = 2; d <= 6; d++) {
    const dry = data.filter(v => v.dow === d && (v.meteo.precipitation_mm ?? 0) < 1)
    const wet = data.filter(v => v.dow === d && (v.meteo.precipitation_mm ?? 0) >= 1)

    if (dry.length < 3 || wet.length < 3) continue

    const dryAvg = trimmedMean(dry.map(v => v.ca_ttc))
    const wetAvg = trimmedMean(wet.map(v => v.ca_ttc))
    const boost = ((wetAvg / dryAvg - 1) * 100).toFixed(1)
    const bar = '█'.repeat(Math.max(0, Math.round(Math.abs(parseFloat(boost)) * 2)))

    console.log(`  ${JOURS[d]}: sec=${Math.round(dryAvg)}€ (n=${dry.length})  pluie=${Math.round(wetAvg)}€ (n=${wet.length})  boost=${boost > 0 ? '+' : ''}${boost}% ${bar}`)
  }

  // ============================================================
  // 8. VENDREDI aussi ?
  // ============================================================
  console.log('\n' + '='.repeat(70))
  console.log('ANALYSE VENDREDI+SAMEDI vs MAR-JEU (2 groupes)')
  console.log('='.repeat(70))

  const weRatios = data
    .filter(v => (v.dow === 5 || v.dow === 6) && (v.meteo.precipitation_mm ?? 0) >= 1)
    .map(v => v.ca_ttc / dowDryAvg[v.dow])
  const midRatios = data
    .filter(v => v.dow >= 2 && v.dow <= 4 && (v.meteo.precipitation_mm ?? 0) >= 1)
    .map(v => v.ca_ttc / dowDryAvg[v.dow])

  if (weRatios.length >= 3 && midRatios.length >= 3) {
    const avgWE = trimmedMean(weRatios)
    const avgMid = trimmedMean(midRatios)
    console.log(`  Ven+Sam pluvieux: +${((avgWE - 1) * 100).toFixed(1)}%  (n=${weRatios.length})`)
    console.log(`  Mar-Jeu pluvieux: +${((avgMid - 1) * 100).toFixed(1)}%  (n=${midRatios.length})`)
    console.log(`  Δ = ${((avgWE - avgMid) * 100).toFixed(1)} points`)
  }

  console.log('\n=== FIN DE L\'ANALYSE ===')
}

main().catch(console.error)
