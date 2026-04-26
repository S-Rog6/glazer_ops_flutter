# Architecture Overview

## High-Level Flow

UI (Flutter)
   ↓
Controller and State Layer
   ↓
API Layer
   ↓
Backend (Supabase)
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

Current approach:

* Inherited scopes for dependency access
* ChangeNotifier controllers for feature state
* Repository interfaces for data access boundaries

---

### 3. Data Layer

* API calls
* Local caching
* Models
* Repository boundary for data reads and connection diagnostics

---

## Current Implementation Snapshot

* Entry point is `main.dart` -> `GlazerOpsApp` in `app.dart`
* Routing is centralized in `routes/app_router.dart`
* Shared UI scaffolding lives in `core/widgets`
* Feature code is organized under `features/*`
* Jobs model currently follows backend keys: `job_name`, `po_number`, `site_id`
* Supabase startup is guarded: missing or broken config no longer crashes app startup, but jobs screens now surface repository errors instead of serving mock data
* Settings now exposes repository-driven connection testing and manual data refresh diagnostics
* Auth state listener is wired in app startup, but login UI flow is still placeholder and splash still bypasses login
* Write paths for jobs/notes/assignments/attachments are not fully implemented yet

---

## Offline Strategy (Planned)

* Local cache of jobs
* Sync when online
* Conflict resolution later

---

## Database Direction

### Source-of-Truth Tables

* `profiles`
* `sites`
* `jobs`
* `site_contacts`
* `job_contacts`
* `job_assignments`
* `notes`
* `user_pinned_jobs`
* `user_settings`

### Current Backend Shape

* The current export is table-only. No read views are defined yet.
* Job date windows live on `jobs.start_date` and `jobs.end_date`.
* Per-user daily staffing lives in `job_assignments.work_date`.
* `user_settings` is a real table in the current schema, not just a future note.

### Important Modeling Calls

* The current schema is slimmer than the earlier design notes.
* If backend views are added later, treat them as optional read helpers rather than current dependencies.
* Site contacts stay normalized at the site level; job-specific contacts live in `job_contacts`.
* The app still carries richer location fields in mock models than the exported `sites` table currently stores.

Full current schema details live in [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md).

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

---

## Pre-Testing Completion Priorities

1. Replace auth placeholder with real session-based login and logout
2. Complete core write flows (jobs, notes, assignments)
3. Replace placeholder feature pages (notes, contacts) with repository-backed implementations
4. Add attachment upload and retrieval
5. Add regression tests for critical controller and repository logic
