-- ============================================================
-- CatApp — Esquema de la playlist compartida (Supabase)
-- Pegar TODO este archivo en el SQL Editor de Supabase y ejecutar (Run).
-- ============================================================

-- Canciones pedidas por los invitados
-- played_at: cuándo la reprodujo el DJ en la fiesta (Modo DJ)
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
  played_at timestamptz,
  created_at timestamptz not null default now()
);

-- Evita duplicados: misma canción de Spotify o mismo título
create unique index if not exists songs_spotify_id_unico
  on public.songs (spotify_id) where spotify_id is not null;
create unique index if not exists songs_titulo_unico
  on public.songs (lower(title));

-- Votos: un voto por invitado (teléfono) por canción.
-- guest_name: para que los admins vean quién votó qué.
-- message: dedicatoria opcional que deja el invitado al votar.
create table if not exists public.votes (
  song_id uuid not null references public.songs(id) on delete cascade,
  guest_id text not null,
  guest_name text,
  message text,
  created_at timestamptz not null default now(),
  primary key (song_id, guest_id)
);

-- Invitados con código único (editable por Cata y los admins).
-- Datos importados del Excel de la fiesta; cada código tiene su QR.
-- confirmed: 'pendiente' | 'si' | 'no'
create table if not exists public.guests (
  id uuid primary key default gen_random_uuid(),
  group_name text,
  name text not null,
  code text not null unique,
  adults int not null default 0,
  kids int not null default 0,
  under5 int not null default 0,
  total int not null default 0,
  save_the_date boolean not null default false,
  confirmed text not null default 'pendiente',
  notes text,
  created_at timestamptz not null default now()
);

-- Distribución de mesas (la editan solo los admins desde la app).
-- guest_ids: lista de invitados (ids de la tabla guests) sentados en la mesa.
create table if not exists public.mesas (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  capacity int not null default 10,
  guest_ids jsonb not null default '[]'::jsonb,
  position int not null default 0,
  created_at timestamptz not null default now()
);

-- Canciones bloqueadas: temas que los admins vetan para que ningún
-- invitado pueda pedirlos ni votarlos.
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

-- Seguridad a nivel de fila: la fiesta es abierta para los invitados
-- (la clave "anon" solo permite lo que definen estas políticas)
alter table public.songs enable row level security;
alter table public.votes enable row level security;
alter table public.guests enable row level security;
alter table public.mesas enable row level security;
alter table public.blocked_songs enable row level security;

create policy "lectura publica de canciones"  on public.songs for select using (true);
create policy "invitados agregan canciones"   on public.songs for insert with check (true);
create policy "invitados retiran canciones"   on public.songs for delete using (true);
create policy "marcar cancion como sonada"    on public.songs for update using (true) with check (true);

create policy "lectura publica de votos"  on public.votes for select using (true);
create policy "invitados votan"           on public.votes for insert with check (true);
create policy "invitados quitan su voto"  on public.votes for delete using (true);
create policy "dedicatoria del propio voto" on public.votes for update using (true) with check (true);

create policy "validar codigo de invitado" on public.guests for select using (true);
create policy "admins agregan invitados"   on public.guests for insert with check (true);
create policy "admins editan invitados"    on public.guests for update using (true) with check (true);
create policy "admins borran invitados"    on public.guests for delete using (true);

create policy "lectura de mesas"  on public.mesas for select using (true);
create policy "alta de mesas"     on public.mesas for insert with check (true);
create policy "editar mesas"      on public.mesas for update using (true) with check (true);
create policy "borrar mesas"      on public.mesas for delete using (true);

create policy "lectura de bloqueadas" on public.blocked_songs for select using (true);
create policy "admins bloquean"       on public.blocked_songs for insert with check (true);
create policy "admins desbloquean"    on public.blocked_songs for delete using (true);

-- Sincronización en vivo: los cambios se transmiten a todos los teléfonos
alter publication supabase_realtime add table public.songs;
alter publication supabase_realtime add table public.votes;
alter publication supabase_realtime add table public.guests;
alter publication supabase_realtime add table public.mesas;
alter publication supabase_realtime add table public.blocked_songs;
