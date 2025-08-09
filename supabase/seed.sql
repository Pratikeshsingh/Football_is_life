-- Sample grounds
insert into public.grounds (id, name, maps_url, capacity) values
  (gen_random_uuid(), 'Small Pitch', 'https://maps.example/small', 14),
  (gen_random_uuid(), 'Cage Court', 'https://maps.example/cage', 10)
on conflict do nothing;

-- Create a placeholder organizer profile with a fixed UUID for demo.
-- After you sign in locally, you can UPDATE its id to your auth.uid().
insert into public.profiles (id, display_name, phone, role)
values ('00000000-0000-0000-0000-000000000001', 'Organizer One', '+31612345678', 'organizer')
on conflict (id) do nothing;

-- Two upcoming public games owned by the placeholder organizer
insert into public.games (title, start_time, location, min, cap, state, organizer_id)
select 'Monday Night Football', now() + interval '2 days', 'Small Pitch', 8, 14, 'public',
       '00000000-0000-0000-0000-000000000001'
where not exists (select 1 from public.games where title='Monday Night Football')
union all
select 'Thursday Pickup', now() + interval '5 days', 'Cage Court', 8, 12, 'public',
       '00000000-0000-0000-0000-000000000001'
where not exists (select 1 from public.games where title='Thursday Pickup');
