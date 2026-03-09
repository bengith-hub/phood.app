/**
 * Netlify Function: Search supplier logo
 *
 * POST /.netlify/functions/search-supplier-logo
 * Body: { name: "Promocash", email?: "contact@promocash.com" }
 *
 * Strategy:
 * 1. If email provided → extract domain → try Clearbit Logo API (free, no key)
 * 2. Search Google for "{name} logo" and extract image results
 * 3. Return array of logo candidates
 */

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { name, email } = JSON.parse(event.body || '{}');

    if (!name || name.trim().length < 2) {
      return {
        statusCode: 400,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ error: 'Nom du fournisseur requis' }),
      };
    }

    const logos = [];

    // Strategy 1: Clearbit from email domain
    if (email && email.includes('@')) {
      const domain = email.split('@')[1];
      // Skip generic email providers
      const generic = ['gmail.com', 'yahoo.fr', 'hotmail.com', 'outlook.com', 'orange.fr', 'free.fr', 'sfr.fr', 'wanadoo.fr', 'laposte.net'];
      if (!generic.includes(domain.toLowerCase())) {
        const clearbitUrl = `https://logo.clearbit.com/${domain}`;
        try {
          const resp = await fetch(clearbitUrl, { method: 'HEAD' });
          if (resp.ok) {
            logos.push({
              url: clearbitUrl,
              source: 'clearbit',
              label: `Logo via ${domain}`,
            });
          }
        } catch {
          // Clearbit not available for this domain
        }
      }
    }

    // Strategy 2: Try common corporate domain patterns
    const cleanName = name.trim().toLowerCase()
      .replace(/\s+/g, '')
      .replace(/[éèê]/g, 'e')
      .replace(/[àâ]/g, 'a')
      .replace(/[ùû]/g, 'u')
      .replace(/[ôö]/g, 'o')
      .replace(/[îï]/g, 'i')
      .replace(/[ç]/g, 'c');

    const domainGuesses = [
      `${cleanName}.fr`,
      `${cleanName}.com`,
      `${cleanName}.eu`,
    ];

    for (const domain of domainGuesses) {
      if (logos.some(l => l.url.includes(domain))) continue;
      const clearbitUrl = `https://logo.clearbit.com/${domain}`;
      try {
        const resp = await fetch(clearbitUrl, { method: 'HEAD' });
        if (resp.ok) {
          logos.push({
            url: clearbitUrl,
            source: 'clearbit',
            label: `Logo via ${domain}`,
          });
          break; // First match is enough
        }
      } catch {
        // Not available
      }
    }

    // Strategy 3: Bing image search as fallback
    if (logos.length === 0) {
      const searchQuery = encodeURIComponent(`${name.trim()} logo entreprise`);
      const url = `https://www.bing.com/images/search?q=${searchQuery}&first=1&count=6&qft=+filterui:aspect-square+filterui:imagesize-medium`;

      try {
        const resp = await fetch(url, {
          headers: {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html',
            'Accept-Language': 'fr-FR,fr;q=0.9',
          },
        });

        if (resp.ok) {
          const html = await resp.text();
          const mRegex = /m="({[^"]*?murl[^"]*?})"/g;
          let match;

          while ((match = mRegex.exec(html)) !== null && logos.length < 4) {
            try {
              const jsonStr = match[1]
                .replace(/&quot;/g, '"')
                .replace(/&amp;/g, '&')
                .replace(/&lt;/g, '<')
                .replace(/&gt;/g, '>');
              const data = JSON.parse(jsonStr);

              if (data.murl && data.turl) {
                logos.push({
                  url: data.murl,
                  thumbnail: data.turl,
                  source: 'web',
                  label: data.t || 'Logo web',
                });
              }
            } catch {
              continue;
            }
          }
        }
      } catch {
        // Bing search failed
      }
    }

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ logos, name: name.trim() }),
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: err.message || 'Erreur recherche logo' }),
    };
  }
};
