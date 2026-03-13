/**
 * Netlify Scheduled Function: Daily task generation
 * Runs every day at 05:00 UTC (06:00 Paris winter / 07:00 Paris summer)
 * Generates tache_instances from active tache_templates for today
 *
 * Schedule configured in netlify.toml
 */

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
      body: JSON.stringify({ job_name: 'generate-daily-tasks', status: 'running' }),
    });
    if (logResp.ok) {
      const logs = await logResp.json();
      logId = logs[0]?.id;
    }

    // Today's date and day of week (0=dim...6=sam)
    const now = new Date();
    const todayStr = now.toISOString().split('T')[0];
    const dayOfWeek = now.getDay(); // 0=Sunday, same as jours_semaine convention

    // Fetch active recurring templates for today's day + active priority templates not expired
    const recurringResp = await fetch(
      `${SUPABASE_URL}/rest/v1/tache_templates?actif=eq.true&priorite=eq.false&jours_semaine=cs.{${dayOfWeek}}&select=*`,
      { headers }
    );
    if (!recurringResp.ok) throw new Error(`Fetch recurring templates: ${await recurringResp.text()}`);
    const recurringTemplates = await recurringResp.json();

    const priorityResp = await fetch(
      `${SUPABASE_URL}/rest/v1/tache_templates?actif=eq.true&priorite=eq.true&select=*`,
      { headers }
    );
    if (!priorityResp.ok) throw new Error(`Fetch priority templates: ${await priorityResp.text()}`);
    const priorityTemplates = (await priorityResp.json()).filter(t => {
      if (!t.expiration) return true;
      return new Date(t.expiration) > now;
    });

    const allTemplates = [...recurringTemplates, ...priorityTemplates];
    console.log(`Found ${recurringTemplates.length} recurring + ${priorityTemplates.length} priority templates for day ${dayOfWeek}`);

    // Generate instances (upsert with ON CONFLICT DO NOTHING)
    let createdCount = 0;
    for (const template of allTemplates) {
      const instance = {
        template_id: template.id,
        date: todayStr,
        nom: template.nom,
        description: template.description,
        station: template.station,
        photo_reference_url: template.photo_reference_url,
        priorite: template.priorite,
        statut: 'en_attente',
        ordre: template.ordre,
      };

      const upsertResp = await fetch(
        `${SUPABASE_URL}/rest/v1/tache_instances?on_conflict=template_id,date`,
        {
          method: 'POST',
          headers: { ...headers, 'Prefer': 'resolution=ignore-duplicates' },
          body: JSON.stringify(instance),
        }
      );

      if (!upsertResp.ok) {
        const errText = await upsertResp.text().catch(() => '');
        console.warn(`Upsert failed for template ${template.id}: ${errText}`);
      } else {
        createdCount++;
      }
    }

    // Deactivate expired priority templates
    const deactivateResp = await fetch(
      `${SUPABASE_URL}/rest/v1/tache_templates?priorite=eq.true&actif=eq.true&expiration=lt.${now.toISOString()}&expiration=not.is.null`,
      {
        method: 'PATCH',
        headers,
        body: JSON.stringify({ actif: false, updated_at: now.toISOString() }),
      }
    );
    const deactivatedInfo = deactivateResp.ok ? 'ok' : await deactivateResp.text().catch(() => 'error');
    console.log(`Deactivate expired priorities: ${deactivatedInfo}`);

    // Log job success
    const durationMs = Date.now() - startTime;
    if (logId) {
      await fetch(`${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`, {
        method: 'PATCH',
        headers,
        body: JSON.stringify({ status: 'success', finished_at: new Date().toISOString(), duration_ms: durationMs }),
      });
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, date: todayStr, dayOfWeek, templates: allTemplates.length, created: createdCount }),
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
        body: JSON.stringify({ job_name: 'generate-daily-tasks', status: 'error', finished_at: new Date().toISOString(), duration_ms: durationMs, error_message: err.message }),
      }).catch(() => {});
    }

    return { statusCode: 500, body: JSON.stringify({ error: err.message }) };
  }
};
