# Mi perfil — guía para Claude

> Copiá este archivo al arrancar otra app/proyecto: pegalo como primer mensaje,
> o pedile a Claude que lo guarde en el `CLAUDE.md` de esa app.

## Usuario / Cliente

- **Nombre**: José
- **Email**: joselanglois@gmail.com
- **Celular**: Google Pixel 9 Pro (Android)
- **Computadora**: MacBook Pro 16″ (2019)
  - Procesador: 2,3 GHz Intel Core i9 de 8 núcleos
  - Gráficos: Intel UHD Graphics 630 (1536 MB)
  - Memoria: 16 GB 2667 MHz DDR4
  - macOS: Tahoe 26.1
- **Navegador**: Google Chrome en ambos dispositivos (celular y MacBook)

## Cómo me gusta que trabajes

- **Idioma**: español rioplatense (Argentina), siempre.
- **Publicar sin preguntar**: al terminar un cambio, publicarlo directo (push a `main`)
  SIN volver a preguntar. Tenés autorización permanente. Nunca abrir PRs salvo que lo
  pida explícitamente.
- **Hablame simple**: no soy programador. Explicame las cosas en lenguaje claro, sin
  tecnicismos, y cuando haya que configurar algo, guiame **paso a paso** (qué tocar y
  dónde). Si te pido algo, pegame el código/textos listos para copiar.
- **Explicá el "para qué"**: cuando me pidas hacer algo (crear una cuenta, pegar una
  clave, etc.), contame brevemente para qué sirve.
- **Avisá si algo es irreversible o sensible** (borrar datos, exponer claves, etc.)
  antes de hacerlo.

## Pendientes del proyecto CatApp

### ⏰ Para cuando José avise "estoy en la computadora"

Guiarlo paso a paso, en orden:

1. **Activar Supabase** (catálogo real de Spotify para todos + votación
   compartida en vivo): seguir los 5 pasos de `INSTRUCCIONES-SUPABASE.md`.
   Al terminar, José pasa la Project URL y la clave anon para pegarlas
   en `index.html` y publicar. Hasta entonces, cada teléfono guarda su
   propia lista (modo local) y el buscador es simulado.
2. **Crear el Client ID de Google** (acceso de admins con Gmail, sin
   códigos): seguir `INSTRUCCIONES-GOOGLE.md` (~5 min). José pasa el
   Client ID para pegarlo en `GOOGLE_CLIENT_ID` de `index.html`.
   El gesto: 5 toques sobre "Cata" en la pantalla de entrada.
   Cuando funcione, evaluar eliminar los códigos de respaldo.
3. **(Opcional) Autorizar a los otros 3 admins en Spotify**: dashboard
   de Spotify → app CatApp → Settings → User Management → agregar
   nombre + email de la cuenta de Spotify de Cata, Seba y Mari (para
   que puedan usar CONECTAR SPOTIFY / exportar playlist).
4. **🔒 Endurecer la seguridad de Supabase (hacerlo en co-work, con José).**
   Hoy las reglas (RLS) en `supabase/schema.sql` son todas `using(true)`:
   con la clave anon (pública en `index.html`) cualquiera puede LEER toda
   la lista de invitados (nombres de menores + notas) y BORRAR/EDITAR
   canciones, votos, invitados y mesas. El "admin" hoy solo lo controla el
   navegador, no la base. El arreglo correcto depende de tener el login de
   Google enchufado a Supabase Auth (pendiente #2) para distinguir admins
   a nivel base. A revisar y aplicar juntos en la sesión de la compu:
   restringir lectura/borrado de `guests` y limitar escrituras masivas.

### ✅ Hecho: lista de invitados con códigos únicos y QR

- Importada del Excel (91 invitaciones, 175 personas, 8 grupos).
- Cada invitación tiene código único de 4 caracteres y QR que abre la
  app con el código precargado (`?codigo=XXXX`).
- Panel 👥 Invitados (solo admins, botón en el Ranking): buscar, editar
  códigos y notas, marcar save-the-date y confirmaciones (los cambios
  de confirmación se llevan en la app, ya no en el Excel).
- En modo local los cambios viven en cada teléfono; al activar Supabase
  la lista se sube sola la primera vez que un admin abre la app y ahí
  se comparte entre los 4 admins.

## Admins de CatApp (4)

| Admin | Email | Código de acceso |
|---|---|---|
| José (papá) | joselanglois@gmail.com | `JOSE-K84M` |
| Cata (cumpleañera) | catalinagodoy831@gmail.com | `CATA-R29Q` |
| Seba | sgodoy608@gmail.com | `SEBA-T63V` |
| Mari | mariaisabel218@gmail.com | `MARI-P47X` |

- Código general de invitados: `CATA2026` (constante `PARTY_CODES`).
