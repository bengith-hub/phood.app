/**
 * Comparaison: Phood V7 (DOW + holiday proximity + streak + drift + DOW×weather) vs V6 vs inpulse
 */
const https = require('https')
const XLSX = require('/tmp/node_modules/xlsx')

const SUPABASE_URL = 'https://pfcvtpavwjchwdarhixc.supabase.co'
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'

function restGet(endpoint) {
  return new Promise((resolve, reject) => {
    const url = new URL(`/rest/v1/${endpoint}`, SUPABASE_URL)
    const req = https.request({ hostname: url.hostname, path: url.pathname + url.search, method: 'GET',
      headers: { 'apikey': SUPABASE_KEY, 'Authorization': `Bearer ${SUPABASE_KEY}`, 'Content-Type': 'application/json' }
    }, (res) => { let b = ''; res.on('data', c => b += c); res.on('end', () => { try { resolve(JSON.parse(b)) } catch { reject(b) } }) })
    req.on('error', reject); req.end()
  })
}

const JOURS = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']
const EW = [0.35, 0.25, 0.20, 0.12, 0.08]
const SEASONAL_AVG_TEMP = { 0: 7, 1: 8, 2: 11, 3: 14, 4: 17, 5: 21, 6: 23, 7: 23, 8: 20, 9: 15, 10: 10, 11: 7 }
const S3Y = { 0: 1.086, 1: 0.858, 2: 0.843, 3: 0.887, 4: 0.879, 5: 0.922, 6: 1.074, 7: 1.031, 8: 0.921, 9: 1.012, 10: 1.088, 11: 1.400 }

// French public holidays (Meeus/Jones/Butcher Easter)
function easterDate(year) {
  const a = year % 19, b = Math.floor(year / 100), c = year % 100
  const d = Math.floor(b / 4), e = b % 4, f = Math.floor((b + 8) / 25)
  const g = Math.floor((b - f + 1) / 3), h = (19 * a + b - d - g + 15) % 30
  const i = Math.floor(c / 4), k = c % 4, l = (32 + 2 * e + 2 * i - h - k) % 7
  const m = Math.floor((a + 11 * h + 22 * l) / 451)
  const month = Math.floor((h + l - 7 * m + 114) / 31) - 1
  const day = ((h + l - 7 * m + 114) % 31) + 1
  return new Date(year, month, day)
}
function getFeries(year) {
  const e = easterDate(year), lp = new Date(e); lp.setDate(lp.getDate() + 1)
  const asc = new Date(e); asc.setDate(asc.getDate() + 39)
  const pent = new Date(e); pent.setDate(pent.getDate() + 50)
  return [new Date(year, 0, 1), lp, new Date(year, 4, 1), new Date(year, 4, 8), asc, pent,
    new Date(year, 6, 14), new Date(year, 7, 15), new Date(year, 10, 1), new Date(year, 10, 11), new Date(year, 11, 25)]
    .map(d => d.toISOString().slice(0, 10))
}
const FERIES = new Set([...getFeries(2025), ...getFeries(2026)])
function isFerie(ds) { return FERIES.has(ds) }

async function main() {
  // Load inpulse
  const wb = XLSX.readFile('/Users/ben/Downloads/previsions-chiffre-d-affaires (1).xlsx')
  const rows = XLSX.utils.sheet_to_json(wb.Sheets['Prévisions'], { header: 1 }).slice(1)
  const inpulseMap = new Map()
  for (const r of rows) {
    if (r[3] && r[4] != null && r[6] != null) inpulseMap.set(r[3], { prev: Math.round(r[4]), reel: r[6] })
  }

  // Load Supabase
  const since = new Date(); since.setMonth(since.getMonth() - 14)
  const ventes = await restGet(`ventes_historique?select=*&date=gte.${since.toISOString().slice(0, 10)}&order=date.asc`)
  const meteoAll = await restGet(`meteo_daily?select=*&date=gte.${since.toISOString().slice(0, 10)}&order=date.asc`)
  const evts = await restGet(`evenements?select=*&order=date_debut.asc`)

  const val = ventes.filter(v => v.cloture_validee && v.ca_ttc > 0)
  const vMap = new Map(); val.forEach(v => vMap.set(v.date, v))
  const mMap = new Map(); meteoAll.forEach(m => mMap.set(m.date, m))

  const eDays = new Map()
  for (const e of evts) {
    const s = new Date(e.date_debut + 'T00:00:00'), en = new Date(e.date_fin + 'T00:00:00')
    for (let d = new Date(s); d <= en; d.setDate(d.getDate() + 1)) {
      const k = d.toISOString().slice(0, 10)
      if (!eDays.has(k)) eDays.set(k, [])
      eDays.get(k).push(e)
    }
  }

  // Seasonal indices
  const mData = {}; let gS = 0, gC = 0
  for (const v of val) { const d = new Date(v.date + 'T00:00:00'); if (d.getDay() === 0) continue; const m = d.getMonth(); if (!mData[m]) mData[m] = { s: 0, c: 0 }; mData[m].s += v.ca_ttc; mData[m].c++; gS += v.ca_ttc; gC++ }
  const gA = gS / gC; const sIdx = {}
  for (let m = 0; m < 12; m++) { const d = mData[m]; if (d && d.c >= 15) sIdx[m] = Math.max(0.8, Math.min(1.2, (d.s / d.c) / gA)); else sIdx[m] = Math.max(0.7, Math.min(1.3, S3Y[m] ?? 1)) }

  // Algorithm helpers
  function hist(td) { const r = []; for (let w = 1; w <= 8; w++) { const p = new Date(td); p.setDate(p.getDate() - w * 7); const v = vMap.get(p.toISOString().slice(0, 10)); if (v) r.push(v); if (r.length >= 5) break }; return r }
  function baseCA(td) { const h = hist(td).slice(0, 5); if (!h.length) return 0; const w = EW.slice(0, h.length), ws = w.reduce((a, b) => a + b, 0); const ts = sIdx[td.getMonth()] ?? 1; let b = 0; for (let i = 0; i < h.length; i++) { const hd = new Date(h[i].date + 'T00:00:00'); b += (h[i].ca_ttc / (sIdx[hd.getMonth()] ?? 1) * ts) * (w[i] / ws) }; return b }
  function tC(m) { if (!m || m.temperature_max === null) return 1; const a = (m.temperature_max + m.temperature_min) / 2, dv = Math.abs(a - (SEASONAL_AVG_TEMP[new Date(m.date + 'T00:00:00').getMonth()] ?? 15)); if (dv <= 10) return 1; return 0.7 + 0.3 * Math.exp(-((dv - 10) ** 2) / 128) }
  function wC(m) { if (!m) return 1; let c = 1; const p = m.precipitation_mm ?? 0; if (p > 5) c *= 1.07; else if (p >= 1) c *= 1.04; if (m.couverture_nuageuse_pct > 80) c *= 1.06; if (m.ensoleillement_secondes > 28800) c *= 0.93; return c * tC(m) }
  function sf(td) { const dow = td.getDay(); if (dow === 6) { const r = []; for (let w = 1; w <= 6; w++) { const d = new Date(td); d.setDate(d.getDate() - w * 7); const k = d.toISOString().slice(0, 10), v = vMap.get(k); if (!v) continue; const b = baseCA(d); if (b <= 0) continue; r.push(v.ca_ttc / (b * wC(mMap.get(k))) - 1) }; if (r.length < 2) return 0; return r.reduce((a, b) => a + b, 0) / r.length }; const LB = 14, HL = 5, lam = Math.LN2 / HL; let ws = 0, wt = 0; for (let i = 1; i <= LB; i++) { const d = new Date(td); d.setDate(d.getDate() - i); if (d.getDay() === 6) continue; const k = d.toISOString().slice(0, 10), v = vMap.get(k); if (!v) continue; const b = baseCA(d); if (b <= 0) continue; const w = Math.exp(-lam * i); ws += (v.ca_ttc / (b * wC(mMap.get(k))) - 1) * w; wt += w }; if (wt < 0.5) return 0; return ws / wt }
  function mPC(d) { const dom = d.getDate(), dim = new Date(d.getFullYear(), d.getMonth() + 1, 0).getDate(); if (dom >= dim - 4) return 1.06; if (dom >= 16 && dom <= 20) return 0.96; return 1 }

  // DOW corrections
  const tenMonthsAgo = new Date(); tenMonthsAgo.setMonth(tenMonthsAgo.getMonth() - 10)
  const cutoff = tenMonthsAgo.toISOString().slice(0, 10)
  const allRecent = val.filter(v => v.date >= cutoff && new Date(v.date + 'T00:00:00').getDay() !== 0)

  const dowRatios = {}, dowRatiosRainy = {}, dowRatiosSunny = {}
  for (const v of allRecent) {
    const d = new Date(v.date + 'T00:00:00')
    const dow = d.getDay()
    const b = baseCA(d)
    if (b <= 0) continue
    const m = mMap.get(v.date)
    const predicted = b * wC(m) * mPC(d)
    const evtList = eDays.get(v.date) || []
    let evtC = 1; for (const e of evtList) evtC *= e.coefficient
    const fullPred = predicted * evtC
    if (fullPred <= 0) continue
    const ratio = v.ca_ttc / fullPred
    if (!dowRatios[dow]) dowRatios[dow] = []
    dowRatios[dow].push(ratio)

    // Weather-conditional buckets
    const isRainy = m && m.precipitation_mm !== null && m.precipitation_mm > 2
    const isSunny = m && m.ensoleillement_secondes !== null && m.ensoleillement_secondes > 25200
    if (isRainy) { if (!dowRatiosRainy[dow]) dowRatiosRainy[dow] = []; dowRatiosRainy[dow].push(ratio) }
    else if (isSunny) { if (!dowRatiosSunny[dow]) dowRatiosSunny[dow] = []; dowRatiosSunny[dow].push(ratio) }
  }

  function trimMean(arr) {
    const sorted = [...arr].sort((a, b) => a - b)
    const trim = Math.max(1, Math.floor(sorted.length * 0.1))
    const trimmed = sorted.slice(trim, sorted.length - trim)
    return trimmed.reduce((a, b) => a + b, 0) / trimmed.length
  }

  const dowCorr = { 1: 1, 2: 1, 3: 1, 4: 1, 5: 1, 6: 1 }
  const dowCorrRainy = { 1: null, 2: null, 3: null, 4: null, 5: null, 6: null }
  const dowCorrSunny = { 1: null, 2: null, 3: null, 4: null, 5: null, 6: null }
  for (let d = 1; d <= 6; d++) {
    const r = dowRatios[d] || []; if (r.length >= 10) dowCorr[d] = Math.max(0.75, Math.min(1.25, trimMean(r)))
    const rr = dowRatiosRainy[d] || []; if (rr.length >= 5) dowCorrRainy[d] = Math.max(0.75, Math.min(1.25, trimMean(rr)))
    const rs = dowRatiosSunny[d] || []; if (rs.length >= 5) dowCorrSunny[d] = Math.max(0.75, Math.min(1.25, trimMean(rs)))
  }

  console.log('DOW corrections (overall | rainy | sunny):')
  for (let d = 1; d <= 6; d++) {
    const r = dowCorrRainy[d] !== null ? `x${dowCorrRainy[d].toFixed(3)}` : 'n/a'
    const s = dowCorrSunny[d] !== null ? `x${dowCorrSunny[d].toFixed(3)}` : 'n/a'
    console.log(`  ${JOURS[d]}: x${dowCorr[d].toFixed(3)} | rainy: ${r} (n=${(dowRatiosRainy[d]||[]).length}) | sunny: ${s} (n=${(dowRatiosSunny[d]||[]).length})`)
  }

  // Global drift (3-month rolling vs N-1)
  const now = new Date()
  const threeMonthsAgo = new Date(now); threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3)
  const driftCutoff = threeMonthsAgo.toISOString().slice(0, 10)
  const todayStr = now.toISOString().slice(0, 10)
  const n1Start = new Date(threeMonthsAgo); n1Start.setFullYear(n1Start.getFullYear() - 1)
  const n1End = new Date(now); n1End.setFullYear(n1End.getFullYear() - 1)
  let recentSum = 0, recentCt = 0, n1Sum = 0, n1Ct = 0
  for (const v of val) {
    if (v.date >= driftCutoff && v.date < todayStr) { recentSum += v.ca_ttc; recentCt++ }
    if (v.date >= n1Start.toISOString().slice(0, 10) && v.date <= n1End.toISOString().slice(0, 10)) { n1Sum += v.ca_ttc; n1Ct++ }
  }
  let drift = 1
  if (recentCt >= 40 && n1Ct >= 40) {
    drift = (recentSum / recentCt) / (n1Sum / n1Ct)
    if (Math.abs(drift - 1) < 0.03) drift = 1
    else drift = Math.max(0.90, Math.min(1.10, drift))
  }
  console.log(`\nGlobal drift: ${drift.toFixed(3)} (recent ${recentCt} days avg ${Math.round(recentSum/recentCt)}€ vs N-1 ${n1Ct} days avg ${Math.round(n1Sum/n1Ct)}€)`)

  // Holiday proximity helper
  function holidayProx(ds) {
    if (isFerie(ds)) return 1 // today is férié — already in event coeff
    const d = new Date(ds + 'T00:00:00')
    const dow = d.getDay()
    const tom = new Date(d); tom.setDate(d.getDate() + 1); const tomS = tom.toISOString().slice(0, 10)
    const yes = new Date(d); yes.setDate(d.getDate() - 1); const yesS = yes.toISOString().slice(0, 10)
    const tomF = isFerie(tomS), yesF = isFerie(yesS)
    // Pont: Friday after Thursday férié OR Monday before Tuesday férié
    if ((dow === 5 && yesF) || (dow === 1 && tomF)) return 1.05
    if (tomF) return 1.03 // veille
    if (yesF) return 0.97 // lendemain
    return 1
  }

  // Streak detection (conservative: ALL 5 days must be off by >8%, capped ±3%)
  function streakCoeff(td) {
    const ratios = []
    for (let i = 1; i <= 10 && ratios.length < 5; i++) {
      const d = new Date(td); d.setDate(d.getDate() - i)
      if (d.getDay() === 0) continue
      const k = d.toISOString().slice(0, 10)
      const v = vMap.get(k)
      if (!v || !v.cloture_validee || v.ca_ttc <= 0) continue
      const b = baseCA(d); if (b <= 0) continue
      const m = mMap.get(k)
      const pred = b * wC(m) * mPC(d) * (dowCorr[d.getDay()] ?? 1)
      const evtList = eDays.get(k) || []
      let evtC = 1; for (const e of evtList) evtC *= e.coefficient
      const fullPred = pred * evtC
      if (fullPred <= 0) continue
      ratios.push(v.ca_ttc / fullPred)
    }
    if (ratios.length < 5) return 1
    const above = ratios.filter(r => r > 1.08).length
    const below = ratios.filter(r => r < 0.92).length
    if (above === 5) {
      const avg = ratios.reduce((s, r) => s + (r - 1), 0) / ratios.length
      return Math.min(1.03, 1 + avg * 0.2)
    }
    if (below === 5) {
      const avg = ratios.reduce((s, r) => s + (r - 1), 0) / ratios.length
      return Math.max(0.97, 1 + avg * 0.2)
    }
    return 1
  }

  // V6 forecast (DOW correction only)
  function fcV6(ds) {
    const d = new Date(ds + 'T00:00:00'); if (d.getDay() === 0) return null
    const b = baseCA(d); if (b <= 0) return null
    let c = wC(mMap.get(ds)); const s = sf(d); if (Math.abs(s) > 0.02) c *= (1 + s)
    c *= mPC(d); c *= dowCorr[d.getDay()] ?? 1
    const e = eDays.get(ds) || []; for (const ev of e) c *= ev.coefficient
    return Math.round(b * c)
  }

  // V7 forecast (DOW + holiday proximity + streak + drift + DOW×weather)
  function fcV7(ds) {
    const d = new Date(ds + 'T00:00:00'); if (d.getDay() === 0) return null
    const b = baseCA(d); if (b <= 0) return null
    const m = mMap.get(ds)
    let c = wC(m); const s = sf(d); if (Math.abs(s) > 0.02) c *= (1 + s)
    c *= mPC(d)
    // DOW×weather conditional correction
    const dow = d.getDay()
    const isRainy = m && m.precipitation_mm !== null && m.precipitation_mm > 2
    const isSunny = m && m.ensoleillement_secondes !== null && m.ensoleillement_secondes > 25200
    let dc = dowCorr[dow] ?? 1
    // Only use weather-conditional when difference >5% from overall
    if (isRainy && dowCorrRainy[dow] !== null && Math.abs(dowCorrRainy[dow] - dc) > 0.05) dc = dowCorrRainy[dow]
    else if (isSunny && dowCorrSunny[dow] !== null && Math.abs(dowCorrSunny[dow] - dc) > 0.05) dc = dowCorrSunny[dow]
    c *= dc
    // Holiday proximity
    c *= holidayProx(ds)
    // Streak detection
    c *= streakCoeff(d)
    // Global drift
    c *= drift
    // Events
    const e = eDays.get(ds) || []; for (const ev of e) c *= ev.coefficient
    return Math.round(b * c)
  }

  // ===== COMPARE =====
  console.log('\n' + '='.repeat(95))
  console.log('COMPARAISON: Phood V6 (DOW) | Phood V7 (DOW+prox+streak+drift+wx) | inpulse')
  console.log('='.repeat(95))

  let v6Abs = 0, v6Err = 0, v7Abs = 0, v7Err = 0, iAbs = 0, iErr = 0, cnt = 0
  const dowStats = {}
  const weekData = {}
  let v6Wins = 0, v7Wins = 0, iWins = 0

  const sortedDates = [...inpulseMap.keys()].sort()
  console.log('\n  Date         Jour  Réel   V6prev  err%   V7prev  err%   inpulse  err%   Gagnant')
  console.log('  ' + '-'.repeat(90))

  for (const date of sortedDates) {
    const inp = inpulseMap.get(date)
    const d = new Date(date + 'T00:00:00')
    if (d.getDay() === 0) continue

    const pV6 = fcV6(date), pV7 = fcV7(date)
    if (pV6 === null || pV7 === null) continue

    const reel = inp.reel
    const eV6 = (pV6 - reel) / reel, eV7 = (pV7 - reel) / reel, eI = (inp.prev - reel) / reel

    v6Abs += Math.abs(eV6); v6Err += eV6
    v7Abs += Math.abs(eV7); v7Err += eV7
    iAbs += Math.abs(eI); iErr += eI; cnt++

    const winner = Math.abs(eV7) <= Math.abs(eI) ? 'PHOOD' : 'inpulse'
    if (Math.abs(eV7) < Math.abs(eI)) v7Wins++; else if (Math.abs(eI) < Math.abs(eV7)) iWins++

    const dow = d.getDay()
    if (!dowStats[dow]) dowStats[dow] = { v6A: 0, v6E: 0, v7A: 0, v7E: 0, iA: 0, iE: 0, n: 0 }
    dowStats[dow].v6A += Math.abs(eV6); dowStats[dow].v6E += eV6
    dowStats[dow].v7A += Math.abs(eV7); dowStats[dow].v7E += eV7
    dowStats[dow].iA += Math.abs(eI); dowStats[dow].iE += eI; dowStats[dow].n++

    const wk = new Date(d); wk.setDate(d.getDate() - ((d.getDay() + 6) % 7))
    const wkKey = wk.toISOString().slice(0, 10)
    if (!weekData[wkKey]) weekData[wkKey] = { v6: 0, v7: 0, inp: 0, r: 0 }
    weekData[wkKey].v6 += pV6; weekData[wkKey].v7 += pV7; weekData[wkKey].inp += inp.prev; weekData[wkKey].r += reel

    // Show new factors when they differ from V6
    const hp = holidayProx(date)
    const sk = streakCoeff(d)
    const isRainy = mMap.get(date)?.precipitation_mm > 2
    const isSunny = mMap.get(date)?.ensoleillement_secondes > 25200
    const dcOverall = dowCorr[d.getDay()] ?? 1
    let dcUsed = dcOverall
    if (isRainy && dowCorrRainy[d.getDay()] !== null) dcUsed = dowCorrRainy[d.getDay()]
    else if (isSunny && dowCorrSunny[d.getDay()] !== null) dcUsed = dowCorrSunny[d.getDay()]
    const extraFlags = []
    if (hp !== 1) extraFlags.push(`prox:${hp.toFixed(2)}`)
    if (sk !== 1) extraFlags.push(`streak:${sk.toFixed(2)}`)
    if (Math.abs(dcUsed - dcOverall) > 0.01) extraFlags.push(`wx:${dcUsed.toFixed(2)}`)
    if (drift !== 1) extraFlags.push(`drift:${drift.toFixed(2)}`)
    const flags = extraFlags.length ? ` [${extraFlags.join(',')}]` : ''

    console.log(`  ${date}  ${JOURS[d.getDay()].padEnd(4)} ${String(Math.round(reel)).padStart(5)}€ ${String(pV6).padStart(6)}€ ${String((eV6 * 100).toFixed(0)).padStart(5)}% ${String(pV7).padStart(6)}€ ${String((eV7 * 100).toFixed(0)).padStart(5)}%  ${String(inp.prev).padStart(6)}€ ${String((eI * 100).toFixed(0)).padStart(5)}%   ${winner}${flags}`)
  }

  console.log('\n' + '='.repeat(95))
  console.log('  RESULTATS GLOBAUX')
  console.log('='.repeat(95))
  console.log(`  Jours: ${cnt}  |  Phood V7 gagne: ${v7Wins} (${(v7Wins / cnt * 100).toFixed(0)}%)  |  inpulse: ${iWins} (${(iWins / cnt * 100).toFixed(0)}%)`)
  console.log()
  console.log(`  ${''.padEnd(18)} Phood V6     Phood V7     inpulse`)
  console.log(`  MAPE:            ${(v6Abs / cnt * 100).toFixed(1)}%         ${(v7Abs / cnt * 100).toFixed(1)}%         ${(iAbs / cnt * 100).toFixed(1)}%`)
  console.log(`  Precision:       ${(100 - v6Abs / cnt * 100).toFixed(1)}%        ${(100 - v7Abs / cnt * 100).toFixed(1)}%        ${(100 - iAbs / cnt * 100).toFixed(1)}%`)
  console.log(`  Biais:           ${(v6Err / cnt * 100) > 0 ? '+' : ''}${(v6Err / cnt * 100).toFixed(1)}%        ${(v7Err / cnt * 100) > 0 ? '+' : ''}${(v7Err / cnt * 100).toFixed(1)}%        ${(iErr / cnt * 100) > 0 ? '+' : ''}${(iErr / cnt * 100).toFixed(1)}%`)

  console.log('\n  PAR JOUR:')
  for (let d = 1; d <= 6; d++) {
    const s = dowStats[d]; if (!s) continue
    const v6P = (100 - s.v6A / s.n * 100).toFixed(1)
    const v7P = (100 - s.v7A / s.n * 100).toFixed(1)
    const iP = (100 - s.iA / s.n * 100).toFixed(1)
    const v7B = (s.v7E / s.n * 100).toFixed(1)
    const iB = (s.iE / s.n * 100).toFixed(1)
    const w = parseFloat(v7P) > parseFloat(iP) ? 'PHOOD' : 'inpulse'
    console.log(`    ${JOURS[d]}: V6=${v6P}% V7=${v7P}% (b=${v7B > 0 ? '+' : ''}${v7B}%)  inp=${iP}% (b=${iB > 0 ? '+' : ''}${iB}%)  → ${w}  (n=${s.n})`)
  }

  console.log('\n  PAR SEMAINE:')
  let w85v7 = 0, w85i = 0, wN = 0
  for (const [wk, d] of Object.entries(weekData).sort()) {
    if (d.r === 0) continue
    const pV7 = (100 - Math.abs(d.v7 - d.r) / d.r * 100).toFixed(0)
    const pI = (100 - Math.abs(d.inp - d.r) / d.r * 100).toFixed(0)
    if (parseInt(pV7) >= 85) w85v7++
    if (parseInt(pI) >= 85) w85i++; wN++
    const w = parseInt(pV7) > parseInt(pI) ? 'PHOOD' : parseInt(pI) > parseInt(pV7) ? 'inpulse' : 'egal'
    console.log(`    S ${wk}: V7=${pV7}% (${Math.round(d.v7)}€)  inp=${pI}% (${Math.round(d.inp)}€)  reel=${Math.round(d.r)}€  → ${w}`)
  }
  console.log(`\n  Semaines ≥85%: Phood V7 ${w85v7}/${wN}  inpulse ${w85i}/${wN}`)

  // Improvement breakdown
  console.log('\n  IMPACT DES NOUVEAUX FACTEURS V7:')
  let hpCount = 0, skCount = 0, wxCount = 0
  for (const date of sortedDates) {
    const d = new Date(date + 'T00:00:00'); if (d.getDay() === 0) continue
    if (holidayProx(date) !== 1) hpCount++
    if (streakCoeff(d) !== 1) skCount++
    const m = mMap.get(date)
    const isR = m?.precipitation_mm > 2, isS = m?.ensoleillement_secondes > 25200
    if ((isR && dowCorrRainy[d.getDay()] !== null) || (isS && dowCorrSunny[d.getDay()] !== null)) wxCount++
  }
  console.log(`    Holiday proximity: ${hpCount}/${cnt} jours affectes`)
  console.log(`    Streak detection: ${skCount}/${cnt} jours affectes`)
  console.log(`    DOW×weather: ${wxCount}/${cnt} jours avec correction conditionnelle`)
  console.log(`    Global drift: ${drift !== 1 ? `actif (${drift.toFixed(3)})` : 'inactif (<3%)'} — applique sur ${cnt} jours`)
}

main().catch(console.error)
