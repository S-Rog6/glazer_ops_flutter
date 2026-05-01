-- =============================================================
-- GlazerOps Demo Seed Data
-- =============================================================
-- NOTE: The current exported schema does not enforce a foreign key
-- from public.profiles(id) to auth.users(id).
-- If you want profile rows to line up with real Supabase users,
-- replace the UUIDs in the profiles section with auth.users IDs.
-- If you are only seeding the current schema snapshot, these UUIDs
-- can stay as-is.
--
-- All other UUIDs are fixed so foreign keys resolve correctly.
-- Run this against your Supabase project using the SQL editor.
-- =============================================================

-- ---------------------------------------------------------------
-- SITES
-- ---------------------------------------------------------------
INSERT INTO public.sites (id, name, address_line_1, address_line_2, notes)
VALUES
  (
    'a1000000-0000-0000-0000-000000000001',
    'Downtown Office Tower',
    '123 N Michigan Ave',
    'Suite 100, Chicago, IL 60601',
    'High-rise; badge required for upper floors. Contact security 30 min before arrival.'
  ),
  (
    'a1000000-0000-0000-0000-000000000002',
    'Riverside Medical Center',
    '450 River Rd',
    'Chicago, IL 60607',
    'Hospital campus. Use delivery entrance on south side. No noise after 8 PM.'
  ),
  (
    'a1000000-0000-0000-0000-000000000003',
    'Westfield Shopping Mall',
    '789 Commerce Blvd',
    'Naperville, IL 60540',
    'Exterior work must be done before mall open (before 9 AM) or after close (after 9 PM).'
  ),
  (
    'a1000000-0000-0000-0000-000000000004',
    'Lincoln Park Apartments',
    '2200 N Lincoln Ave',
    'Chicago, IL 60614',
    'Residential building. Residents require 24 hr notice for unit access.'
  );

-- ---------------------------------------------------------------
-- SITE CONTACTS
-- ---------------------------------------------------------------
INSERT INTO public.site_contacts (id, site_id, name, role, phone, email, is_primary)
VALUES
  -- Downtown Office Tower
  (
    'b1000000-0000-0000-0000-000000000001',
    'a1000000-0000-0000-0000-000000000001',
    'Larry Hennessy', 'Facilities Manager',
    '312-555-0101', 'l.hennessy@downtowntower.com',
    true
  ),
  (
    'b1000000-0000-0000-0000-000000000002',
    'a1000000-0000-0000-0000-000000000001',
    'Carol Vance', 'Security Desk',
    '312-555-0102', NULL,
    false
  ),
  -- Riverside Medical Center
  (
    'b1000000-0000-0000-0000-000000000003',
    'a1000000-0000-0000-0000-000000000002',
    'Marcus Webb', 'Plant Operations',
    '312-555-0201', 'm.webb@riversidemedical.org',
    true
  ),
  -- Westfield Shopping Mall
  (
    'b1000000-0000-0000-0000-000000000004',
    'a1000000-0000-0000-0000-000000000003',
    'Diane Torres', 'Mall Operations',
    '630-555-0301', 'dtorres@westfieldmall.com',
    true
  ),
  (
    'b1000000-0000-0000-0000-000000000005',
    'a1000000-0000-0000-0000-000000000003',
    'Pete Olson', 'Maintenance Supervisor',
    '630-555-0302', NULL,
    false
  ),
  -- Lincoln Park Apartments
  (
    'b1000000-0000-0000-0000-000000000006',
    'a1000000-0000-0000-0000-000000000004',
    'Sandra Kim', 'Property Manager',
    '773-555-0401', 's.kim@lpkapts.com',
    true
  );

-- ---------------------------------------------------------------
-- JOBS
-- ---------------------------------------------------------------
INSERT INTO public.jobs (id, site_id, job_name, po_number, status, start_date, end_date, description)
VALUES
  (
    'c1000000-0000-0000-0000-000000000001',
    'a1000000-0000-0000-0000-000000000001',
    'Storefront Glass Installation',
    'PO-2026-0041',
    'In Progress',
    '2026-03-17', '2026-03-28',
    'Install new tempered storefront glass panels on floors 1–3. Includes aluminum framing and sealant work.'
  ),
  (
    'c1000000-0000-0000-0000-000000000002',
    'a1000000-0000-0000-0000-000000000001',
    'Curtain Wall Repair – West Facade',
    'PO-2026-0042',
    'Scheduled',
    '2026-04-07', '2026-04-18',
    'Replace cracked IGU units on west curtain wall, floors 8–12. Scaffold required; tenant notification needed.'
  ),
  (
    'c1000000-0000-0000-0000-000000000003',
    'a1000000-0000-0000-0000-000000000002',
    'Emergency Window Replacement – ER Wing',
    'PO-2026-0043',
    'In Progress',
    '2026-03-20', '2026-03-24',
    'Three impact-broken windows in ER wing requiring immediate laminated glass replacement. Infection control protocol required.'
  ),
  (
    'c1000000-0000-0000-0000-000000000004',
    'a1000000-0000-0000-0000-000000000003',
    'Skylight Glazing – Food Court',
    'PO-2026-0038',
    'Open',
    '2026-04-14', '2026-04-25',
    'Remove and replace 22 skylight panels with new low-e laminated glass. Work restricted to off-hours.'
  ),
  (
    'c1000000-0000-0000-0000-000000000005',
    'a1000000-0000-0000-0000-000000000004',
    'Lobby Entrance Glass Panel Replacement',
    'PO-2026-0039',
    'Completed',
    '2026-03-03', '2026-03-07',
    'Replaced damaged lobby entrance glass panels and re-sealed door frames.'
  ),
  (
    'c1000000-0000-0000-0000-000000000006',
    'a1000000-0000-0000-0000-000000000002',
    'Patient Room Window Upgrades',
    'PO-2026-0044',
    'On Hold',
    '2026-05-05', '2026-05-30',
    'Upgrade 40 patient room windows to acoustic insulating glass. On hold pending hospital board approval.'
  );

-- ---------------------------------------------------------------
-- JOB CONTACTS
-- ---------------------------------------------------------------
INSERT INTO public.job_contacts (id, job_id, name, role, phone, email, is_primary, sort_order)
VALUES
  -- Storefront Glass Installation
  (
    'd1000000-0000-0000-0000-000000000001',
    'c1000000-0000-0000-0000-000000000001',
    'Larry Hennessy', 'Facilities Manager',
    '312-555-0101', 'l.hennessy@downtowntower.com',
    true, 0
  ),
  -- Curtain Wall Repair
  (
    'd1000000-0000-0000-0000-000000000002',
    'c1000000-0000-0000-0000-000000000002',
    'Larry Hennessy', 'Facilities Manager',
    '312-555-0101', 'l.hennessy@downtowntower.com',
    true, 0
  ),
  (
    'd1000000-0000-0000-0000-000000000003',
    'c1000000-0000-0000-0000-000000000002',
    'Rob Stafford', 'GC Project Manager',
    '312-555-9901', 'rstafford@staffordconstructors.com',
    false, 1
  ),
  -- ER Window Replacement
  (
    'd1000000-0000-0000-0000-000000000004',
    'c1000000-0000-0000-0000-000000000003',
    'Marcus Webb', 'Plant Operations',
    '312-555-0201', 'm.webb@riversidemedical.org',
    true, 0
  ),
  -- Skylight Glazing
  (
    'd1000000-0000-0000-0000-000000000005',
    'c1000000-0000-0000-0000-000000000004',
    'Diane Torres', 'Mall Operations',
    '630-555-0301', 'dtorres@westfieldmall.com',
    true, 0
  ),
  -- Lobby Glass Replacement
  (
    'd1000000-0000-0000-0000-000000000006',
    'c1000000-0000-0000-0000-000000000005',
    'Sandra Kim', 'Property Manager',
    '773-555-0401', 's.kim@lpkapts.com',
    true, 0
  ),
  -- Patient Room Upgrades
  (
    'd1000000-0000-0000-0000-000000000007',
    'c1000000-0000-0000-0000-000000000006',
    'Marcus Webb', 'Plant Operations',
    '312-555-0201', 'm.webb@riversidemedical.org',
    true, 0
  );

-- ---------------------------------------------------------------
-- PROFILES
-- ---------------------------------------------------------------
-- IMPORTANT: Replace these UUIDs with the actual user IDs from
-- your Supabase Auth > Users table. Create those users first
-- (e.g., via Supabase dashboard or sign-up flow), then update
-- these IDs to match. The rest of the seed data references these
-- same UUIDs for assignments and notes, so update them there too.
-- Suggested Auth users for this seed:
--   Scott Rogers  | scott.rogers66.sr@gmail.com | 813-317-9705
--   Mike Deluca   | mike.deluca@example.com     | 312-555-1002
--   Chris Paulson | chris.paulson@example.com   | 312-555-1003
--   Tony Markov   | tony.markov@example.com     | 312-555-1004
-- ---------------------------------------------------------------
INSERT INTO public.profiles (id, email, full_name, phone, is_active)
VALUES
  (
    'e1000000-0000-0000-0000-000000000001',
    'scott.rogers@example.com',
    'Scott Rogers',
    '813-317-9705',
    true
  ),
  (
    'e1000000-0000-0000-0000-000000000002',
    'mike.deluca@example.com',
    'Mike Deluca',
    '312-555-1002',
    true
  ),
  (
    'e1000000-0000-0000-0000-000000000003',
    'chris.paulson@example.com',
    'Chris Paulson',
    '312-555-1003',
    true
  ),
  (
    'e1000000-0000-0000-0000-000000000004',
    'tony.markov@example.com',
    'Tony Markov',
    '312-555-1004',
    true
  );

-- ---------------------------------------------------------------
-- USER SETTINGS
-- ---------------------------------------------------------------
INSERT INTO public.user_settings (user_id, card_actions_side, zoom, schedule_view, calculator_enabled)
VALUES
  ('e1000000-0000-0000-0000-000000000001', 'right', 1.00, 'month', true),
  ('e1000000-0000-0000-0000-000000000002', 'right', 1.00, 'week', true),
  ('e1000000-0000-0000-0000-000000000003', 'left', 1.10, 'day', true),
  ('e1000000-0000-0000-0000-000000000004', 'right', 0.90, 'month', false);

-- ---------------------------------------------------------------
-- JOB ASSIGNMENTS
-- ---------------------------------------------------------------
INSERT INTO public.job_assignments (id, job_id, user_id, work_date)
VALUES
  -- Storefront Glass Installation (In Progress)
  (
    'f1000000-0000-0000-0000-000000000001',
    'c1000000-0000-0000-0000-000000000001',
    'e1000000-0000-0000-0000-000000000001',
    '2026-03-22'
  ),
  (
    'f1000000-0000-0000-0000-000000000002',
    'c1000000-0000-0000-0000-000000000001',
    'e1000000-0000-0000-0000-000000000002',
    '2026-03-22'
  ),
  (
    'f1000000-0000-0000-0000-000000000003',
    'c1000000-0000-0000-0000-000000000001',
    'e1000000-0000-0000-0000-000000000001',
    '2026-03-24'
  ),
  -- Emergency ER Window Replacement
  (
    'f1000000-0000-0000-0000-000000000004',
    'c1000000-0000-0000-0000-000000000003',
    'e1000000-0000-0000-0000-000000000003',
    '2026-03-20'
  ),
  (
    'f1000000-0000-0000-0000-000000000005',
    'c1000000-0000-0000-0000-000000000003',
    'e1000000-0000-0000-0000-000000000004',
    '2026-03-20'
  ),
  (
    'f1000000-0000-0000-0000-000000000006',
    'c1000000-0000-0000-0000-000000000003',
    'e1000000-0000-0000-0000-000000000003',
    '2026-03-22'
  ),
  -- Curtain Wall Repair (Scheduled)
  (
    'f1000000-0000-0000-0000-000000000007',
    'c1000000-0000-0000-0000-000000000002',
    'e1000000-0000-0000-0000-000000000001',
    '2026-04-07'
  ),
  (
    'f1000000-0000-0000-0000-000000000008',
    'c1000000-0000-0000-0000-000000000002',
    'e1000000-0000-0000-0000-000000000002',
    '2026-04-07'
  ),
  -- Lobby Glass Replacement (Completed)
  (
    'f1000000-0000-0000-0000-000000000009',
    'c1000000-0000-0000-0000-000000000005',
    'e1000000-0000-0000-0000-000000000002',
    '2026-03-03'
  ),
  (
    'f1000000-0000-0000-0000-000000000010',
    'c1000000-0000-0000-0000-000000000005',
    'e1000000-0000-0000-0000-000000000004',
    '2026-03-03'
  );

-- ---------------------------------------------------------------
-- NOTES
-- ---------------------------------------------------------------
INSERT INTO public.notes (id, job_id, author_user_id, content, created_at)
VALUES
  (
    'g1000000-0000-0000-0000-000000000001',
    'c1000000-0000-0000-0000-000000000001',
    'e1000000-0000-0000-0000-000000000001',
    'Framing on floors 1 and 2 complete. Floor 3 framing starts tomorrow. Glass delivery confirmed for Monday.',
    '2026-03-22'

  ),
  (
    'g1000000-0000-0000-0000-000000000002',
    'c1000000-0000-0000-0000-000000000001',
    'e1000000-0000-0000-0000-000000000002',
    'Discovered existing sill plates on floor 2 are out of level. May need shimming — flagged to Scott.',
    '2026-03-22'
  ),
  (
    'g1000000-0000-0000-0000-000000000003',
    'c1000000-0000-0000-0000-000000000003',
    'e1000000-0000-0000-0000-000000000003',
    'Window #1 replaced and sealed. Passed infection control walk-through. Two remaining windows tomorrow.',
    '2026-03-23'
  ),
  (
    'g1000000-0000-0000-0000-000000000004',
    'c1000000-0000-0000-0000-000000000003',
    'e1000000-0000-0000-0000-000000000004',
    'Hospital provided PPE. Work area cordoned off per their protocol. No issues.',
    '2026-03-23'
  ),
  (
    'g1000000-0000-0000-0000-000000000005',
    'c1000000-0000-0000-0000-000000000002',
    'e1000000-0000-0000-0000-000000000001',
    'Scaffold permit submitted to city. Waiting on approval before we can lock in the crew schedule.',
    '2026-03-24'
  ),
  (
    'g1000000-0000-0000-0000-000000000006',
    'c1000000-0000-0000-0000-000000000005',
    'e1000000-0000-0000-0000-000000000002',
    'Job complete. All panels installed and sealed. Final walk-through with Sandra Kim — she signed off.',
    '2026-03-24'
  ),
  (
    'g1000000-0000-0000-0000-000000000007',
    'c1000000-0000-0000-0000-000000000006',
    'e1000000-0000-0000-0000-000000000001',
    'Job on hold. Hospital board vote pushed to May. Will reschedule crew once we get the green light from Marcus.',
    '2026-03-24'
  );

-- ---------------------------------------------------------------
-- USER PINNED JOBS
-- ---------------------------------------------------------------
INSERT INTO public.user_pinned_jobs (user_id, job_id)
VALUES
  -- Scott pins the active and upcoming big jobs
  ('e1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001'),
  ('e1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000002'),
  ('e1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000003'),
  -- Mike pins his current job
  ('e1000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000001'),
  -- Chris pins the ER job
  ('e1000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000003');
