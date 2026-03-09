/**
 * Netlify Function: Search product photos via web scraping
 *
 * POST /.netlify/functions/search-product-photo
 * Body: { query: "Coca Cola 33cl" }
 *
 * Returns { images: [{ url, thumbnail, title }] } — up to 8 image results
 *
 * Uses Bing Image Search HTML scraping (no API key required).
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

    // Clean query: add "produit alimentaire" to bias toward food product images
    const searchQuery = `${query.trim()} produit alimentaire`;
    const encodedQuery = encodeURIComponent(searchQuery);

    // Strategy: Use Bing image search HTML page and extract image URLs from markup
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

    // Extract image data from Bing's HTML
    // Bing stores image metadata in m="" attributes as JSON
    const images = [];
    const mRegex = /m="({[^"]*?murl[^"]*?})"/g;
    let match;

    while ((match = mRegex.exec(html)) !== null && images.length < 8) {
      try {
        // Bing HTML-encodes the JSON in m="" attributes
        const jsonStr = match[1]
          .replace(/&quot;/g, '"')
          .replace(/&amp;/g, '&')
          .replace(/&lt;/g, '<')
          .replace(/&gt;/g, '>');

        const data = JSON.parse(jsonStr);

        if (data.murl && data.turl) {
          // Filter out obviously bad URLs (too small, SVG, etc.)
          if (data.murl.includes('.svg') || data.murl.includes('pixel')) continue;

          images.push({
            url: data.murl,        // Full-size image URL
            thumbnail: data.turl,   // Thumbnail URL
            title: data.t || '',    // Image title/alt text
          });
        }
      } catch {
        // Skip malformed entries
        continue;
      }
    }

    // Fallback: extract from data-src or src attributes for thumbnails
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
  } catch (err) {
    console.error('Photo search error:', err);
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: err.message || 'Erreur recherche photo' }),
    };
  }
};
