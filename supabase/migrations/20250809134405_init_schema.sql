-- === EXTENSIONS ===
create extension if not exists pgcrypto; -- for gen_random_uuid()

-- === PROFILES ===
-- 1:1 with auth.users; a row is created automatically on user signup (trigger below)
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Player',
  phone text, -- store E.164, e.g. +31612345678
  role text not null check (role in ('member','organizer')) default 'member',
  created_at timestamptz not null default now()
);

-- Automatically create a profile row when a new user signs up
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name, role)
  values (new.id,
          coalesce((new.raw_user_meta_data->>'display_name')::text, 'Player'),
          'member')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- === GROUNDS ===
create table public.grounds (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  maps_url text,
  capacity int not null
);

-- === GAMES ===
create table public.games (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  start_time timestamptz not null,
  location text,
  min int not null default 8,
  cap int not null default 14,
  state text not null check (state in ('public','private','locked','cancelled','played')) default 'public',
  organizer_id uuid not null references public.profiles(id) on delete restrict,
  created_at timestamptz not null default now()
);

-- === RSVPS ===
create table public.rsvps (
  game_id uuid not null references public.games(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  status text not null check (status in ('going','maybe','declined')) default 'going',
  created_at timestamptz not null default now(),
  primary key (game_id, user_id)
);

-- === VIEW: organizer contacts (publicly readable; exposes only organizer phones) ===
create or replace view public.organizer_contacts as
select
  g.id as game_id,
  p.id as organizer_id,
  p.display_name,
  p.phone as organizer_phone
from public.games g
join public.profiles p on p.id = g.organizer_id;
