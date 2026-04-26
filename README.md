# GlazerOps

Cross-platform operations app for commercial glazing teams, built with Flutter and Supabase.

## Goal

Deliver a field-usable app for:

* Jobs
* Sites
* Contacts
* Scheduling
* Notes
* Attachments

## Current Stack

* Frontend: Flutter (Android, iOS, Web, Desktop)
* Backend: Supabase
* Database: PostgreSQL (Supabase)

## Current Product State

Working now:

* App shell, routing, and navigation
* Dashboard and jobs list
* Job details read flow from Supabase
* Settings diagnostics (connection test and refresh)
* Graceful startup and repository error handling

Not complete yet:

* Real auth flow (login is still placeholder/bypassed)
* Invite-only onboarding flow is not implemented end-to-end yet
* Create/edit write flows for core entities
* Fully implemented contacts and notes feature pages
* Attachments upload flow
* Automated tests

## Operational Readiness Plan

This is the plan to complete before external user testing:

1. Implement invite-only auth end-to-end (session gating, login, logout, no public signup)
2. Implement job create and edit flows
3. Implement notes create/read/update flow from job details
4. Implement crew assignment create/update flow
5. Complete contacts feature with real data
6. Complete schedule interactions for day/week/month operations
7. Implement attachments upload and display
8. Add minimal regression test suite for critical flows
9. Run app hardening pass (error handling, empty states, loading states)
10. Freeze beta scope and publish tester checklist

## Getting Started

1. Install Flutter SDK for your platform
2. Run:

```bash
flutter pub get
flutter analyze
flutter run
```

3. For live data, pass Supabase defines (see docs/app_README.md)

## Documentation Map

* docs/app_README.md: runtime setup and app behavior
* docs/AUTH_POLICY.md: invite-only auth and onboarding rules
* docs/IMPLEMENTATION_PLAN.md: tracked checklist for operational beta readiness
* docs/ROADMAP.md: implementation phases and priorities
* docs/ARCHITECTURE.md: app layers and data architecture
* docs/DATABASE_SCHEMA.md: schema reference
* docs/VERSION_CONTROL.md: git workflow
