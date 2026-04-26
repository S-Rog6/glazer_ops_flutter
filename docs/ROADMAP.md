# Roadmap

## Objective

Reach a fully operational beta build before external testing.

## Phase 1 - Foundation (Complete)

Goal: app boots, routes, and renders core navigation shell.

* [x] Centralized route generation
* [x] App shell with primary navigation
* [x] Theme foundation
* [x] Shared layout and reusable UI primitives

---

## Phase 2 - Read-Only Core Flows (Mostly Complete)

Goal: users can browse jobs and view details.

* [x] Jobs list and card display
* [x] Job details page structure
* [x] Dashboard wiring to jobs data
* [x] Supabase bootstrap and live read integration
* [ ] Eliminate remaining placeholder actions in job details

---

## Phase 3 - Operational Flows (Current Priority)

Goal: remove blockers so the app is usable for real work.

* [ ] Invite-only auth flow end-to-end (session-aware splash, login, logout, no public signup)
* [ ] Job create and edit flow
* [ ] Notes create/update flow from job details
* [ ] Crew assignment create/update flow
* [ ] Contacts feature backed by real data
* [ ] Attachments upload and display

---

## Phase 4 - Schedule and Reliability

Goal: improve planning workflows and runtime confidence.

* [ ] Complete day/week/month schedule interactions for operations use
* [ ] Add robust empty/loading/error states across all primary pages
* [ ] Add offline strategy (cache plus deferred sync) or explicitly defer with UX messaging

---

## Phase 5 - Quality Gate Before External Testing

Goal: freeze a stable beta candidate.

* [ ] Unit tests for controller and repository critical paths
* [ ] Integration smoke checks for login, jobs read/write, and notes flow
* [ ] Manual test checklist for Android, iOS, and Web
* [ ] Performance pass for jobs list and job details
* [ ] Documentation and release notes update

---

## Priority Order

1. Auth completion
2. Job write flows
3. Notes and crew updates
4. Contacts completion
5. Attachments flow
6. Schedule completion
7. Test coverage and release hardening

---

## Reality Check

If it is not usable in the field within 10 seconds of opening the app, it is not ready.
