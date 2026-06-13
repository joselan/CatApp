# CatApp — Activar el modo fiesta compartida (Supabase)

Con esto los **175 invitados** (91 invitaciones) usan la app completa: buscan en el catálogo
**real** de Spotify (sin loguearse con Spotify) y la playlist, los votos y los
pedidos se comparten **en vivo entre todos los teléfonos**.

Son 5 pasos, todos con el plan gratuito de Supabase (no pide tarjeta).

---

## Paso 1 — Crear el proyecto

1. Entrá a **https://supabase.com** → **Start your project** → creá tu cuenta
   (podés entrar con GitHub).
2. **New project** → poné un nombre (ej. `catapp`), una contraseña de base de
   datos (guardala en cualquier lado, no la vas a necesitar para la app) y
   elegí la región más cercana (ej. *South America (São Paulo)*).
3. Esperá 1-2 minutos a que el proyecto termine de crearse.

## Paso 2 — Crear las tablas

1. En el menú lateral: **SQL Editor**.
2. Abrí el archivo **`supabase/schema.sql`** de este repositorio, copiá TODO
   su contenido y pegalo en el editor.
3. Botón **Run**. Tiene que decir "Success. No rows returned".

## Paso 3 — Crear la función de búsqueda de Spotify

1. En el menú lateral: **Edge Functions** → **Deploy a new function** →
   elegí la opción de crear **via Editor** (en el navegador).
2. Nombre de la función: `spotify-proxy` (exactamente así).
3. Borrá el código de ejemplo y pegá TODO el contenido del archivo
   **`supabase/functions/spotify-proxy/index.ts`** de este repositorio.
4. Botón **Deploy function**.

## Paso 4 — Guardar las credenciales de Spotify como secretos

1. En **Edge Functions** → pestaña **Secrets** (o Settings → Edge Functions →
   Secrets).
2. Agregá estos dos secretos:
   - `SPOTIFY_CLIENT_ID` → `714f08a16c5d452ebda528fd1190ab4a`
   - `SPOTIFY_CLIENT_SECRET` → lo sacás del dashboard de Spotify:
     https://developer.spotify.com/dashboard → tu app **CatApp** →
     **Settings** → **View client secret** → copiá esa tira larga.

⚠️ El *client secret* nunca va en `index.html` ni en el repositorio: solo acá,
como secreto del servidor.

## Paso 5 — Conectar la app

1. En Supabase: **Project Settings** (engranaje) → **API**. Copiá:
   - **Project URL** (ej. `https://abcdefghijkl.supabase.co`)
   - **anon public** key (la tira larga que dice `anon` / `public`)
2. Pegá esos dos valores en `index.html`, al principio del `<script>`:

   ```js
   const SUPABASE_URL = 'https://abcdefghijkl.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJ...';
   ```

   (o pasáselos a Claude y los configura por vos)
3. Subí el cambio a GitHub (rama `main`) y listo.

> 💡 **Dónde vive la web:** CatApp está publicada en Vercel (https://cat-app-nu.vercel.app/). No hay que "subir" nada a mano: cada vez que se sube un cambio a la rama `main`, Vercel republica la web sola en unos segundos.

---

## ¿Cómo sé que funcionó?

- Abrí la app, entrá con tu código y andá a la pestaña **Añadir**: el banner
  tiene que decir **"✓ Catálogo real activo para todos los invitados"**.
- Buscá cualquier canción: tienen que aparecer resultados reales de Spotify
  con sus tapas de álbum.
- Abrí la app en **dos teléfonos a la vez**: lo que uno agrega o vota aparece
  en el otro a los pocos segundos.

## Notas

- **Lista de invitados**: no hay que hacer nada extra. La primera vez que un
  admin abra la app (o el panel 👥 Invitados) con Supabase activo, la lista
  del Excel se sube sola a la base compartida con sus códigos. Si preferís
  cargarla a mano, también está en `supabase/invitados-seed.sql`.

- La playlist arranca **vacía** (los temas de demostración desaparecen porque
  ahora la lista es la real de la fiesta). Cata puede inaugurarla agregando
  sus favoritas 🎶
- El botón **CONECTAR SPOTIFY** sigue existiendo: sirve para que vos (dueño de
  la app de Spotify) importes también tus **playlists privadas**. Los
  invitados no lo necesitan.
- Plan gratuito de Supabase: de sobra para una fiesta (500 MB de base de
  datos, 500.000 invocaciones de funciones por mes). Único detalle: si el
  proyecto pasa 7 días sin uso, Supabase lo pausa — entrá al dashboard y
  tocá **Restore** (o usá la app) unos días antes de la fiesta.
