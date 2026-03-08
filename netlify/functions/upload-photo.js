/**
 * Netlify Function: Upload ingredient photo to Supabase Storage
 *
 * POST /api/upload-photo
 * Body: { image_base64, bucket, path }
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
    const { image_base64, bucket, path } = JSON.parse(event.body);

    if (!image_base64 || !bucket || !path) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Missing image_base64, bucket, or path' }),
      };
    }

    // Convert base64 to buffer
    const buffer = Buffer.from(image_base64, 'base64');

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
