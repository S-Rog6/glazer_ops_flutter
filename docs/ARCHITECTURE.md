# Architecture Overview

## High-Level Flow

UI (Flutter)
   ↓
State Management
   ↓
API Layer
   ↓
Backend (Supabase / TBD)
   ↓
Database (Postgres)

---

## App Layers

### 1. UI Layer

* Screens
* Widgets
* Layouts
* Routes and navigation shell

### 2. State Layer

* Holds current data
* Controls UI updates
* Keeps logic out of UI

(Provider / Riverpod / Bloc — TBD)

---

### 3. Data Layer

* API calls
* Local caching
* Models

---

## Current Implementation Snapshot

* Entry point is `main.dart` -> `GlazerOpsApp` in `app.dart`
* Routing is centralized in `routes/app_router.dart`
* Shared UI scaffolding lives in `core/widgets`
* Feature code is organized under `features/*`
* Jobs model currently follows backend keys: `job_name`, `po_number`, `site_id`

---

## Offline Strategy (Planned)

* Local cache of jobs
* Sync when online
* Conflict resolution later

---

## Database Direction

### Source-of-Truth Tables

* `profiles` (`auth.users` companion)
* `sites`
* `jobs`
* `site_contacts`
* `job_contacts`
* `job_assignments`
* `notes`
* `user_pinned_jobs`

### Read-Focused Views

* `job_list_view`
* `job_details_view`
* `job_all_contacts_view`
* `job_user_calendar_view`

### Important Modeling Calls

* Backend views should provide ready-to-display data.
* UI should not perform heavy joins.
* There is no first-pass `schedules` table.
  Overall date range lives on `jobs`; per-user, per-day staffing lives in `job_assignments`.
* Site contacts stay normalized at the site level.
  The UI gets the combined list through `job_all_contacts_view`.

Full table and view definitions live in [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md).

---

## Future Additions

* Auth
* Multi-user sync
* File uploads
* Notifications

---

## What We Are NOT Doing Yet

* Complex permissions
* Real-time updates
* Fancy animations
