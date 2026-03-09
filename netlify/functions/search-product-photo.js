/**
 * Netlify Function: Search product photos via DuckDuckGo Image Search
 *
 * POST /.netlify/functions/search-product-photo
 * Body: { query: "Coca Cola 33cl" }
 *
 * Returns { images: [{ url, thumbnail, title }] } — up to 8 image results
 *
 * Uses DuckDuckGo Image Search JSON API (no API key required).
 */

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { query } = JSON.parse(event.body || '{}');

    if (!query || query.trim().length < 2) {
      return {
        statusCode: 400,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ error: 'Query trop courte (min 2 caractères)' }),
      };
    }

    const searchQuery = `${query.trim()} produit fond blanc`;

    // Step 1: Get the vqd token from DuckDuckGo
    const tokenUrl = `https://duckduckgo.com/?q=${encodeURIComponent(searchQuery)}&iax=images&ia=images`;
    const tokenResp = await fetch(tokenUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml',
        'Accept-Language': 'fr-FR,fr;q=0.9',
      },
    });

    if (!tokenResp.ok) {
      throw new Error(`DuckDuckGo token request failed: ${tokenResp.status}`);
    }

    const html = await tokenResp.text();

    // Extract vqd token from the HTML page
    const vqdMatch = html.match(/vqd=["']([^"']+)["']/i)
      || html.match(/vqd=([\d-]+)/i)
      || html.match(/"vqd":"([^"]+)"/i);

    if (!vqdMatch) {
      // Fallback: try Bing as backup
      return await searchBingFallback(searchQuery);
    }

    const vqd = vqdMatch[1];

    // Step 2: Fetch image results using the JSON endpoint
    const imageUrl = `https://duckduckgo.com/i.js?l=fr-fr&o=json&q=${encodeURIComponent(searchQuery)}&vqd=${vqd}&f=,size:Medium,type:photo&p=1`;

    const imageResp = await fetch(imageUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json',
        'Referer': 'https://duckduckgo.com/',
      },
    });

    if (!imageResp.ok) {
      return await searchBingFallback(searchQuery);
    }

    const data = await imageResp.json();

    const images = (data.results || [])
      .slice(0, 8)
      .filter((r) => r.image && r.thumbnail && !r.image.includes('.svg'))
      .map((r) => ({
        url: r.image,
        thumbnail: r.thumbnail,
        title: r.title || '',
      }));

    if (images.length === 0) {
      return await searchBingFallback(searchQuery);
    }

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ images, query: searchQuery }),
    };
  } catch (err) {
    console.error('Photo search error:', err);

    // Try Bing fallback on any error
    try {
      const { query } = JSON.parse(event.body || '{}');
      const searchQuery = `${query.trim()} produit fond blanc`;
      return await searchBingFallback(searchQuery);
    } catch {
      return {
        statusCode: 500,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ error: err.message || 'Erreur recherche photo' }),
      };
    }
  }
};

/**
 * Fallback: Bing image search via HTML scraping
 */
async function searchBingFallback(searchQuery) {
  const encodedQuery = encodeURIComponent(searchQuery);
  const url = `https://www.bing.com/images/search?q=${encodedQuery}&first=1&count=12&qft=+filterui:aspect-square`;

  const resp = await fetch(url, {
    headers: {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml',
      'Accept-Language': 'fr-FR,fr;q=0.9',
    },
  });

  if (!resp.ok) {
    throw new Error(`Bing search failed: ${resp.status}`);
  }

  const html = await resp.text();

  const images = [];
  const mRegex = /m="({[^"]*?murl[^"]*?})"/g;
  let match;

  while ((match = mRegex.exec(html)) !== null && images.length < 8) {
    try {
      const jsonStr = match[1]
        .replace(/&quot;/g, '"')
        .replace(/&amp;/g, '&')
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>');

      const data = JSON.parse(jsonStr);

      if (data.murl && data.turl) {
        if (data.murl.includes('.svg') || data.murl.includes('pixel')) continue;
        images.push({
          url: data.murl,
          thumbnail: data.turl,
          title: data.t || '',
        });
      }
    } catch {
      continue;
    }
  }

  // Fallback: extract from src attributes
  if (images.length === 0) {
    const imgRegex = /class="mimg[^"]*"[^>]*src="(https:\/\/[^"]+)"/g;
    while ((match = imgRegex.exec(html)) !== null && images.length < 8) {
      images.push({
        url: match[1],
        thumbnail: match[1],
        title: '',
      });
    }
  }

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ images, query: searchQuery }),
  };
}
