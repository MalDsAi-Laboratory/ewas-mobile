/**
 * Cloudflare Worker — ScrapIt Release Proxy
 *
 * Proxies GitHub API /releases/latest for the private ewas-mobile repo.
 * Adds Bearer token server-side so the public landing page can fetch it
 * without exposing the token in client-side code.
 *
 * Requires secret: GITHUB_TOKEN (fine-grained, Contents: Read on ewas-mobile)
 */

const GITHUB_API =
  'https://api.github.com/repos/MalDsAi-Laboratory/ewas-mobile/releases/latest';

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

export default {
  async fetch(request, env) {
    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: CORS_HEADERS });
    }

    if (request.method !== 'GET') {
      return new Response('Method not allowed', { status: 405 });
    }

    try {
      const response = await fetch(GITHUB_API, {
        headers: {
          Authorization: `Bearer ${env.GITHUB_TOKEN}`,
          Accept: 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
          'User-Agent': 'ScrapIt-Release-Proxy/1.0',
        },
      });

      if (!response.ok) {
        return new Response(
          JSON.stringify({ error: `GitHub API returned ${response.status}` }),
          {
            status: response.status,
            headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
          }
        );
      }

      const data = await response.json();

      return new Response(JSON.stringify(data), {
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          // Cache for 5 minutes — balances freshness vs API rate limits
          'Cache-Control': 'public, max-age=300',
          ...CORS_HEADERS,
        },
      });
    } catch (err) {
      return new Response(
        JSON.stringify({ error: 'Failed to fetch release', detail: err.message }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
        }
      );
    }
  },
};
