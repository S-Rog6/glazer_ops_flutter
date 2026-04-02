# Roadmap

## Phase 1 – UI Foundation

Goal: App runs and navigation works

* [x] Setup routing
* [x] Bottom navigation / sidebar
* [x] Theme (dark + light)
* [x] Base layout components

---

## Phase 2 – Jobs Flow

Goal: You can view and open jobs

* [x] Jobs List page
* [x] Job Card UI
* [x] Job Details page
* [ ] Static/mock data

---

## Phase 3 – Job Details

Goal: Full job info displayed

* [ ] Contacts section
* [ ] Schedule / crew section
* [ ] Notes section
* [ ] Attachments placeholder (backend deferred)

---

## Phase 4 – Backend Integration

Goal: Real data

* [ ] Setup backend (Supabase likely)
* [ ] Create or verify core tables from `supabase-schema-sql.txt`
* [ ] Decide whether Flutter will read base tables directly or whether targeted views/RPCs are worth adding
* [ ] Add auth mapping and RLS policies
* [ ] Connect Flutter app

---

## Phase 5 – Offline Support

Goal: Works without internet

* [ ] Local storage
* [ ] Sync logic
* [ ] Conflict handling (basic)

---

## Phase 6 – Polish

* [ ] UX improvements
* [ ] Performance tuning
* [ ] Error handling
* [ ] Logging

---

## Reality Check

If it’s not usable by:

* a guy on a jobsite
* with dirty hands
* in under 10 seconds

…it’s wrong.
