/**
 * Netlify Function: Invite a new user
 *
 * POST /.netlify/functions/invite-user
 * Body: { email: string, nom: string, role: "admin" | "manager" | "operator" }
 *
 * Uses Supabase Auth Admin API to create a new user with a magic link invite.
 * Also creates the profile row with the specified role.
 */

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
    const body = JSON.parse(event.body || '{}');
    const { email, nom, role } = body;

    if (!email || !nom) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Email et nom sont obligatoires' }) };
    }

    const validRoles = ['admin', 'manager', 'operator'];
    const userRole = validRoles.includes(role) ? role : 'operator';

    // 1. Create user via Supabase Auth Admin API (sends invite email)
    const createResp = await fetch(`${SUPABASE_URL}/auth/v1/admin/users`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
      },
      body: JSON.stringify({
        email,
        email_confirm: false, // User must confirm via email
        user_metadata: { nom },
      }),
    });

    if (!createResp.ok) {
      const errData = await createResp.json().catch(() => ({}));
      const msg = errData.msg || errData.message || errData.error || `Erreur ${createResp.status}`;
      return { statusCode: createResp.status, body: JSON.stringify({ error: msg }) };
    }

    const newUser = await createResp.json();

    // 2. Create profile row
    const { error: profileErr } = await fetch(
      `${SUPABASE_URL}/rest/v1/profiles`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'Prefer': 'return=minimal',
        },
        body: JSON.stringify({
          id: newUser.id,
          email,
          nom,
          role: userRole,
        }),
      }
    ).then(async r => {
      if (!r.ok) return { error: await r.text() };
      return { error: null };
    });

    if (profileErr) {
      console.error('Profile creation error:', profileErr);
      // User was created but profile failed — not critical, trigger will handle it
    }

    // 3. Send invite email (magic link)
    await fetch(`${SUPABASE_URL}/auth/v1/admin/users/${newUser.id}/factors`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
      },
    }).catch(() => {}); // Best effort

    // Send magic link invite
    await fetch(`${SUPABASE_URL}/auth/v1/invite`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
      },
      body: JSON.stringify({ email }),
    }).catch(() => {}); // Best effort — user can always use "forgot password"

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        success: true,
        user_id: newUser.id,
        email,
        nom,
        role: userRole,
      }),
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: err.message || 'Erreur interne' }),
    };
  }
};
