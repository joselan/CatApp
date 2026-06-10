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

- **Activar Supabase** (modo fiesta compartida): seguir los 5 pasos de
  `INSTRUCCIONES-SUPABASE.md` cuando José esté en la computadora. Al
  terminar, José pasa la Project URL y la clave anon para pegarlas en
  `index.html` y publicar. Hasta entonces, cada teléfono guarda su
  propia lista (modo local).
- **Lista de invitados con códigos únicos y QR**: cuando José suba la
  lista (~200 invitados), generar un código único por invitado
  (editable por Cata/admins, tabla `guests` ya creada en el esquema)
  y un QR por invitado para mostrar en persona. Armar panel de admin
  para ver/editar códigos y descargar los QR.

## Admins de CatApp (4)

| Admin | Email | Código de acceso |
|---|---|---|
| José (papá) | joselanglois@gmail.com | `JOSE-K84M` |
| Cata (cumpleañera) | catalinagodoy831@gmail.com | `CATA-R29Q` |
| Seba | sgodoy608@gmail.com | `SEBA-T63V` |
| Mari | mariaisabel218@gmail.com | `MARI-P47X` |

- Código general de invitados: `CATA2026` (constante `PARTY_CODES`).
- Para que los otros 3 admins puedan usar "CONECTAR SPOTIFY",
  agregarlos en el dashboard de Spotify → app CatApp → Settings →
  User Management (nombre + email de su cuenta de Spotify).
- **Acceso admin con Google**: crear el Client ID gratuito siguiendo
  `INSTRUCCIONES-GOOGLE.md` (5 min, en la compu) y pegarlo en la
  constante `GOOGLE_CLIENT_ID` de `index.html`. Hasta entonces, los
  admins entran con su código de respaldo. El gesto: 5 toques sobre
  "Cata" en la pantalla de entrada.
