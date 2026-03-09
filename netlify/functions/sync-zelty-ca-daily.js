/**
 * Netlify Scheduled Function: Daily Zelty CA sync
 * Runs every day at 06:00 UTC (07:00 Paris winter / 08:00 Paris summer)
 * Fetches yesterday's closure from Zelty API and upserts into ventes_historique
 *
 * Schedule configured in netlify.toml
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';

exports.handler = async function (event) {
  const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
    console.error('Missing env vars');
    return { statusCode: 500, body: JSON.stringify({ error: 'Missing configuration' }) };
  }

  const startTime = Date.now();
  let logId = null;

  try {
    // Log job start
    const logResp = await fetch(
      `${SUPABASE_URL}/rest/v1/cron_logs`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'Prefer': 'return=representation',
        },
        body: JSON.stringify({ job_name: 'sync-zelty-ca', status: 'running' }),
      }
    );
    if (logResp.ok) {
      const logs = await logResp.json();
      logId = logs[0]?.id;
    }

    // Yesterday's date
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const dateStr = yesterday.toISOString().split('T')[0];

    // Fetch all closures from Zelty
    const resp = await fetch(`${ZELTY_BASE_URL}/closures`, {
      headers: {
        'Authorization': `Bearer ${ZELTY_API_KEY}`,
        'Accept': 'application/json',
      },
    });

    if (!resp.ok) {
      throw new Error(`Zelty API error: ${resp.status} ${resp.statusText}`);
    }

    const data = await resp.json();
    const closures = data.closures || [];

    // Filter for yesterday's closures
    const yesterdayClosures = closures.filter(c => c.date === dateStr);

    let upsertCount = 0;

    if (yesterdayClosures.length > 0) {
      // Keep the closure with highest turnover (the real one, not empty midnight one)
      const best = yesterdayClosures.reduce((a, b) =>
        (b.turnover || 0) > (a.turnover || 0) ? b : a
      );

      const upsertResp = await fetch(
        `${SUPABASE_URL}/rest/v1/ventes_historique?on_conflict=date`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
            'Prefer': 'resolution=merge-duplicates',
          },
          body: JSON.stringify({
            date: best.date,
            ca_ttc: (best.turnover || 0) / 100,
            nb_tickets: 0,
            nb_couverts: null,
            cloture_validee: true,
            zelty_closure_id: String(best.id),
          }),
        }
      );

      if (!upsertResp.ok) {
        const errText = await upsertResp.text().catch(() => '');
        throw new Error(`Supabase upsert error: ${errText}`);
      }
      upsertCount = 1;
    }

    // Log job success
    const durationMs = Date.now() - startTime;
    if (logId) {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`,
        {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
          },
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
      body: JSON.stringify({ success: true, date: dateStr, upserted: upsertCount }),
    };
  } catch (err) {
    // Log job error
    const durationMs = Date.now() - startTime;
    if (logId) {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`,
        {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
          },
          body: JSON.stringify({
            status: 'error',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
            error_message: err.message,
          }),
        }
      );
    } else {
      // If we couldn't create the log entry, create one now
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
          },
          body: JSON.stringify({
            job_name: 'sync-zelty-ca',
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
