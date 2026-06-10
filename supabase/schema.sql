-- ============================================================
-- CatApp — Esquema de la playlist compartida (Supabase)
-- Pegar TODO este archivo en el SQL Editor de Supabase y ejecutar (Run).
-- ============================================================

-- Canciones pedidas por los invitados
create table if not exists public.songs (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  artist text not null,
  album text,
  cover_url text,
  preview_url text,
  genre text,
  spotify_id text,
  added_by text not null,
  added_by_id text not null,
  created_at timestamptz not null default now()
);

-- Evita duplicados: misma canción de Spotify o mismo título
create unique index if not exists songs_spotify_id_unico
  on public.songs (spotify_id) where spotify_id is not null;
create unique index if not exists songs_titulo_unico
  on public.songs (lower(title));

-- Votos: un voto por invitado (teléfono) por canción.
-- guest_name se guarda para que los admins vean quién votó qué.
create table if not exists public.votes (
  song_id uuid not null references public.songs(id) on delete cascade,
  guest_id text not null,
  guest_name text,
  created_at timestamptz not null default now(),
  primary key (song_id, guest_id)
);

-- Seguridad a nivel de fila: la fiesta es abierta para los invitados
-- (la clave "anon" solo permite lo que definen estas políticas)
alter table public.songs enable row level security;
alter table public.votes enable row level security;

create policy "lectura publica de canciones"  on public.songs for select using (true);
create policy "invitados agregan canciones"   on public.songs for insert with check (true);
create policy "invitados retiran canciones"   on public.songs for delete using (true);

create policy "lectura publica de votos" on public.votes for select using (true);
create policy "invitados votan"          on public.votes for insert with check (true);
create policy "invitados quitan su voto" on public.votes for delete using (true);

-- Sincronización en vivo: los cambios se transmiten a todos los teléfonos
alter publication supabase_realtime add table public.songs;
alter publication supabase_realtime add table public.votes;
