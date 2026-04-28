# Database Schema

## Current Source Of Truth

This repo now has three schema artifacts that should agree with each other:

* `docs/supabase-schema-sql.txt` -> raw Supabase SQL export
* `docs/supabase-schema-kdglchjsogpinspiigyo.png` -> visual ERD snapshot
* `docs/supabase-schema.txt` -> plain-text summary for quick reference

This document is the human-readable summary of the current export. If the live
database changes, update those source artifacts first and then sync this file.

---

## Current Tables

### Core Data

* `sites`
* `jobs`
* `site_contacts`
* `job_contacts`
* `job_assignments`
* `notes`

### User Data

* `profiles`
* `user_pinned_jobs`
* `user_settings`

### Not Present In The Current Export

* No `schedule` table
* No read views such as `job_list_view` or `job_details_view`
* No storage blueprint table such as `storage_directories`
* No trigger or function definitions in the exported snapshot

---

## Relationship Map

* `jobs.site_id` -> `sites.id`
* `site_contacts.site_id` -> `sites.id`
* `job_contacts.job_id` -> `jobs.id`
* `job_assignments.job_id` -> `jobs.id`
* `job_assignments.user_id` -> `profiles.id`
* `notes.job_id` -> `jobs.id`
* `notes.author_user_id` -> `profiles.id`
* `user_pinned_jobs.user_id` -> `profiles.id`
* `user_pinned_jobs.job_id` -> `jobs.id`
* `user_settings.user_id` -> `profiles.id`

---

<<<<<<< ours
## Table Details

### `sites`
=======
## Example Seed Inserts (one row per table)

This script covers every table defined in the SQL section above (`profiles`, `sites`, `jobs`, `site_contacts`, `job_contacts`, `job_assignments`, `notes`, `user_pinned_jobs`).

```sql
-- Create one auth user in Supabase Auth first (Dashboard/Auth API).
-- Then use that UUID for profiles.id in the script below.

do $$
declare
  v_profile_id uuid := '11111111-1111-1111-1111-111111111111'; -- existing auth.users.id
  v_site_id uuid := gen_random_uuid();
  v_job_id uuid := gen_random_uuid();
begin
  insert into public.profiles (id, full_name, phone)
  values (v_profile_id, 'Alex Foreman', '555-0100')
  on conflict (id) do nothing;

  insert into public.sites (
    id, name, address_line_1, city, state, postal_code, latitude, longitude, notes
  )
  values (
    v_site_id, 'North Plant', '123 Main St', 'Phoenix', 'AZ', '85001', 33.448376, -112.074036, 'Primary facility'
  );

  insert into public.jobs (
    id, site_id, job_name, po_number, status, start_date, end_date, description
  )
  values (
    v_job_id, v_site_id, 'Boiler Retrofit', 'PO-2026-0042', 'Scheduled', date '2026-04-01', date '2026-04-05', 'Replace expansion valves'
  );

  insert into public.site_contacts (site_id, name, role, phone, email, is_primary, sort_order)
  values (v_site_id, 'Jamie SiteMgr', 'Site Manager', '555-0111', 'jamie@example.com', true, 0);

  insert into public.job_contacts (job_id, name, role, phone, email, is_primary, sort_order)
  values (v_job_id, 'Pat Inspector', 'Inspector', '555-0222', 'pat@example.com', true, 0);

  insert into public.job_assignments (job_id, user_id, work_date, status, role, notes)
  values (v_job_id, v_profile_id, date '2026-04-01', 'Assigned', 'Lead Tech', 'Bring lockout kit');

  insert into public.notes (job_id, author_user_id, content)
  values (v_job_id, v_profile_id, 'Initial walkthrough complete.');

  insert into public.user_pinned_jobs (user_id, job_id)
  values (v_profile_id, v_job_id)
  on conflict do nothing;

end
$$;
```

---

## Why This Schema

### Data entry order (important for forms)

* Yes: create/select a **site first**, then create the job.
* `jobs.site_id` is `not null` and references `sites(id)`, so a job cannot exist without a parent site.
* Practical UI flow:
  1. Create or select site.
  2. Create job under that site.
  3. Add job-level contacts, assignments, and notes.

### `sites` + `jobs`
>>>>>>> theirs

Columns:

* `id uuid primary key default gen_random_uuid()`
* `name text not null`
* `address_line_1 text not null`
* `address_line_2 text`
* `notes text`
* `updated_at timestamptz not null default timezone('utc', now())`

Notes:

* The current export does not include `city`, `state`, `postal_code`, `latitude`, `longitude`, or `created_at`.
* If the app still needs city/state display, either reintroduce those columns in SQL or derive them elsewhere.

### `jobs`

Columns:

* `id uuid primary key default gen_random_uuid()`
* `site_id uuid not null references public.sites(id)`
* `job_name text not null`
* `po_number text not null`
* `status text not null default 'Open'` with allowed values `Open`, `Scheduled`, `In Progress`, `Completed`, `On Hold`, `Cancelled`
* `start_date date`
* `end_date date`
* `description text`
* `created_at timestamptz not null default timezone('utc', now())`
* `updated_at timestamptz not null default timezone('utc', now())`

Notes:

* There is no separate `schedule` table in the current schema. The broad job window lives directly on `jobs.start_date` and `jobs.end_date`.

### `site_contacts`

Columns:

* `id uuid primary key default gen_random_uuid()`
* `site_id uuid not null references public.sites(id)`
* `name text not null`
* `role text`
* `phone text`
* `email text`
* `is_primary boolean not null default false`

Notes:

* The current export does not include `sort_order`, `created_at`, or `updated_at`.

### `job_contacts`

Columns:

* `id uuid primary key default gen_random_uuid()`
* `job_id uuid not null references public.jobs(id)`
* `name text not null`
* `role text`
* `phone text`
* `email text`
* `is_primary boolean not null default false`
* `sort_order integer not null default 0`
* `created_at timestamptz not null default timezone('utc', now())`
* `updated_at timestamptz not null default timezone('utc', now())`

### `job_assignments`

Columns:

* `id uuid primary key default gen_random_uuid()`
* `job_id uuid not null references public.jobs(id)`
* `user_id uuid not null references public.profiles(id)`
* `work_date date not null`

Notes:

* The current export does not include assignment `status`, `role`, `notes`, or timestamps.
* Daily staffing is represented only by the `(job_id, user_id, work_date)` relationship in the export shown here.

### `notes`

Columns:

* `id uuid primary key default gen_random_uuid()`
* `job_id uuid not null references public.jobs(id)`
* `author_user_id uuid references public.profiles(id)`
* `content text not null`
* `created_at timestamptz not null default timezone('utc', now())`
* `updated_at timestamptz not null default timezone('utc', now())`

### `profiles`

Columns:

* `id uuid primary key`
* `email text not null unique`
* `full_name text not null`
* `phone text`
* `avatar_url text`
* `is_active boolean not null default true`
* `created_at timestamptz not null default timezone('utc', now())`
* `updated_at timestamptz not null default timezone('utc', now())`

Notes:

* `profiles.id` must match the corresponding `auth.users(id)` for the same user.
* `profiles.email` must match the `auth.users.email` for the same user and is the primary invite gate.
* `is_active = false` disables access without deleting the account.
* A profile row must exist and be active for any login method (email/password or Google) to succeed.

### `user_pinned_jobs`

Columns:

* `user_id uuid not null references public.profiles(id)`
* `job_id uuid not null references public.jobs(id)`
* composite primary key: `(user_id, job_id)`

Notes:

* The current export does not include `pinned_at`.

### `user_settings`

Columns:

* `user_id uuid primary key references public.profiles(id)`
* `card_actions_side text not null default 'right'` with allowed values `left`, `right`
* `zoom numeric not null default 1.00` with allowed range `0.50` to `2.00`
* `schedule_view text not null default 'month'` with allowed values `month`, `week`, `day`
* `calculator_enabled boolean not null default true`
* `created_at timestamptz not null default timezone('utc', now())`
* `updated_at timestamptz not null default timezone('utc', now())`

---

## Flutter Mapping Notes

* The current mock job flow still assumes richer address data than the exported `sites` table provides.
* If the app should read directly from this schema, either expand `sites` again or adapt the UI model to the slimmer address shape.
* Since there are no read views in the export, Flutter integration will either query base tables directly or add views later as a deliberate backend step.
* Settings-related UI should map to `user_settings`, which now exists in the export and is no longer just a future placeholder.

---

## Seed Data Compatibility

`docs/seed_demo_data.sql` has been adjusted to match this schema snapshot:

* `sites` inserts only current columns
* `site_contacts` inserts no longer include `sort_order`
* `job_contacts` still include `sort_order` because that column exists
* `user_settings` seed rows are included

---

## Practical Guidance

Use `docs/supabase-schema-sql.txt` when you need exact DDL. Use this file when
you need the current model explained in plain English. If a future migration
adds views, triggers, auth foreign keys, or richer site address fields, update
all three schema artifacts together.
