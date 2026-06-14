-- ============================================================
-- CatApp — ENDURECER LA SEGURIDAD (Row Level Security)
-- ============================================================
--
-- QUÉ ARREGLA ESTO
-- Hoy las reglas de `schema.sql` son todas `using(true)`: con la clave
-- pública (anon, que está a la vista en index.html) CUALQUIERA que abra
-- la web puede leer la lista completa de invitados (175 nombres, varios
-- de menores, + notas) y editar/borrar invitados y mesas. El "admin" hoy
-- solo lo controla el navegador, no la base.
--
-- Este archivo cierra la tabla de INVITADOS y de MESAS para que solo los
-- 4 admins (logueados con Google) puedan leerlas/escribirlas, y deja una
-- función segura para que un invitado pueda validar SU código sin poder
-- ver la lista entera.
--
-- ⚠️ PRERREQUISITO (IMPORTANTE):
-- 1) El login de Google tiene que estar conectado a Supabase Auth:
--    Supabase → Authentication → Providers → Google (activar) y poner el
--    Client ID / Secret. (Es el pendiente #2 del proyecto.)
-- 2) Hay que tocar UNA línea en index.html (ver "CAMBIO EN LA APP" abajo).
--
-- Si se aplica ESTE SQL ANTES de tener el login de Google andando, los
-- admins NO van a poder ver ni editar la lista de invitados (quedan
-- afuera). Por eso conviene hacerlo TODO JUNTO en la sesión de co-work.
--
-- Cómo aplicarlo: pegar TODO este archivo en el SQL Editor de Supabase y Run.
-- Es reversible: al final del archivo está el bloque para volver a abrir todo.
--
-- NOTA sobre canciones y votos: los invitados votan y piden temas de forma
-- ANÓNIMA (no se loguean con Google, solo los admins). Por eso las tablas
-- `songs` y `votes` se dejan abiertas a propósito: si las cerráramos, nadie
-- podría votar. Son datos poco sensibles (no hay datos personales) y, ante
-- un problema, se recuperan. Lo valioso a proteger es la lista de invitados.
-- ============================================================


-- ------------------------------------------------------------
-- 1) Lista blanca de admins (los 4 emails autorizados)
-- ------------------------------------------------------------
create table if not exists public.admins (
  email text primary key
);

insert into public.admins (email) values
  ('joselanglois@gmail.com'),     -- José (papá)
  ('catalinagodoy831@gmail.com'), -- Cata (cumpleañera)
  ('sgodoy608@gmail.com'),        -- Seba
  ('mariaisabel218@gmail.com')    -- Mari
on conflict (email) do nothing;

-- La tabla de admins queda cerrada al cliente: sin políticas RLS, la clave
-- anon no puede leerla ni escribirla. Solo las funciones SECURITY DEFINER
-- de abajo (que corren como dueñas) la consultan.
alter table public.admins enable row level security;


-- ------------------------------------------------------------
-- 2) ¿El usuario logueado es admin? (lee el email del login de Google)
-- ------------------------------------------------------------
create or replace function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admins
    where lower(email) = lower(auth.jwt() ->> 'email')
  );
$$;


-- ------------------------------------------------------------
-- 3) Validar el código de un invitado SIN exponer toda la lista
--    Devuelve solo la fila que coincide con ese código (o nada).
-- ------------------------------------------------------------
create or replace function public.validar_codigo_invitado(p_code text)
returns table (id uuid, name text, code text)
language sql
stable
security definer
set search_path = public
as $$
  select g.id, g.name, g.code
  from public.guests g
  where g.code = upper(trim(p_code))
  limit 1;
$$;

grant execute on function public.validar_codigo_invitado(text) to anon, authenticated;


-- ------------------------------------------------------------
-- 4) INVITADOS: solo los admins (con Google) leen/escriben la lista
-- ------------------------------------------------------------
drop policy if exists "validar codigo de invitado" on public.guests;
drop policy if exists "admins agregan invitados"   on public.guests;
drop policy if exists "admins editan invitados"    on public.guests;
drop policy if exists "admins borran invitados"    on public.guests;

create policy "guests: admins leen"   on public.guests for select using (public.es_admin());
create policy "guests: admins agregan" on public.guests for insert with check (public.es_admin());
create policy "guests: admins editan"  on public.guests for update using (public.es_admin()) with check (public.es_admin());
create policy "guests: admins borran"  on public.guests for delete using (public.es_admin());


-- ------------------------------------------------------------
-- 5) MESAS: la distribución de mesas es 100% cosa de admins
-- ------------------------------------------------------------
drop policy if exists "lectura de mesas" on public.mesas;
drop policy if exists "alta de mesas"    on public.mesas;
drop policy if exists "editar mesas"     on public.mesas;
drop policy if exists "borrar mesas"     on public.mesas;

create policy "mesas: admins leen"   on public.mesas for select using (public.es_admin());
create policy "mesas: admins agregan" on public.mesas for insert with check (public.es_admin());
create policy "mesas: admins editan"  on public.mesas for update using (public.es_admin()) with check (public.es_admin());
create policy "mesas: admins borran"  on public.mesas for delete using (public.es_admin());


-- ============================================================
-- CAMBIO EN LA APP (index.html) — hacerlo junto con este SQL
-- ============================================================
-- La función findGuestByCode() hoy lee la tabla guests directamente:
--
--     const { data, error } = await sb.from('guests')
--       .select('id, name, code').eq('code', code).maybeSingle();
--
-- Cambiarla para que use la función segura (así un invitado valida su
-- código sin poder leer toda la lista):
--
--     const { data, error } = await sb.rpc('validar_codigo_invitado', { p_code: code });
--     if (error) return null;
--     return (data && data[0]) || null;
--
-- (El resto de la app no cambia: los admins, al loguearse con Google,
--  siguen viendo y editando la lista completa.)


-- ============================================================
-- PARA REVERTIR (volver a dejar todo abierto como estaba)
-- Descomentar y ejecutar SOLO si algo sale mal y querés volver atrás:
-- ============================================================
-- drop policy if exists "guests: admins leen"   on public.guests;
-- drop policy if exists "guests: admins agregan" on public.guests;
-- drop policy if exists "guests: admins editan"  on public.guests;
-- drop policy if exists "guests: admins borran"  on public.guests;
-- drop policy if exists "mesas: admins leen"   on public.mesas;
-- drop policy if exists "mesas: admins agregan" on public.mesas;
-- drop policy if exists "mesas: admins editan"  on public.mesas;
-- drop policy if exists "mesas: admins borran"  on public.mesas;
-- create policy "validar codigo de invitado" on public.guests for select using (true);
-- create policy "admins agregan invitados"   on public.guests for insert with check (true);
-- create policy "admins editan invitados"    on public.guests for update using (true) with check (true);
-- create policy "admins borran invitados"    on public.guests for delete using (true);
-- create policy "lectura de mesas"  on public.mesas for select using (true);
-- create policy "alta de mesas"     on public.mesas for insert with check (true);
-- create policy "editar mesas"      on public.mesas for update using (true) with check (true);
-- create policy "borrar mesas"      on public.mesas for delete using (true);
