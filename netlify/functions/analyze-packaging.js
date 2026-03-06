/**
 * Netlify Function: Analyze packaging label photo via OpenAI Vision
 *
 * POST /api/analyze-packaging
 * Body: { image_base64 }
 *
 * Returns structured JSON with allergens and ingredient list (contient field).
 * Single call extracts both 14 allergens AND full ingredient list.
 */

const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const ALLERGENS_LIST = [
  'gluten', 'crustaces', 'oeufs', 'poissons', 'arachides',
  'soja', 'lait', 'fruits_a_coque', 'celeri', 'moutarde',
  'sesame', 'sulfites', 'lupin', 'mollusques',
];

const SCHEMA = {
  type: 'object',
  properties: {
    nom_produit: { type: ['string', 'null'], description: 'Product name if visible' },
    allergenes: {
      type: 'array',
      items: {
        type: 'string',
        enum: ALLERGENS_LIST,
      },
      description: 'List of detected allergens from the 14 mandatory EU allergens',
    },
    contient: {
      type: ['string', 'null'],
      description: 'Full ingredient list as written on the label (comma-separated)',
    },
    confiance: { type: 'number', description: 'Overall confidence score 0-1' },
    marque: { type: ['string', 'null'], description: 'Brand name if visible' },
    poids_net: { type: ['string', 'null'], description: 'Net weight if visible' },
  },
  required: ['allergenes', 'contient', 'confiance'],
  additionalProperties: false,
};

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { image_base64 } = JSON.parse(event.body);

    if (!image_base64) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Missing image_base64' }) };
    }

    const systemPrompt = `Tu es un expert en étiquetage alimentaire européen.
Analyse cette photo d'étiquette de produit alimentaire et extrais :

1. **Allergènes** : Identifie les 14 allergènes à déclaration obligatoire (UE) présents.
   Utilise uniquement ces identifiants : ${ALLERGENS_LIST.join(', ')}
   Les allergènes sont souvent en **gras** ou en MAJUSCULES sur l'étiquette.

2. **Liste des ingrédients** (champ "contient") : Recopie la liste complète des ingrédients telle qu'elle apparaît sur l'étiquette, séparés par des virgules.

3. **Nom du produit** et **marque** si visibles.

Score de confiance : 1.0 si texte clairement lisible, 0.7 si partiellement flou, 0.4 si très difficile à lire.`;

    let response;
    try {
      response = await openai.chat.completions.create({
        model: 'gpt-4.1-mini',
        temperature: 0,
        response_format: {
          type: 'json_schema',
          json_schema: {
            name: 'packaging_extraction',
            strict: true,
            schema: SCHEMA,
          },
        },
        messages: [
          { role: 'system', content: systemPrompt },
          {
            role: 'user',
            content: [
              {
                type: 'image_url',
                image_url: {
                  url: `data:image/jpeg;base64,${image_base64}`,
                  detail: 'high',
                },
              },
              { type: 'text', text: 'Analyse cette étiquette de produit alimentaire.' },
            ],
          },
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
            name: 'packaging_extraction',
            strict: true,
            schema: SCHEMA,
          },
        },
        messages: [
          { role: 'system', content: systemPrompt },
          {
            role: 'user',
            content: [
              {
                type: 'image_url',
                image_url: {
                  url: `data:image/jpeg;base64,${image_base64}`,
                  detail: 'high',
                },
              },
              { type: 'text', text: 'Analyse cette étiquette de produit alimentaire.' },
            ],
          },
        ],
      });
    }

    const result = JSON.parse(response.choices[0].message.content);

    return {
      statusCode: 200,
      body: JSON.stringify(result),
    };
  } catch (error) {
    console.error('Packaging analysis error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};
