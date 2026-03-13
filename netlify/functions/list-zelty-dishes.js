/**
 * Netlify Function: List all Zelty dishes
 * GET /.netlify/functions/list-zelty-dishes
 *
 * Returns simplified list: [{id, name, image}]
 * Used by RecetteDetailPage Zelty dropdown.
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 500;

exports.handler = async function (event) {
  if (event.httpMethod !== 'GET') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
  if (!ZELTY_API_KEY) {
    return { statusCode: 500, body: JSON.stringify({ error: 'ZELTY_API_KEY non configurée' }) };
  }

  try {
    let allDishes = [];
    let offset = 0;
    let hasMore = true;

    while (hasMore) {
      const url = `${ZELTY_BASE_URL}/catalog/dishes?limit=${PAGE_SIZE}&offset=${offset}&show_all=true`;
      const resp = await fetch(url, {
        headers: {
          'Authorization': `Bearer ${ZELTY_API_KEY}`,
          'Accept': 'application/json',
        },
      });

      if (!resp.ok) {
        const errText = await resp.text();
        throw new Error(`Zelty API error ${resp.status}: ${errText}`);
      }

      const data = await resp.json();
      const dishes = data.dishes || [];
      allDishes.push(...dishes);

      if (dishes.length < PAGE_SIZE) {
        hasMore = false;
      } else {
        offset += PAGE_SIZE;
      }
    }

    const result = allDishes.map(d => ({
      id: String(d.id),
      name: d.name || '',
      image: d.image || d.thumb || null,
    }));

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'public, max-age=300',
      },
      body: JSON.stringify(result),
    };
  } catch (err) {
    console.error('list-zelty-dishes error:', err);
    return { statusCode: 500, body: JSON.stringify({ error: err.message }) };
  }
};
