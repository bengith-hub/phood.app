/**
 * Netlify Function: Send email via Resend API
 *
 * POST /api/send-email
 * Body: { to, cc?, bcc?, subject, html, attachments?: [{filename, content, contentType?}] }
 *
 * Replaces Gmail Service Account approach with Resend for simpler setup.
 * Requires RESEND_API_KEY environment variable.
 *
 * Sender: team.begles@phood-restaurant.fr (must be verified domain in Resend)
 */

const SENDER_EMAIL = 'Phood Restaurant <team.begles@phood-restaurant.fr>';

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { to, cc, bcc, subject, html, attachments } = JSON.parse(event.body);

    if (!to || !subject || !html) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Missing required fields: to, subject, html' }) };
    }

    const apiKey = process.env.RESEND_API_KEY;
    if (!apiKey) {
      // Fallback: if Resend not configured, try Gmail Service Account
      return await sendViaGmail(event);
    }

    // Build Resend payload
    const payload = {
      from: SENDER_EMAIL,
      to: Array.isArray(to) ? to : [to],
      subject,
      html,
    };

    if (cc) {
      payload.cc = Array.isArray(cc) ? cc : [cc];
    }

    if (bcc) {
      payload.bcc = Array.isArray(bcc) ? bcc : [bcc];
    }

    if (attachments && attachments.length > 0) {
      payload.attachments = attachments.map((a) => ({
        filename: a.filename,
        content: a.content, // base64 string
        content_type: a.contentType || 'application/pdf',
      }));
    }

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(`Resend API error ${response.status}: ${errorBody}`);
    }

    const result = await response.json();

    return {
      statusCode: 200,
      body: JSON.stringify({ success: true, id: result.id }),
    };
  } catch (error) {
    console.error('Email send error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};

/**
 * Fallback: Gmail Service Account (original implementation)
 * Used if RESEND_API_KEY is not set
 */
async function sendViaGmail(event) {
  try {
    const { google } = require('googleapis');
    const MailComposer = require('nodemailer/lib/mail-composer');

    const { to, cc, bcc, subject, html, attachments } = JSON.parse(event.body);

    const credentials = JSON.parse(
      Buffer.from(process.env.GOOGLE_SERVICE_ACCOUNT_BASE64, 'base64').toString()
    );

    const auth = new google.auth.JWT({
      email: credentials.client_email,
      key: credentials.private_key,
      scopes: ['https://www.googleapis.com/auth/gmail.send'],
      subject: 'team.begles@phood-restaurant.fr',
    });

    const gmail = google.gmail({ version: 'v1', auth });

    const mailOptions = {
      from: `Phood Restaurant <team.begles@phood-restaurant.fr>`,
      to,
      cc,
      bcc,
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
    console.error('Gmail fallback error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
}
