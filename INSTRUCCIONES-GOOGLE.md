# CatApp — Activar el acceso de admins con Google

Los 4 admins (José, Cata, Seba y Mari) entran **tocando 5 veces el nombre
"Cata"** en la pantalla de entrada y eligiendo su cuenta de Google. Sin
códigos, sin registrarse.

Para que Google lo permita hay que crear una credencial gratuita (un
"Client ID"). Son 5 minutos, desde la computadora:

---

## Paso 1 — Crear el proyecto en Google

1. Entrá a **https://console.cloud.google.com** con tu cuenta
   (joselanglois@gmail.com).
2. Arriba a la izquierda, tocá el selector de proyectos → **New Project /
   Proyecto nuevo** → nombre: `CatApp` → **Create/Crear**.
3. Esperá unos segundos y asegurate de que el proyecto `CatApp` quede
   seleccionado arriba.

## Paso 2 — Pantalla de consentimiento

1. Menú ☰ → **APIs y servicios** → **Pantalla de consentimiento de OAuth**
   (en consolas nuevas se llama **Google Auth Platform → Branding**).
2. Tipo de usuario: **Externo** → Crear.
3. Completá lo mínimo: nombre de la app `CatApp`, mail de asistencia tu
   gmail, y tu gmail otra vez como contacto del desarrollador → Guardar.
4. En **Público/Audience**: dejá el modo **Prueba (Testing)** y en
   **Usuarios de prueba (Test users)** agregá los 4 mails:
   - joselanglois@gmail.com
   - catalinagodoy831@gmail.com
   - sgodoy608@gmail.com
   - mariaisabel218@gmail.com

   (En modo Prueba solo esos mails pueden usar el login — perfecto para
   nosotros, y no hace falta ninguna verificación de Google.)

## Paso 3 — Crear el Client ID

1. **APIs y servicios → Credenciales** (o **Google Auth Platform →
   Clients**) → **Crear credenciales → ID de cliente de OAuth**.
2. Tipo de aplicación: **Aplicación web**. Nombre: `CatApp Web`.
3. En **Orígenes de JavaScript autorizados** agregá exactamente:
   ```
   https://cat-app-nu.vercel.app
   ```
   (Acá va SIN la barra final, así lo pide Google para los orígenes.)
4. **Crear** → copiá el **ID de cliente** (una tira larga que termina en
   `.apps.googleusercontent.com`).

## Paso 4 — Conectarlo a CatApp

Pasale a Claude el ID de cliente (o pegalo vos en `index.html`, en la
constante `GOOGLE_CLIENT_ID`) y publicá. ¡Listo!

> 💡 La web vive en Vercel (https://cat-app-nu.vercel.app/) y se actualiza sola cada vez que se sube un cambio a la rama `main`.

---

## ¿Cómo se usa después?

- Cualquier admin: abre CatApp → toca **5 veces seguidas** el nombre
  **"Cata"** → botón **Continuar con Google** → elige su cuenta → adentro,
  con panel completo.
- Si alguien entra con un Gmail que no es de los 4, la app lo rechaza.
- Los códigos de admin (`JOSE-K84M`, etc.) siguen funcionando como
  respaldo de emergencia; cuando el acceso con Google esté probado,
  se pueden eliminar.
