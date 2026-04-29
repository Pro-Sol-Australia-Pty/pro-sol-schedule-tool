-- Supabase schema for the Pro-Sol Schedule Tool.
-- Run this in Supabase SQL Editor before enabling cloud sync in public/config.js.

create extension if not exists pgcrypto;

create table if not exists public.schedules (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null default 'Pro-Sol Schedule Tool',
  tasks jsonb not null default '[]'::jsonb,
  custom_categories jsonb not null default '[]'::jsonb,
  category_order jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists schedules_set_updated_at on public.schedules;
create trigger schedules_set_updated_at
before update on public.schedules
for each row execute function public.set_updated_at();

alter table public.schedules enable row level security;

drop policy if exists "Public can read default schedule" on public.schedules;
create policy "Public can read default schedule"
on public.schedules
for select
to anon
using (slug = 'default');

drop policy if exists "Public can create default schedule" on public.schedules;
create policy "Public can create default schedule"
on public.schedules
for insert
to anon
with check (slug = 'default');

drop policy if exists "Public can update default schedule" on public.schedules;
create policy "Public can update default schedule"
on public.schedules
for update
to anon
using (slug = 'default')
with check (slug = 'default');

insert into public.schedules (slug, title, tasks, custom_categories, category_order)
values ('default', 'Pro-Sol Schedule Tool', '[]'::jsonb, '[]'::jsonb, '[]'::jsonb)
on conflict (slug) do nothing;
