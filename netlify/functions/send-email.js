/**
 * Netlify Function: Send email via Gmail API (Google Service Account)
 *
 * POST /api/send-email
 * Body: { to, cc?, bcc?, subject, html, attachments?: [{filename, content, contentType?}], from_name? }
 *
 * Uses Gmail API with domain-wide delegation so emails appear
 * in the "Sent" folder of team.begles@phood-restaurant.fr.
 *
 * Requires GOOGLE_SERVICE_ACCOUNT_BASE64 environment variable.
 */

const { sendEmail } = require('./lib/gmail');

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { to, cc, bcc, subject, html, attachments, from_name } = JSON.parse(event.body);

    if (!to || !subject || !html) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Missing required fields: to, subject, html' }) };
    }

    await sendEmail({ to, cc, bcc, subject, html, attachments, from_name });

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true }),
    };
  } catch (error) {
    console.error('Email send error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};
