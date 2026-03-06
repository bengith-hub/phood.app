/**
 * Netlify Function: Analyze delivery note (BL) photo via OpenAI Vision
 *
 * POST /api/analyze-bl
 * Body: { image_base64, commande_lignes: [{designation, quantite, unite}] }
 *
 * Returns structured JSON matching BL lines to order lines.
 */

const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const SCHEMA = {
  type: 'object',
  properties: {
    lignes: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          designation: { type: 'string', description: 'Product name as written on BL' },
          quantite: { type: 'number', description: 'Quantity delivered' },
          unite: { type: 'string', description: 'Unit (kg, L, pcs, carton, etc.)' },
          prix_unitaire: { type: ['number', 'null'], description: 'Unit price if visible' },
          confiance: { type: 'number', description: 'Confidence score 0-1' },
        },
        required: ['designation', 'quantite', 'unite', 'confiance'],
        additionalProperties: false,
      },
    },
    numero_bl: { type: ['string', 'null'], description: 'BL number if visible' },
    date_bl: { type: ['string', 'null'], description: 'BL date if visible (YYYY-MM-DD)' },
    fournisseur_detecte: { type: ['string', 'null'], description: 'Supplier name if detected' },
  },
  required: ['lignes'],
  additionalProperties: false,
};

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { image_base64, commande_lignes } = JSON.parse(event.body);

    if (!image_base64) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Missing image_base64' }) };
    }

    const orderContext = commande_lignes
      ? `\n\nProduits commandés (pour matching) :\n${commande_lignes.map((l) => `- ${l.designation} : ${l.quantite} ${l.unite}`).join('\n')}`
      : '';

    const systemPrompt = `Tu es un assistant spécialisé dans la lecture de bons de livraison (BL) de fournisseurs alimentaires.
Extrais toutes les lignes produits du bon de livraison photographié.
Pour chaque ligne, indique la désignation, quantité, unité, prix unitaire (si visible), et un score de confiance (0-1).
Extrais aussi le numéro de BL, la date et le nom du fournisseur si visibles.${orderContext}`;

    // Try GPT-4.1-mini first, fallback to GPT-4.1
    let response;
    try {
      response = await openai.chat.completions.create({
        model: 'gpt-4.1-mini',
        temperature: 0,
        response_format: {
          type: 'json_schema',
          json_schema: {
            name: 'bl_extraction',
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
              { type: 'text', text: 'Extrais toutes les lignes de ce bon de livraison.' },
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
            name: 'bl_extraction',
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
              { type: 'text', text: 'Extrais toutes les lignes de ce bon de livraison.' },
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
    console.error('BL analysis error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};
