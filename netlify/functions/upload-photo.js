/**
 * Netlify Function: Upload ingredient photo to Supabase Storage
 *
 * POST /api/upload-photo
 * Body: { image_base64, bucket, path }
 *   OR: { image_url, bucket, path }  (downloads the image server-side first)
 *
 * Returns { url } — the public URL of the uploaded photo.
 */

const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.VITE_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { image_base64, image_url, bucket, path } = JSON.parse(event.body);

    if (!bucket || !path) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Missing bucket or path' }),
      };
    }

    let buffer;

    if (image_url) {
      // Download image from URL server-side (avoids browser CORS issues)
      const resp = await fetch(image_url, {
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
          'Accept': 'image/*,*/*',
        },
      });
      if (!resp.ok) throw new Error(`Image download failed: ${resp.status}`);
      const arrayBuf = await resp.arrayBuffer();
      buffer = Buffer.from(arrayBuf);
    } else if (image_base64) {
      buffer = Buffer.from(image_base64, 'base64');
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Missing image_base64 or image_url' }),
      };
    }

    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, buffer, {
        contentType: 'image/jpeg',
        upsert: true,
      });

    if (error) throw error;

    const { data: urlData } = supabase.storage
      .from(bucket)
      .getPublicUrl(data.path);

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ url: urlData.publicUrl }),
    };
  } catch (err) {
    console.error('Upload error:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message || 'Upload failed' }),
    };
  }
};
