/**
 * Netlify Function: Backfill historical weather data from Open-Meteo archive API
 *
 * POST /.netlify/functions/backfill-meteo
 * Body: { date_from?: "YYYY-MM-DD", date_to?: "YYYY-MM-DD" }
 *
 * Fetches daily weather data from Open-Meteo archive API for the given date range
 * (default: last 18 months) and upserts into meteo_daily table.
 *
 * Open-Meteo archive API is free, no API key required.
 * Coordinates: Begles (Bordeaux area) lat=44.83, lon=-0.57
 */

const LATITUDE = 44.83;
const LONGITUDE = -0.57;
const DAILY_PARAMS = [
  'temperature_2m_max',
  'temperature_2m_min',
  'precipitation_sum',
  'sunshine_duration',
  'cloud_cover_mean',
  'weather_code',
].join(',');

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!SUPABASE_URL || !SUPABASE_KEY) {
    return { statusCode: 500, body: JSON.stringify({ error: 'Configuration Supabase manquante' }) };
  }

  try {
    const body = event.body ? JSON.parse(event.body) : {};

    // Default: last 18 months to yesterday
    const dateTo = body.date_to || (() => {
      const d = new Date();
      d.setDate(d.getDate() - 1);
      return d.toISOString().split('T')[0];
    })();

    const dateFrom = body.date_from || (() => {
      const d = new Date();
      d.setMonth(d.getMonth() - 18);
      return d.toISOString().split('T')[0];
    })();

    console.log(`Backfill meteo: ${dateFrom} -> ${dateTo}`);

    // Open-Meteo archive API supports max ~1 year per request, so we chunk by 6-month periods
    const chunks = [];
    let chunkStart = new Date(dateFrom + 'T00:00:00');
    const endDate = new Date(dateTo + 'T00:00:00');

    while (chunkStart <= endDate) {
      const chunkEnd = new Date(chunkStart);
      chunkEnd.setMonth(chunkEnd.getMonth() + 6);
      if (chunkEnd > endDate) {
        chunkEnd.setTime(endDate.getTime());
      }
      chunks.push({
        start: chunkStart.toISOString().split('T')[0],
        end: chunkEnd.toISOString().split('T')[0],
      });
      chunkStart = new Date(chunkEnd);
      chunkStart.setDate(chunkStart.getDate() + 1);
    }

    let totalImported = 0;
    let totalErrors = 0;

    for (const chunk of chunks) {
      const url = `https://archive-api.open-meteo.com/v1/archive?latitude=${LATITUDE}&longitude=${LONGITUDE}&start_date=${chunk.start}&end_date=${chunk.end}&daily=${DAILY_PARAMS}&timezone=Europe%2FParis`;

      console.log(`Fetching: ${chunk.start} -> ${chunk.end}`);

      const resp = await fetch(url);
      if (!resp.ok) {
        console.error(`Open-Meteo error for ${chunk.start}-${chunk.end}: ${resp.status}`);
        totalErrors++;
        continue;
      }

      const data = await resp.json();
      if (!data.daily || !data.daily.time || data.daily.time.length === 0) {
        console.log(`No data for ${chunk.start}-${chunk.end}`);
        continue;
      }

      const rows = data.daily.time.map((date, i) => ({
        date,
        temperature_max: data.daily.temperature_2m_max?.[i] ?? null,
        temperature_min: data.daily.temperature_2m_min?.[i] ?? null,
        precipitation_mm: data.daily.precipitation_sum?.[i] ?? null,
        ensoleillement_secondes: data.daily.sunshine_duration?.[i] ?? null,
        couverture_nuageuse_pct: data.daily.cloud_cover_mean?.[i] != null
          ? Math.round(data.daily.cloud_cover_mean[i])
          : null,
        code_meteo: data.daily.weather_code?.[i] ?? null,
      }));

      // Upsert in batches of 200
      const BATCH_SIZE = 200;
      for (let j = 0; j < rows.length; j += BATCH_SIZE) {
        const batch = rows.slice(j, j + BATCH_SIZE);

        const upsertResp = await fetch(
          `${SUPABASE_URL}/rest/v1/meteo_daily`,
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              apikey: SUPABASE_KEY,
              Authorization: `Bearer ${SUPABASE_KEY}`,
              Prefer: 'resolution=merge-duplicates',
            },
            body: JSON.stringify(batch),
          }
        );

        if (!upsertResp.ok) {
          const errText = await upsertResp.text();
          console.error(`Supabase upsert error: ${errText}`);
          totalErrors++;
        } else {
          totalImported += batch.length;
        }
      }
    }

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        date_from: dateFrom,
        date_to: dateTo,
        total_imported: totalImported,
        total_errors: totalErrors,
      }),
    };
  } catch (e) {
    console.error('Backfill meteo error:', e);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: e.message || String(e) }),
    };
  }
};
