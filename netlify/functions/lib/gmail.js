/**
 * Shared Gmail sending utility via Google Service Account
 *
 * Requires:
 * - GOOGLE_SERVICE_ACCOUNT_BASE64 env variable (base64-encoded JSON key)
 * - Domain-wide delegation enabled in Google Workspace Admin
 * - Gmail API enabled in GCP project
 * - Scope: https://www.googleapis.com/auth/gmail.send
 *
 * Emails appear in the "Sent" folder of the sender's Gmail account.
 */

const FROM_EMAIL = 'team.begles@phood-restaurant.fr';
const DEFAULT_FROM_NAME = 'Phood Restaurant';

/**
 * Send an email via Gmail API using a Google Service Account.
 *
 * @param {Object} options
 * @param {string|string[]} options.to - Recipient(s)
 * @param {string} options.subject - Subject line
 * @param {string} options.html - HTML body
 * @param {string|string[]} [options.cc] - CC recipient(s)
 * @param {string|string[]} [options.bcc] - BCC recipient(s)
 * @param {string} [options.from_name] - Sender display name (default: "Phood Restaurant")
 * @param {Array<{filename: string, content: string, encoding?: string}>} [options.attachments]
 * @returns {Promise<{success: boolean, error?: string}>}
 */
async function sendEmail({ to, subject, html, cc, bcc, from_name, attachments }) {
  const { google } = require('googleapis');
  const MailComposer = require('nodemailer/lib/mail-composer');

  const base64Creds = process.env.GOOGLE_SERVICE_ACCOUNT_BASE64;
  if (!base64Creds) {
    throw new Error('Missing GOOGLE_SERVICE_ACCOUNT_BASE64 environment variable');
  }

  const credentials = JSON.parse(
    Buffer.from(base64Creds, 'base64').toString()
  );

  const auth = new google.auth.JWT({
    email: credentials.client_email,
    key: credentials.private_key,
    scopes: ['https://www.googleapis.com/auth/gmail.send'],
    subject: FROM_EMAIL,
  });

  const gmail = google.gmail({ version: 'v1', auth });

  const mailOptions = {
    from: `${from_name || DEFAULT_FROM_NAME} <${FROM_EMAIL}>`,
    to: Array.isArray(to) ? to.join(', ') : to,
    subject,
    html,
  };

  if (cc) {
    mailOptions.cc = Array.isArray(cc) ? cc.join(', ') : cc;
  }

  // Always BCC the sender so team.begles@ gets a copy of every outgoing email
  const bccList = bcc ? (Array.isArray(bcc) ? [...bcc] : [bcc]) : [];
  if (!bccList.includes(FROM_EMAIL)) {
    bccList.push(FROM_EMAIL);
  }
  mailOptions.bcc = bccList.join(', ');

  if (attachments && attachments.length > 0) {
    mailOptions.attachments = attachments.map((a) => ({
      filename: a.filename,
      content: a.content,
      encoding: a.encoding || 'base64',
    }));
  }

  const mail = new MailComposer(mailOptions);
  const compiled = await mail.compile().build();
  const raw = compiled.toString('base64url');

  await gmail.users.messages.send({
    userId: 'me',
    requestBody: { raw },
  });

  return { success: true };
}

module.exports = { sendEmail, FROM_EMAIL, DEFAULT_FROM_NAME };
