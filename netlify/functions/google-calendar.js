/**
 * Netlify Function: Google Calendar event management
 *
 * POST /api/google-calendar
 * Body: { action, calendarId, ...params }
 *
 * Actions:
 *   - create-delivery: Create a delivery event when an order is sent
 *   - update-delivery: Update delivery event status (received, late)
 *   - create-order-reminder: Create recurring order reminder for a supplier
 *
 * Uses Google Service Account + Domain-Wide Delegation (same as Gmail).
 * Requires GOOGLE_SERVICE_ACCOUNT_BASE64 environment variable.
 */

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { google } = require('googleapis');
    const body = JSON.parse(event.body);
    const { action, calendarId } = body;

    if (!calendarId) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Missing calendarId' }) };
    }

    const credentials = JSON.parse(
      Buffer.from(process.env.GOOGLE_SERVICE_ACCOUNT_BASE64, 'base64').toString()
    );

    const auth = new google.auth.JWT({
      email: credentials.client_email,
      key: credentials.private_key,
      scopes: ['https://www.googleapis.com/auth/calendar'],
      subject: 'team.begles@phood-restaurant.fr',
    });

    const calendar = google.calendar({ version: 'v3', auth });

    switch (action) {
      case 'create-delivery':
        return await createDeliveryEvent(calendar, calendarId, body);
      case 'update-delivery':
        return await updateDeliveryEvent(calendar, calendarId, body);
      case 'create-order-reminder':
        return await createOrderReminder(calendar, calendarId, body);
      default:
        return { statusCode: 400, body: JSON.stringify({ error: `Unknown action: ${action}` }) };
    }
  } catch (error) {
    console.error('Google Calendar error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};

/**
 * Create a delivery event when an order is sent to a supplier.
 *
 * Body params:
 *   - commandeNumero: string (e.g. "BC20260310-001")
 *   - fournisseurNom: string
 *   - dateLivraison: string (YYYY-MM-DD)
 *   - creneauDebut: string (HH:mm, default "07:00")
 *   - creneauFin: string (HH:mm, default "08:00")
 *   - nbReferences: number
 *   - poidsTotal: number (kg)
 *   - lignesDescription: string (formatted list of items)
 */
async function createDeliveryEvent(calendar, calendarId, body) {
  const {
    commandeNumero,
    fournisseurNom,
    dateLivraison,
    creneauDebut = '07:00',
    creneauFin = '08:00',
    nbReferences = 0,
    poidsTotal = 0,
    lignesDescription = '',
  } = body;

  const summary = `\u{1F69A} Livraison ${fournisseurNom} \u2014 ${nbReferences} r\u00e9f.${poidsTotal > 0 ? ` / ${Math.round(poidsTotal)} kg` : ''} \u2014 ${commandeNumero}`;

  const description = [
    `Commande ${commandeNumero}`,
    `${nbReferences} r\u00e9f\u00e9rences command\u00e9es :`,
    lignesDescription,
    '',
    `\u{1F4CB} Ouvrir le contr\u00f4le : https://app.phood-restaurant.fr/reception`,
  ].join('\n');

  const event = {
    summary,
    description,
    start: {
      dateTime: `${dateLivraison}T${creneauDebut}:00`,
      timeZone: 'Europe/Paris',
    },
    end: {
      dateTime: `${dateLivraison}T${creneauFin}:00`,
      timeZone: 'Europe/Paris',
    },
    extendedProperties: {
      private: {
        type: 'delivery',
        orderId: commandeNumero,
        status: 'pending',
      },
    },
  };

  const result = await calendar.events.insert({
    calendarId,
    requestBody: event,
  });

  return {
    statusCode: 200,
    body: JSON.stringify({ success: true, eventId: result.data.id }),
  };
}

/**
 * Update a delivery event status (e.g. received, late).
 *
 * Body params:
 *   - commandeNumero: string
 *   - newStatus: 'received' | 'late'
 *   - fournisseurNom: string
 */
async function updateDeliveryEvent(calendar, calendarId, body) {
  const { commandeNumero, newStatus, fournisseurNom } = body;

  // Find the event by extended properties
  const listResult = await calendar.events.list({
    calendarId,
    privateExtendedProperty: `orderId=${commandeNumero}`,
    maxResults: 1,
  });

  const events = listResult.data.items || [];
  if (events.length === 0) {
    return {
      statusCode: 404,
      body: JSON.stringify({ error: `No event found for ${commandeNumero}` }),
    };
  }

  const existingEvent = events[0];
  let newSummary;

  switch (newStatus) {
    case 'received':
      newSummary = `\u2705 Re\u00e7u \u2014 ${fournisseurNom} \u2014 ${commandeNumero}`;
      break;
    case 'late':
      newSummary = `\u26A0\uFE0F Retard \u2014 ${fournisseurNom} \u2014 ${commandeNumero}`;
      break;
    default:
      newSummary = existingEvent.summary;
  }

  await calendar.events.patch({
    calendarId,
    eventId: existingEvent.id,
    requestBody: {
      summary: newSummary,
      extendedProperties: {
        private: {
          ...existingEvent.extendedProperties?.private,
          status: newStatus,
        },
      },
    },
  });

  return {
    statusCode: 200,
    body: JSON.stringify({ success: true, eventId: existingEvent.id }),
  };
}

/**
 * Create a recurring order reminder for a supplier.
 *
 * Body params:
 *   - fournisseurNom: string
 *   - heureLimite: string (HH:mm)
 *   - joursCommande: number[] (0=Sun..6=Sat)
 *   - startDate: string (YYYY-MM-DD)
 */
async function createOrderReminder(calendar, calendarId, body) {
  const {
    fournisseurNom,
    heureLimite = '14:00',
    joursCommande = [],
    startDate,
  } = body;

  if (joursCommande.length === 0) {
    return { statusCode: 400, body: JSON.stringify({ error: 'joursCommande is required' }) };
  }

  // Convert JS day numbers (0=Sun) to RRULE day abbreviations
  const dayMap = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA'];
  const byDay = joursCommande.map((d) => dayMap[d]).join(',');

  // Reminder 1 hour before deadline
  const [h, m] = heureLimite.split(':').map(Number);
  const reminderH = h - 1 >= 0 ? h - 1 : h;
  const endH = h;

  const event = {
    summary: `\u{1F4DD} Commande ${fournisseurNom} \u2014 avant ${heureLimite}`,
    start: {
      dateTime: `${startDate}T${String(reminderH).padStart(2, '0')}:${String(m).padStart(2, '0')}:00`,
      timeZone: 'Europe/Paris',
    },
    end: {
      dateTime: `${startDate}T${String(endH).padStart(2, '0')}:${String(m).padStart(2, '0')}:00`,
      timeZone: 'Europe/Paris',
    },
    recurrence: [`RRULE:FREQ=WEEKLY;BYDAY=${byDay}`],
    extendedProperties: {
      private: {
        type: 'order_reminder',
        supplierName: fournisseurNom,
      },
    },
  };

  const result = await calendar.events.insert({
    calendarId,
    requestBody: event,
  });

  return {
    statusCode: 200,
    body: JSON.stringify({ success: true, eventId: result.data.id }),
  };
}
