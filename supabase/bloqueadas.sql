-- ============================================================
-- CatApp — Canciones bloqueadas por los admins
-- Pegá TODO este archivo en el SQL Editor de Supabase y ejecutá (Run).
-- Sirve si ya tenías Supabase activo desde antes: agrega la función
-- de bloqueo sin tocar las tablas que ya estaban funcionando.
-- (Si recién vas a activar Supabase, con correr schema.sql alcanza:
--  ya incluye esta tabla.)
-- ============================================================

-- Temas que los admins vetan para que ningún invitado los pida ni los vote.
-- title_key: título en minúsculas (clave para comparar y evitar duplicados).
-- spotify_id: id del tema en Spotify, cuando se bloqueó desde el catálogo real.
create table if not exists public.blocked_songs (
  id uuid primary key default gen_random_uuid(),
  title_key text not null unique,
  spotify_id text,
  title text not null,
  artist text,
  blocked_by text,
  created_at timestamptz not null default now()
);

alter table public.blocked_songs enable row level security;

create policy "lectura de bloqueadas" on public.blocked_songs for select using (true);
create policy "admins bloquean"       on public.blocked_songs for insert with check (true);
create policy "admins desbloquean"    on public.blocked_songs for delete using (true);

-- Sincronización en vivo: el bloqueo se comparte entre los 4 admins al instante
alter publication supabase_realtime add table public.blocked_songs;
