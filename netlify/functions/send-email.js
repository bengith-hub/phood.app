/**
 * Netlify Function: Send email via Gmail API (Service Account + Domain-Wide Delegation)
 *
 * POST /api/send-email
 * Body: { to, cc?, subject, html, attachments?: [{filename, content, encoding}] }
 *
 * Uses the service account configured in GOOGLE_SERVICE_ACCOUNT_BASE64 env var,
 * impersonating team.begles@phood-restaurant.fr
 */

const { google } = require('googleapis');
const MailComposer = require('nodemailer/lib/mail-composer');

const SENDER_EMAIL = 'team.begles@phood-restaurant.fr';

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { to, cc, subject, html, attachments } = JSON.parse(event.body);

    if (!to || !subject || !html) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Missing required fields: to, subject, html' }) };
    }

    // Decode service account credentials
    const credentials = JSON.parse(
      Buffer.from(process.env.GOOGLE_SERVICE_ACCOUNT_BASE64, 'base64').toString()
    );

    // Create JWT auth with domain-wide delegation
    const auth = new google.auth.JWT({
      email: credentials.client_email,
      key: credentials.private_key,
      scopes: ['https://www.googleapis.com/auth/gmail.send'],
      subject: SENDER_EMAIL, // impersonate
    });

    const gmail = google.gmail({ version: 'v1', auth });

    // Build MIME message
    const mailOptions = {
      from: `Phood Restaurant <${SENDER_EMAIL}>`,
      to,
      cc,
      subject,
      html,
      attachments: attachments?.map((a) => ({
        filename: a.filename,
        content: a.content,
        encoding: a.encoding || 'base64',
      })),
    };

    const mail = new MailComposer(mailOptions);
    const compiled = await mail.compile().build();
    const raw = compiled.toString('base64url');

    await gmail.users.messages.send({
      userId: 'me',
      requestBody: { raw },
    });

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
