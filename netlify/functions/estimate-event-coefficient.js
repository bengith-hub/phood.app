/**
 * Netlify Function: Estimate impact coefficient for a custom event
 *
 * POST /api/estimate-event-coefficient
 * Body: { nom: string, description: string, date_debut: string, date_fin: string }
 *
 * Uses GPT-4.1-mini to estimate how much an event will affect restaurant traffic
 * in a shopping center context. Returns a coefficient (e.g., 1.15 = +15%).
 */

const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const SCHEMA = {
  type: 'object',
  properties: {
    coefficient: {
      type: 'number',
      description: 'Multiplicative coefficient for CA impact (e.g. 1.15 for +15%, 0.85 for -15%)',
    },
    explication: {
      type: 'string',
      description: 'Brief explanation in French of why this coefficient was chosen',
    },
    confiance: {
      type: 'number',
      description: 'Confidence score 0-1 for the estimate accuracy',
    },
  },
  required: ['coefficient', 'explication', 'confiance'],
  additionalProperties: false,
};

const SYSTEM_PROMPT = `Tu es un expert en restauration rapide en centre commercial en France.
Tu estimes l'impact d'un evenement sur le chiffre d'affaires d'un restaurant de type fast food sain (bowls, salades, plats du moment) situe dans un centre commercial a Begles (banlieue de Bordeaux).

Regles importantes :
- Le centre commercial INVERSE les tendances meteo habituelles : quand il pleut, les gens viennent PLUS au centre commercial
- Les jours feries, le centre commercial est generalement FERME (coefficient 0)
- Les vacances scolaires (zone A = Bordeaux) augmentent legerement le trafic (+5% a +15%)
- Les soldes augmentent le trafic (+10% a +20%)
- Les evenements locaux (matchs, festivals, marches) peuvent avoir des effets varies
- Les travaux ou fermetures dans le centre commercial reduisent le trafic
- Un evenement commercial du centre (animation, inauguration) augmente le trafic

Reponds avec un coefficient multiplicatif :
- 1.0 = aucun impact
- > 1.0 = plus de clients (ex: 1.15 = +15%)
- < 1.0 = moins de clients (ex: 0.70 = -30%)
- 0 = fermeture totale

Sois conservateur dans tes estimations. Donne une explication courte en francais.`;

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { nom, description, date_debut, date_fin } = JSON.parse(event.body);

    if (!nom || !date_debut) {
      return { statusCode: 400, body: JSON.stringify({ error: 'nom et date_debut requis' }) };
    }

    const duree = date_debut === date_fin ? '1 jour' : `du ${date_debut} au ${date_fin}`;
    const userPrompt = `Evenement : "${nom}"
${description ? `Description : ${description}` : ''}
Periode : ${duree}
Date(s) : ${date_debut}${date_fin && date_fin !== date_debut ? ` a ${date_fin}` : ''}

Estime le coefficient d'impact sur le CA du restaurant.`;

    let response;
    try {
      response = await openai.chat.completions.create({
        model: 'gpt-4.1-mini',
        temperature: 0,
        response_format: {
          type: 'json_schema',
          json_schema: {
            name: 'event_coefficient',
            strict: true,
            schema: SCHEMA,
          },
        },
        messages: [
          { role: 'system', content: SYSTEM_PROMPT },
          { role: 'user', content: userPrompt },
        ],
      });
    } catch (miniError) {
      console.warn('GPT-4.1-mini failed, falling back to GPT-4.1:', miniError.message);
      response = await openai.chat.completions.create({
        model: 'gpt-4.1',
        temperature: 0,
        response_format: {
          type: 'json_schema',
          json_schema: {
            name: 'event_coefficient',
            strict: true,
            schema: SCHEMA,
          },
        },
        messages: [
          { role: 'system', content: SYSTEM_PROMPT },
          { role: 'user', content: userPrompt },
        ],
      });
    }

    const result = JSON.parse(response.choices[0].message.content);

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(result),
    };
  } catch (error) {
    console.error('Event coefficient estimation error:', error);
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: error.message }),
    };
  }
};
