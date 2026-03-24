# Database Schema

## Decision Summary

* Tables hold source-of-truth data.
* Views shape data for the Flutter UI.
* Site contacts stay normalized in `site_contacts`; they are not copied into `job_contacts`.
* Daily crew tracking lives in `job_assignments`; scheduled work dates live in the `schedule` table as one row per date or date range.
* User pins are stored in `user_pinned_jobs`; they are not derived in the UI.
* `auth.users` is the correct bootstrap hook for app-owned user defaults such as `profiles`, future `user_settings`, and storage directory blueprints.

---

## Final Table List

### Supabase Auth

* `auth.users` -> authentication identity managed by Supabase
* `profiles` -> app-facing user record used for display names, phone numbers, and assignment joins

### Core App Tables

* `sites`
* `jobs`
* `schedule`
* `site_contacts`
* `job_contacts`
* `job_assignments`
* `notes`
* `user_pinned_jobs`

### Support Tables

* `storage_directories` -> application-owned blueprint of expected Supabase Storage prefixes for new users and jobs

### Read Views

* `job_list_view`
* `job_details_view`
* `job_all_contacts_view`
* `job_user_calendar_view`

---

## Recommended SQL

```sql
create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  phone text,
  avatar_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create or replace function public.bootstrap_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (
    new.id,
    coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''),
      nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
      nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
      'New User'
    )
  )
  on conflict (id) do nothing;

  -- Future per-user defaults belong in this same bootstrap step.
  -- Example:
  -- insert into public.user_settings (user_id, theme_mode, notifications_enabled)
  -- values (new.id, 'system', true)
  -- on conflict (user_id) do nothing;

  return new;
end;
$$;

create table if not exists public.sites (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address_line_1 text not null,
  address_line_2 text,
  city text not null,
  state text not null,
  postal_code text,
  latitude numeric(9, 6),
  longitude numeric(9, 6),
  notes text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references public.sites(id) on delete restrict,
  job_name text not null,
  po_number text not null,
  status text not null default 'Open'
    check (status in ('Open', 'Scheduled', 'In Progress', 'Completed', 'On Hold', 'Cancelled')),
  start_date date,
  end_date date,
  description text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.schedule (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.jobs(id) on delete cascade,
  start_date date not null,
  end_date date,
  notes text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.site_contacts (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references public.sites(id) on delete cascade,
  name text not null,
  role text,
  phone text,
  email text,
  is_primary boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.job_contacts (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.jobs(id) on delete cascade,
  name text not null,
  role text,
  phone text,
  email text,
  is_primary boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.job_assignments (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.jobs(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  work_date date not null,
  status text not null default 'Assigned'
    check (status in ('Assigned', 'Confirmed', 'Completed', 'Cancelled')),
  role text,
  notes text,
  created_at timestamptz not null default timezone('utc', now()),
  unique (job_id, user_id, work_date)
);

create table if not exists public.notes (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.jobs(id) on delete cascade,
  author_user_id uuid references public.profiles(id) on delete set null,
  content text not null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.user_pinned_jobs (
  user_id uuid not null references public.profiles(id) on delete cascade,
  job_id uuid not null references public.jobs(id) on delete cascade,
  pinned_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, job_id)
);

create index if not exists schedule_job_id_idx
  on public.schedule (job_id);

create index if not exists schedule_start_date_idx
  on public.schedule (start_date);

create index if not exists jobs_site_id_idx
  on public.jobs (site_id);

create index if not exists jobs_status_idx
  on public.jobs (status);

create index if not exists jobs_start_date_idx
  on public.jobs (start_date);

create index if not exists site_contacts_site_id_idx
  on public.site_contacts (site_id);

create index if not exists job_contacts_job_id_idx
  on public.job_contacts (job_id);

create index if not exists job_assignments_job_date_idx
  on public.job_assignments (job_id, work_date);

create index if not exists job_assignments_user_date_idx
  on public.job_assignments (user_id, work_date);

create index if not exists notes_job_created_at_idx
  on public.notes (job_id, created_at desc);

create index if not exists user_pinned_jobs_job_id_idx
  on public.user_pinned_jobs (job_id);

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.bootstrap_new_user();

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists set_sites_updated_at on public.sites;
create trigger set_sites_updated_at
before update on public.sites
for each row execute function public.set_updated_at();

drop trigger if exists set_schedule_updated_at on public.schedule;
create trigger set_schedule_updated_at
before update on public.schedule
for each row execute function public.set_updated_at();

drop trigger if exists set_jobs_updated_at on public.jobs;
create trigger set_jobs_updated_at
before update on public.jobs
for each row execute function public.set_updated_at();

drop trigger if exists set_site_contacts_updated_at on public.site_contacts;
create trigger set_site_contacts_updated_at
before update on public.site_contacts
for each row execute function public.set_updated_at();

drop trigger if exists set_job_contacts_updated_at on public.job_contacts;
create trigger set_job_contacts_updated_at
before update on public.job_contacts
for each row execute function public.set_updated_at();

drop trigger if exists set_notes_updated_at on public.notes;
create trigger set_notes_updated_at
before update on public.notes
for each row execute function public.set_updated_at();

create or replace view public.job_list_view as
select
  j.id,
  j.job_name,
  j.po_number,
  j.site_id,
  s.name as site_name,
  concat_ws(
    ', ',
    s.address_line_1,
    nullif(
      trim(concat_ws(' ', s.city, s.state, s.postal_code)),
      ''
    )
  ) as site_summary,
  j.status,
  j.start_date,
  j.end_date,
  j.created_at,
  j.updated_at
from public.jobs j
join public.sites s on s.id = j.site_id;

create or replace view public.job_details_view as
select
  j.id,
  j.job_name,
  j.po_number,
  j.status,
  j.start_date,
  j.end_date,
  j.description,
  j.created_at,
  j.updated_at,
  s.id as site_id,
  s.name as site_name,
  s.address_line_1,
  s.address_line_2,
  s.city,
  s.state,
  s.postal_code,
  s.latitude,
  s.longitude,
  s.notes as site_notes
from public.jobs j
join public.sites s on s.id = j.site_id;

create or replace view public.job_all_contacts_view as
select
  j.id as job_id,
  j.site_id,
  sc.id as contact_id,
  'site'::text as source,
  sc.name,
  sc.role,
  sc.phone,
  sc.email,
  sc.is_primary,
  sc.sort_order,
  sc.created_at,
  sc.updated_at
from public.jobs j
join public.site_contacts sc on sc.site_id = j.site_id

union all

select
  jc.job_id,
  j.site_id,
  jc.id as contact_id,
  'job'::text as source,
  jc.name,
  jc.role,
  jc.phone,
  jc.email,
  jc.is_primary,
  jc.sort_order,
  jc.created_at,
  jc.updated_at
from public.job_contacts jc
join public.jobs j on j.id = jc.job_id;

create or replace view public.job_user_calendar_view as
select
  ja.job_id,
  j.job_name,
  j.site_id,
  s.name as site_name,
  ja.user_id,
  p.full_name as user_name,
  ja.work_date,
  ja.status,
  ja.role,
  ja.notes
from public.job_assignments ja
join public.jobs j on j.id = ja.job_id
join public.sites s on s.id = j.site_id
join public.profiles p on p.id = ja.user_id;
```

---

## Why This Schema

### `sites` + `jobs`

* A site can host multiple jobs over time.
* Job records keep `job_name`, `po_number`, `status`, and date range fields that already match the current Flutter naming direction.
* The overall schedule window is managed through the `schedule` table, not stored as a single date range on the job record.

### `site_contacts` + `job_contacts`

* `site_contacts` holds shared site-level contacts.
* `job_contacts` holds job-specific additions or overrides.
* `job_all_contacts_view` is the read-side union for the UI, with a `source` field so Flutter can label inherited vs job-specific contacts if needed.

### `schedule`

* One row means one scheduled date or date range for a job.
* A job can have many `schedule` rows, covering discrete work days or multi-day periods.
* `start_date` is required; `end_date` is optional and used when the scheduled block spans more than one day.
* This is the source of truth for when a job is expected to be worked, independently of which crew members are assigned.

### `job_assignments`

* One row means one user assigned to one job on one date.
* This is the source of truth for any calendar, staffing, or "who worked where today" feature.
* The `unique (job_id, user_id, work_date)` constraint prevents duplicate daily assignments.

### `notes`

* Notes are stored directly against the job.
* `author_user_id` is nullable so old notes can survive if a user record is removed.

### `user_pinned_jobs`

* Pins are user-specific state and belong in storage, not in the widget tree.
* Composite primary key keeps each user/job pair unique without a surrogate id.

### `profiles` bootstrap

* `profiles` is the app-owned companion to `auth.users`.
* The `auth.users` insert trigger is where profile creation belongs.
* The same trigger is also where future user defaults should be created, such as settings, notification preferences, or onboarding flags.

---

## Deliberate Exclusions

* No automatic copying from `site_contacts` into `job_contacts`.
  If the UI needs a combined list, query `job_all_contacts_view`.
* No `job_attachments` table yet.
  Add it when the upload flow and Supabase Storage structure are defined for real, not while it is still a placeholder in the UI.

---

## Flutter Mapping Notes

* The existing `Job` model already lines up with `jobs` keys like `job_name`, `po_number`, `site_id`, `status`, and `created_at`.
* Keep `jobs.status` display-friendly for now (`Open`, `Scheduled`, `In Progress`, `Completed`) so it drops into the current widgets cleanly.
* `job_list_view` is the cleanest read target for cards and list pages.
* `job_details_view` plus `job_all_contacts_view` covers the job details screen without heavy UI joins.
* `job_user_calendar_view` should back any future per-job crew calendar or per-user assignment history UI.

---

## Auth/User Bootstrap

* `auth.users` is the right lifecycle hook for app-owned user setup.
* Create the `profiles` row there.
* If you add `user_settings`, notification prefs, onboarding flags, or other defaults, insert them in the same trigger with `on conflict do nothing`.
* Keep the trigger idempotent so replays, retries, and imports stay safe.

---

## Storage Directory Automation

This project also includes a recommended trigger pattern for bootstrapping the
expected storage paths for new users and new jobs. The SQL lives in
`docs/supabase-schema-sql.txt`.

### Important Supabase behavior

Supabase Storage treats folders as path prefixes, not first-class directories.
That means you normally do not need to create folders first. Uploading a file
such as `jobs/<job_id>/photos/image-001.jpg` is enough for that folder path to
exist logically.

Because of that, the schema uses an application-owned table called
`public.storage_directories` instead of writing directly into `storage.objects`.
This is safer, keeps your schema compatible with Supabase updates, and gives
you a clean place to define the expected folder layout.

### Trigger behavior

#### On `auth.users` insert

The trigger inserts these rows into `public.storage_directories`:

* `users/<user_id>/profile/`
* `users/<user_id>/documents/`
* `users/<user_id>/photos/`

This is also the right place to create app-owned defaults such as `profiles`
and future `user_settings` rows. If you want one canonical user bootstrap path,
fold those inserts into the same `auth.users` trigger function.

#### On `public.jobs` insert

The trigger inserts these rows into `public.storage_directories`:

* `jobs/<job_id>/contracts/`
* `jobs/<job_id>/photos/`
* `jobs/<job_id>/shop-drawings/`
* `jobs/<job_id>/daily-reports/`

### Placeholder support

The table exposes a generated `placeholder_object` column. If you want empty
folders to show up in your own admin UI, your app or a background worker can
upload a zero-byte file to that path, for example:

* `users/<user_id>/profile/.keep`
* `jobs/<job_id>/photos/.keep`

### Suggested follow-up

If you want the app to fully automate the visible folder creation step, add a
small backend job or Edge Function that watches `public.storage_directories` and
uploads the `.keep` objects with a service role key.
