export default async function handler(request, response) {
  // Only allow GET requests (or whatever method cron-job.org sends)
  if (request.method !== 'GET' && request.method !== 'POST') {
    return response.status(455).json({ error: 'Method not allowed' });
  }

  const supabaseUrl = "https://korantkghgcwawfwlple.supabase.co/functions/v1/claim-free-key";
  const apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtvcmFudGtnaGdjd2F3ZndscGxlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NDM2NDEsImV4cCI6MjA5MjUxOTY0MX0.HzQO-zOjT-ZTbOKlWTIp8cTS5xqVfEqew9CpMKKgQzs";

  // Generate a random string to simulate a unique device ID for each run
  const uniqueId = 'Hacker-' + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);

  try {
    const res = await fetch(supabaseUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': apiKey,
        'Authorization': `Bearer ${apiKey}`
      },
      body: JSON.stringify({
        device_id: uniqueId
      })
    });

    const data = await res.json();

    // Return the response directly to the caller (cron-job.org)
    return response.status(res.status).json(data);

  } catch (error) {
    return response.status(500).json({ 
      success: false, 
      error: 'Failed to communicate with Supabase', 
      details: error.message 
    });
  }
}
