-- ============================================================
-- CatApp — Mesas compartidas entre los 4 admins (Supabase)
-- Pegar TODO este archivo en el SQL Editor de Supabase y ejecutar (Run).
-- Se puede ejecutar más de una vez sin romper nada.
-- Mientras no se ejecute, las mesas funcionan igual pero solo en
-- el teléfono de cada admin (no se comparten).
-- ============================================================

create table if not exists public.mesas (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  capacity int not null default 10,
  guest_ids jsonb not null default '[]'::jsonb,
  position int not null default 0,
  created_at timestamptz not null default now()
);

alter table public.mesas enable row level security;

drop policy if exists "lectura de mesas" on public.mesas;
drop policy if exists "alta de mesas"    on public.mesas;
drop policy if exists "editar mesas"     on public.mesas;
drop policy if exists "borrar mesas"     on public.mesas;

create policy "lectura de mesas" on public.mesas for select using (true);
create policy "alta de mesas"    on public.mesas for insert with check (true);
create policy "editar mesas"     on public.mesas for update using (true) with check (true);
create policy "borrar mesas"     on public.mesas for delete using (true);

-- Sincronización en vivo entre los teléfonos de los admins.
-- (Si ya estaba agregada, este paso puede tirar un aviso; se ignora.)
do $$
begin
  alter publication supabase_realtime add table public.mesas;
exception when duplicate_object then
  null;
end $$;
