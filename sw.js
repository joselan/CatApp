/* ============================================================
   CatApp — Service Worker
   Hace que la app abra al instante y funcione aunque la señal
   esté saturada en la fiesta. NO cachea datos de Supabase ni
   de Spotify (esos siempre se piden frescos a internet).

   Estrategia:
   - HTML y CSS  -> "red primero" (si publico cambios, se ven enseguida;
                    si no hay red, usa la última versión guardada).
   - Imágenes/fuentes/íconos -> "caché primero" (cargan al toque).
   - Supabase / Spotify / métodos que no sean GET -> nunca se tocan.
   ============================================================ */

const CACHE = 'catapp-v2026-06-14';

// Lo mínimo para que la app abra estando sin señal.
const PRECACHE = [
  './',
  './index.html',
  './catapp.css',
  './manifest.webmanifest',
  './icon-192.png',
  './icon-512.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE)
      .then((cache) => cache.addAll(PRECACHE))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// Dominios de datos en vivo: nunca se cachean.
function esDatoEnVivo(url) {
  return url.includes('supabase') ||
         url.includes('spotify.com') ||
         url.includes('accounts.google.com') ||
         url.includes('googleapis.com/oauth');
}

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;                 // solo lecturas
  if (esDatoEnVivo(req.url)) return;                 // datos siempre frescos

  const esNavegacion = req.mode === 'navigate';
  const esCss = req.destination === 'style' || req.url.endsWith('.css');

  // HTML y CSS -> red primero, con respaldo en caché
  if (esNavegacion || esCss) {
    event.respondWith(
      fetch(req)
        .then((res) => {
          const copia = res.clone();
          caches.open(CACHE).then((c) => c.put(req, copia));
          return res;
        })
        .catch(() => caches.match(req).then((r) => r || caches.match('./index.html')))
    );
    return;
  }

  // Imágenes, fuentes, íconos -> caché primero, y se actualiza de fondo
  event.respondWith(
    caches.match(req).then((cacheado) => {
      const enRed = fetch(req).then((res) => {
        if (res && res.status === 200) {
          const copia = res.clone();
          caches.open(CACHE).then((c) => c.put(req, copia));
        }
        return res;
      }).catch(() => cacheado);
      return cacheado || enRed;
    })
  );
});
