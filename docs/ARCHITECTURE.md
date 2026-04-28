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

### User Preferences / Settings Storage

User preferences are persisted in the `user_settings` Supabase table (one row per user, keyed by `user_id`).

The data layer follows the same Repository → Controller pattern used by jobs:

| Layer | Class | Path |
|---|---|---|
| Model | `UserSettings` | `features/settings/models/user_settings.dart` |
| Interface | `UserSettingsRepository` | `features/settings/data/user_settings_repository.dart` |
| Live (Supabase) | `SupabaseUserSettingsRepository` | `features/settings/data/supabase_user_settings_repository.dart` |
| Mock (no Supabase) | `MockUserSettingsRepository` | `features/settings/data/mock_user_settings_repository.dart` |
| Fallback (unavailable) | `UnavailableUserSettingsRepository` | `features/settings/data/unavailable_user_settings_repository.dart` |
| Controller | `UserSettingsController` | `features/settings/controllers/user_settings_controller.dart` |

`GlazerOpsApp` (`app.dart`) selects the correct repository implementation at startup (same logic as jobs) and exposes both the repository and controller via `InheritedWidget` scopes (`UserSettingsRepositoryScope` / `UserSettingsControllerScope`).

Settings are fetched on startup for the active user and re-fetched on auth state changes. Each preference change calls `UserSettingsController.saveSettings`, which upserts the row in Supabase (or is a no-op when Supabase is unavailable).

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
