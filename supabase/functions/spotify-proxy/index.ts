// ============================================================
// CatApp — Edge Function "spotify-proxy"
// Busca en el catálogo real de Spotify para TODOS los invitados,
// sin que nadie tenga que iniciar sesión con Spotify: usa la
// credencial de la app (Client Credentials) guardada como secreto.
//
// Secretos requeridos (Edge Functions → Secrets):
//   SPOTIFY_CLIENT_ID      → Client ID de tu app de Spotify
//   SPOTIFY_CLIENT_SECRET  → Client Secret de tu app de Spotify
//
// Uso desde la app:
//   GET /spotify-proxy?q=texto          → búsqueda de canciones
//   GET /spotify-proxy?playlist=IDLISTA → contenido de una playlist pública
// ============================================================

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// El token de aplicación se conserva en memoria mientras la función esté
// "caliente" para no pedir uno nuevo en cada búsqueda
let cachedToken: { value: string; expiresAt: number } | null = null;

async function getAppToken(): Promise<string> {
  if (cachedToken && Date.now() < cachedToken.expiresAt) {
    return cachedToken.value;
  }

  const clientId = Deno.env.get("SPOTIFY_CLIENT_ID");
  const clientSecret = Deno.env.get("SPOTIFY_CLIENT_SECRET");
  if (!clientId || !clientSecret) {
    throw new Error(
      "Faltan los secretos SPOTIFY_CLIENT_ID / SPOTIFY_CLIENT_SECRET",
    );
  }

  const response = await fetch("https://accounts.spotify.com/api/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Basic " + btoa(`${clientId}:${clientSecret}`),
    },
    body: "grant_type=client_credentials",
  });
  const data = await response.json();
  if (!response.ok || !data.access_token) {
    throw new Error(data.error_description || "Spotify no entregó el token");
  }

  cachedToken = {
    value: data.access_token,
    expiresAt: Date.now() + ((data.expires_in || 3600) - 60) * 1000,
  };
  return cachedToken.value;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  try {
    const url = new URL(req.url);
    const q = url.searchParams.get("q");
    const playlist = url.searchParams.get("playlist");

    let apiUrl: string;
    if (q) {
      apiUrl = `https://api.spotify.com/v1/search?q=${
        encodeURIComponent(q)
      }&type=track&limit=8`;
    } else if (playlist && /^[a-zA-Z0-9]+$/.test(playlist)) {
      apiUrl = `https://api.spotify.com/v1/playlists/${playlist}`;
    } else {
      return jsonResponse({ error: "Falta el parámetro q o playlist" }, 400);
    }

    const token = await getAppToken();
    const response = await fetch(apiUrl, {
      headers: { "Authorization": `Bearer ${token}` },
    });
    const data = await response.json();
    return jsonResponse(data, response.status);
  } catch (err) {
    console.error("spotify-proxy error:", err);
    return jsonResponse({ error: String(err) }, 500);
  }
});
