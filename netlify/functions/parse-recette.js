/**
 * Netlify Function: Parse recipe text via OpenAI
 *
 * POST /api/parse-recette
 * Body: { text: "raw recipe text" }
 *
 * Returns structured JSON with recipe name, portions, and ingredient list.
 */

const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const SCHEMA = {
  type: 'object',
  properties: {
    nom: { type: 'string', description: 'Recipe name' },
    nb_portions: { type: 'number', description: 'Number of portions/servings' },
    description: { type: ['string', 'null'], description: 'Short description' },
    ingredients: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          nom: { type: 'string', description: 'Ingredient name' },
          quantite: { type: 'number', description: 'Quantity needed' },
          unite: { type: 'string', description: 'Unit (kg, g, L, mL, pièce, botte, etc.)' },
          confiance: { type: 'number', description: 'Confidence score 0-1 for parsing accuracy' },
        },
        required: ['nom', 'quantite', 'unite', 'confiance'],
        additionalProperties: false,
      },
    },
    instructions: { type: ['string', 'null'], description: 'Preparation steps if found' },
  },
  required: ['nom', 'nb_portions', 'ingredients'],
  additionalProperties: false,
};

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { text } = JSON.parse(event.body);

    if (!text || text.trim().length < 10) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Text too short' }) };
    }

    const systemPrompt = `Tu es un assistant spécialisé dans l'analyse de recettes de cuisine pour la restauration professionnelle.
À partir du texte brut fourni (copié-collé d'un site web, carnet, etc.), extrais :
- Le nom de la recette
- Le nombre de portions
- La liste complète des ingrédients avec quantités et unités
- Les instructions de préparation si présentes

Convertis les unités en format standard restaurant :
- Cuillères à soupe → g ou mL (1 cas = ~15mL ou ~15g)
- Cuillères à café → g ou mL (1 cac = ~5mL ou ~5g)
- Verres → mL (1 verre = ~200mL)
- Pincée → g (1 pincée = ~1g)
- Conserve les kg, g, L, mL, pièce, botte tels quels

Si le nombre de portions n'est pas mentionné, estime-le à 4.
Score de confiance : 1.0 si clairement lisible, 0.7 si interprété, 0.5 si deviné.`;

    let response;
    try {
      response = await openai.chat.completions.create({
        model: 'gpt-4.1-mini',
        temperature: 0,
        response_format: {
          type: 'json_schema',
          json_schema: {
            name: 'recette_parsing',
            strict: true,
            schema: SCHEMA,
          },
        },
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: `Analyse cette recette :\n\n${text}` },
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
            name: 'recette_parsing',
            strict: true,
            schema: SCHEMA,
          },
        },
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: `Analyse cette recette :\n\n${text}` },
        ],
      });
    }

    const result = JSON.parse(response.choices[0].message.content);

    return {
      statusCode: 200,
      body: JSON.stringify(result),
    };
  } catch (error) {
    console.error('Recipe parsing error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};
