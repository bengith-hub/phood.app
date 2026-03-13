/**
 * Netlify Scheduled Function: Daily task recap email
 * Runs every day at 23:00 UTC (00:00 Paris winter / 01:00 Paris summer)
 * Sends a recap email of today's tasks if a Zelty closure exists
 *
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
    'Content-Type': 'application/json',
    'apikey': SUPABASE_KEY,
    'Authorization': `Bearer ${SUPABASE_KEY}`,
  };

  const startTime = Date.now();
  let logId = null;

  try {
    // Log job start
    const logResp = await fetch(`${SUPABASE_URL}/rest/v1/cron_logs`, {
      method: 'POST',
      headers: { ...headers, 'Prefer': 'return=representation' },
      body: JSON.stringify({ job_name: 'recap-taches-daily', status: 'running' }),
    });
    if (logResp.ok) {
      const logs = await logResp.json();
      logId = logs[0]?.id;
    }

    // Today's date
    const todayStr = new Date().toISOString().split('T')[0];

    // Check Zelty closure exists for today
    const closureResp = await fetch(
      `${SUPABASE_URL}/rest/v1/ventes_historique?date=eq.${todayStr}&select=ca_ttc`,
      { headers: { ...headers, 'Accept': 'application/json' } }
    );
    const closures = closureResp.ok ? await closureResp.json() : [];
    const closure = closures[0];

    if (!closure || closure.ca_ttc <= 0) {
      console.log(`No Zelty closure for ${todayStr}, skipping recap`);
      await logSuccess(SUPABASE_URL, headers, logId, startTime, 'skipped_no_closure');
      return { statusCode: 200, body: JSON.stringify({ skipped: true, reason: 'no_closure' }) };
    }

    // Load config for email recipients
    const configResp = await fetch(
      `${SUPABASE_URL}/rest/v1/config?select=destinataires_email_taches,etablissement_nom,etablissement_ville&limit=1`,
      { headers: { ...headers, 'Accept': 'application/vnd.pgrst.object+json' } }
    );
    const config = configResp.ok ? await configResp.json() : {};
    const recipients = config.destinataires_email_taches || [];

    if (recipients.length === 0) {
      console.log('No email recipients configured for task recap');
      await logSuccess(SUPABASE_URL, headers, logId, startTime, 'skipped_no_recipients');
      return { statusCode: 200, body: JSON.stringify({ skipped: true, reason: 'no_recipients' }) };
    }

    // Fetch today's task instances
    const instancesResp = await fetch(
      `${SUPABASE_URL}/rest/v1/tache_instances?date=eq.${todayStr}&select=*&order=station.asc,priorite.desc,ordre.asc`,
      { headers }
    );
    const instances = instancesResp.ok ? await instancesResp.json() : [];

    if (instances.length === 0) {
      console.log(`No task instances for ${todayStr}`);
      await logSuccess(SUPABASE_URL, headers, logId, startTime, 'skipped_no_tasks');
      return { statusCode: 200, body: JSON.stringify({ skipped: true, reason: 'no_tasks' }) };
    }

    // Group by station
    const byStation = { salle: [], cuisine: [] };
    for (const inst of instances) {
      if (byStation[inst.station]) {
        byStation[inst.station].push(inst);
      }
    }

    // Format date for display
    const dateDisplay = new Date(todayStr).toLocaleDateString('fr-FR', {
      weekday: 'long', day: 'numeric', month: 'long', year: 'numeric'
    });

    // Build HTML email
    const restaurantName = config.etablissement_nom || 'Phood Restaurant';
    const ville = config.etablissement_ville || 'Bègles';

    let html = `
      <div style="font-family:sans-serif;max-width:650px;margin:0 auto;">
        <h2 style="color:#E85D2C;margin-bottom:4px;">Recap tâches équipe</h2>
        <p style="color:#666;margin-top:0;font-size:14px;">${dateDisplay} — CA : ${closure.ca_ttc.toFixed(2)}€ TTC</p>
    `;

    for (const [station, tasks] of Object.entries(byStation)) {
      if (tasks.length === 0) continue;

      const done = tasks.filter(t => t.statut === 'fait').length;
      const total = tasks.length;
      const pct = Math.round((done / total) * 100);
      const stationLabel = station.charAt(0).toUpperCase() + station.slice(1);

      html += `
        <h3 style="color:#333;border-bottom:2px solid #E85D2C;padding-bottom:8px;margin-top:24px;">
          ${stationLabel} — ${done}/${total} (${pct}%)
        </h3>
      `;

      for (const task of tasks) {
        const statusColor = task.statut === 'fait' ? '#16a34a' : task.statut === 'non_fait' ? '#dc2626' : '#9ca3af';
        const statusLabel = task.statut === 'fait' ? 'Fait' : task.statut === 'non_fait' ? 'Non fait' : 'En attente';
        const statusIcon = task.statut === 'fait' ? '✓' : task.statut === 'non_fait' ? '✕' : '○';
        const priorityBadge = task.priorite
          ? '<span style="background:#f97316;color:white;padding:2px 8px;border-radius:4px;font-size:11px;margin-left:8px;">PRIORITAIRE</span>'
          : '';

        html += `
          <div style="padding:12px 16px;margin:8px 0;border-left:4px solid ${statusColor};background:#fafafa;border-radius:0 8px 8px 0;">
            <div style="display:flex;align-items:center;gap:8px;">
              <span style="color:${statusColor};font-weight:bold;font-size:18px;">${statusIcon}</span>
              <span style="font-weight:600;font-size:15px;">${task.nom}</span>
              <span style="color:${statusColor};font-size:13px;margin-left:auto;">${statusLabel}</span>
              ${priorityBadge}
            </div>
        `;

        if (task.statut === 'non_fait' && task.raison_non_fait) {
          html += `<p style="margin:8px 0 0;color:#dc2626;font-size:13px;font-style:italic;">Raison : ${escapeHtml(task.raison_non_fait)}</p>`;
        }

        if (task.statut === 'fait' && task.photo_preuve_url) {
          html += `<img src="${task.photo_preuve_url}" alt="Photo preuve" style="margin-top:8px;max-width:200px;max-height:150px;border-radius:8px;border:1px solid #ddd;">`;
        }

        html += `</div>`;
      }
    }

    html += `
        <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
        <p style="color:#888;font-size:13px;">
          ${restaurantName} — ${ville} |
          <a href="https://app.phood.fr/" style="color:#E85D2C;">Ouvrir PhoodApp</a>
        </p>
      </div>
    `;

    // Send email
    const subject = `${formatDateShort(todayStr)} | Recap tâches | ${restaurantName} | ${ville}`;
    await sendEmail({ to: recipients, subject, html });
    console.log(`Task recap email sent to ${recipients.join(', ')} — ${instances.length} tasks`);

    await logSuccess(SUPABASE_URL, headers, logId, startTime, `sent_${instances.length}_tasks`);

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, date: todayStr, tasks: instances.length, recipients: recipients.length }),
    };
  } catch (err) {
    const durationMs = Date.now() - startTime;
    if (logId) {
      await fetch(`${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`, {
        method: 'PATCH',
        headers,
        body: JSON.stringify({ status: 'error', finished_at: new Date().toISOString(), duration_ms: durationMs, error_message: err.message }),
      });
    } else {
      await fetch(`${SUPABASE_URL}/rest/v1/cron_logs`, {
        method: 'POST',
        headers,
        body: JSON.stringify({ job_name: 'recap-taches-daily', status: 'error', finished_at: new Date().toISOString(), duration_ms: durationMs, error_message: err.message }),
      }).catch(() => {});
    }

    return { statusCode: 500, body: JSON.stringify({ error: err.message }) };
  }
};

async function logSuccess(supabaseUrl, headers, logId, startTime, note) {
  const durationMs = Date.now() - startTime;
  if (logId) {
    await fetch(`${supabaseUrl}/rest/v1/cron_logs?id=eq.${logId}`, {
      method: 'PATCH',
      headers,
      body: JSON.stringify({ status: 'success', finished_at: new Date().toISOString(), duration_ms: durationMs }),
    });
  }
}

function formatDateShort(dateStr) {
  const d = new Date(dateStr);
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}`;
}

function escapeHtml(str) {
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
