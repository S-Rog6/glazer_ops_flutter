# Flutter App

## Run the App

flutter pub get
flutter run
flutter analyze

---

## Folder Structure (Current)

/lib
  main.dart                  -> app entry point
  app.dart                   -> MaterialApp setup
  /core
    /constants               -> app colors and size tokens
    /theme                   -> app theme setup
    /widgets                 -> shared shell/nav/drawer widgets
    /utils                   -> responsive helpers
  /features
    /auth
    /contacts
    /dashboard
    /jobs                    -> pages, widgets, models
    /notes
    /schedule
    /settings
  /routes                    -> route names + route generation

---

## First Targets

* Keep the app booting through centralized routes
* Build a clickable jobs flow backed by Supabase
* Replace placeholder pages with real feature UI

---

## Notes

Start simple:

* Hardcode data first
* No API calls yet
* Keep business logic out of UI widgets
* When backend work starts, treat `supabase-schema-sql.txt` as the exact DDL source and `DATABASE_SCHEMA.md` as the readable summary

---

## Supabase Setup

The app can now read jobs and job details from Supabase when these
`--dart-define` values are provided at launch:

* `SUPABASE_URL`
* `SUPABASE_ANON_KEY`
* `SUPABASE_PROFILE_ID` -> optional override for user-scoped reads such as `Pinned` and `My jobs only`; if omitted, the app falls back to the signed-in Supabase user ID when auth is available

The app also accepts these existing Next-style names:

* `NEXT_PUBLIC_SUPABASE_URL`
* `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY`
* `NEXT_PUBLIC_SUPABASE_PROFILE_ID`

Example:

```bash
flutter run `
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY `
  --dart-define=SUPABASE_PROFILE_ID=YOUR_PROFILES_ID
```

Equivalent with `NEXT_PUBLIC_*` names:

```bash
flutter run `
  --dart-define=NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY=YOUR_PUBLISHABLE_KEY `
  --dart-define=NEXT_PUBLIC_SUPABASE_PROFILE_ID=YOUR_PROFILES_ID
```

Notes:

* If `SUPABASE_URL` and `SUPABASE_ANON_KEY` are omitted, the app stays up but jobs-related screens report that live Supabase access is unavailable
* If Supabase initialization fails at startup, the app preserves the bootstrap error and surfaces it through the repository instead of silently swapping in demo data
* The live job list, job details, and calendar views read from `jobs` plus related `sites`, contacts, assignments, and notes tables
* The current details UI was aligned to the actual schema, which stores address data as `address_line_1` and `address_line_2`
* `job_assignments` in the current schema does not include assignment role/status fields, so the UI derives a simple display status from the parent job status
* Auth login is still placeholder UI; until end-to-end auth is wired, `SUPABASE_PROFILE_ID` remains the safest way to align user-scoped reads with `profiles.id`

### Connection Diagnostics

The Settings page now includes:

* `Test Supabase Connection` -> verifies the configured data source can execute the read path the app depends on
* `Refresh Data` -> reloads the jobs snapshot through the same repository/controller path used by the dashboard and jobs screens

The connection card shows:

* whether Supabase is configured
* whether the app is currently using live Supabase reads or an unavailable Supabase state
* the project host
* the configured profile ID in masked form
* bootstrap status and the current availability reason
* the last successful data refresh
* the last connection test result

### Error Handling

Current connection-related behavior:

* Missing config -> app stays up, but jobs screens report that Supabase is not configured and the connection test explains what is missing
* Initialization failure -> app stays up, but jobs screens and Settings preserve the bootstrap error instead of substituting demo data
* PostgREST query failure -> repository errors are normalized into clearer messages, including RLS guidance when the failure looks policy-related
* Refresh failures -> dashboard/jobs pages and the Settings page surface the repository error instead of failing silently
* Unexpected connection-test errors -> Settings converts them into a visible failed test result instead of leaving the UI in a loading state

---

## Debug Tips

If something breaks:

* Hot restart (not just reload)
* Check console logs
* Simplify before fixing

---

## Goal

Get to a clickable prototype ASAP.
