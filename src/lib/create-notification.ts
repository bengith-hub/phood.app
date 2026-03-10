import { restCall } from './rest-client'
import type { NotificationType, Config } from '@/types/database'

interface Profile {
  id: string
  role: string
}

/**
 * Create a notification for all admin users.
 * Optionally sends an email alert if destinataires_email_alertes is configured.
 */
export async function createNotificationForAdmins(
  type: NotificationType,
  titre: string,
  message: string,
  referenceId?: string,
  referenceType?: string,
) {
  try {
    // Get all admin profiles
    const admins = await restCall<Profile[]>(
      'GET',
      'profiles?select=id,role&role=eq.admin',
    )

    if (admins.length === 0) return

    // Insert one notification per admin
    const notifs = admins.map(a => ({
      type,
      titre,
      message,
      lue: false,
      destinataire_id: a.id,
      reference_id: referenceId || null,
      reference_type: referenceType || null,
    }))

    await restCall('POST', 'notifications', notifs)

    // Send email alert (fire-and-forget, non-blocking)
    sendAlertEmail(type, titre, message).catch(() => {})
  } catch (e) {
    console.error('Failed to create notification:', e)
  }
}

/**
 * Send email to configured alert recipients.
 * Only sends if destinataires_email_alertes is non-empty.
 */
async function sendAlertEmail(type: NotificationType, titre: string, message: string) {
  // Only send email for critical alert types
  const criticalTypes: NotificationType[] = ['prix_ecart', 'avoir_sans_reponse']
  if (!criticalTypes.includes(type)) return

  try {
    const config = await restCall<Config>(
      'GET',
      'config?select=destinataires_email_alertes&limit=1',
      undefined,
      { single: true },
    )

    const recipients = config?.destinataires_email_alertes
    if (!recipients || recipients.length === 0) return

    await fetch('/.netlify/functions/send-email', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        to: recipients,
        subject: `[Phood] ${titre}`,
        html: `
          <div style="font-family:sans-serif;max-width:600px;margin:0 auto;">
            <h2 style="color:#E85D2C;">${titre}</h2>
            <p style="font-size:16px;line-height:1.5;">${message}</p>
            <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
            <p style="color:#888;font-size:13px;">
              Alerte automatique PhoodApp &mdash;
              <a href="https://app.phood.fr/recettes/cout-matiere" style="color:#E85D2C;">Voir dans l'app</a>
            </p>
          </div>
        `,
      }),
    })
  } catch {
    // Email is best-effort, don't block
  }
}

/**
 * Load the app config (cached per call, no store dependency).
 */
export async function loadConfig(): Promise<Config | null> {
  try {
    return await restCall<Config>('GET', 'config?select=*&limit=1', undefined, { single: true })
  } catch {
    return null
  }
}
