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

## Data Model (Basic)

### Jobs

* id
* job_name
* po_number
* site_id

### Sites

* id
* name
* address

### Contacts

* id
* job_id
* name
* phone

### Schedules

* id
* job_id
* start_date
* end_date

### Notes

* id
* job_id
* content
* created_at

---

## Key Decision (Important)

We will use:

* **Views on backend** (combined data)
* NOT heavy joins in UI

UI should receive:
→ “ready-to-display” data

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
