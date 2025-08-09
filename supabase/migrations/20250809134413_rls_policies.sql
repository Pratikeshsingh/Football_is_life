-- Enable RLS
alter table public.profiles enable row level security;
alter table public.games enable row level security;
alter table public.rsvps enable row level security;

-- PROFILES
-- Users can read/update ONLY their own profile
create policy "profiles self read"
on public.profiles for select
using (auth.uid() = id);

create policy "profiles self update"
on public.profiles for update
using (auth.uid() = id);

-- Organizers can read all profiles (so organizers see phone numbers)
create policy "organizers read all profiles"
on public.profiles for select
using (
  exists (
    select 1 from public.profiles me
    where me.id = auth.uid() and me.role = 'organizer'
  )
);

-- GAMES
-- Everyone authenticated can read games
create policy "games read"
on public.games for select
using (true);

-- Only organizers can create games
create policy "games insert organizers"
on public.games for insert
with check (
  exists (
    select 1 from public.profiles me
    where me.id = auth.uid() and me.role = 'organizer'
  )
);

-- Organizers can update their own games
create policy "games update owner"
on public.games for update
using (auth.uid() = organizer_id);

-- RSVPS
-- Authenticated users can read RSVPs (for counts/attendee lists)
create policy "rsvps read"
on public.rsvps for select
using (true);

-- Users can create/update their own RSVP
create policy "rsvps upsert self"
on public.rsvps for insert
with check (auth.uid() = user_id);

create policy "rsvps update self"
on public.rsvps for update
using (auth.uid() = user_id);
