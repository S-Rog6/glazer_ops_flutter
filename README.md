# GlazerOps (Working Name)

A cross-platform app for managing commercial glazing jobs, built with **Flutter (frontend)** and a lightweight backend (TBD).

## Goal

Make jobsite tracking dead simple:

* Jobs
* Sites
* Contacts
* Schedules
* Notes
* Attachments

No fluff. Fast. Usable in the field.

---

## Tech Stack (Current Plan)

* Frontend: Flutter (Android, iOS, Web, Desktop)
* Backend: TBD (likely Supabase or similar)
* Database: PostgreSQL (via backend)
* Hosting: Web + PWA first

---

## Project Structure

/glazerops
  /app              -> Flutter app
  /docs             -> Planning + architecture + database schema
  /backend          -> (future backend code)

---

## Current Status

Phase 1: Setup + UI foundation

* [x] Flutter project created
* [x] Navigation structure
* [x] Base layout (tabs/pages)
* [x] Theme system

---

## Core Pages (Planned)

* Dashboard
* Jobs List
* Job Details
* Notes
* Schedule
* Settings

---

## Design Philosophy

* Fast > Fancy
* Simple > Clever
* Field-friendly (big buttons, minimal typing)

---

## Next Steps

1. Build basic navigation
2. Create Jobs List page
3. Create Job Details layout (static first)
4. Wire up fake/mock data

---

## Rules (Don’t Ignore These)

* No overengineering early
* No backend until UI flow makes sense
* Every page must be usable before moving on

---

## Notes

This is being built iteratively. Expect changes.

Keep everything modular so we don’t regret decisions later.
Backend schema planning now lives in `docs/DATABASE_SCHEMA.md`.

---

## Version Control

Git workflow and conventions are documented in `docs/VERSION_CONTROL.md`.

Quick start:

1. Create branches from `main` using `feature/*`, `fix/*`, or `chore/*`
2. Use Conventional Commit messages (`feat: ...`, `fix: ...`, etc.)
3. Run `flutter analyze` and `flutter test` before opening a PR
