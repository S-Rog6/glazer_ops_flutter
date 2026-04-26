# Implementation Plan

## Purpose

This checklist tracks the work required to reach a fully operational beta before external testing.

## How To Use This Plan

- Mark items complete only when code is merged and manually verified.
- Keep scope limited to operational readiness, not feature expansion.
- If a blocker appears, add it to the current phase notes before moving forward.

## Readiness Gate

Do not start external testing until all Phase 1 through Phase 7 items are complete.

## Phase 1 - Auth Completion

### Checklist

- [ ] Remove login bypass from splash routing.
- [ ] Implement real login flow against Supabase auth.
- [ ] Implement logout flow.
- [ ] Ensure app startup routes by session state.
- [ ] Ensure active user context updates after auth changes.
- [ ] Enforce invite-only onboarding (no public self-signup path).
- [ ] Verify Supabase auth settings disable public signup.
- [ ] Remove any UI affordance for self-registration.

### Definition Of Done

- [ ] Signed-out users always land on login.
- [ ] Signed-in users always land on dashboard.
- [ ] Invalid credentials show actionable error text.
- [ ] Logout returns the app to signed-out state without restart.
- [ ] Non-invited users cannot create accounts through the app.
- [ ] Invite flow works end-to-end for a newly invited account.

## Phase 2 - Job Write Flows

### Checklist

- [ ] Add create job UI flow.
- [ ] Add edit job UI flow.
- [ ] Add repository methods for create and update operations.
- [ ] Add validation for required fields.
- [ ] Refresh jobs list and details after writes.

### Definition Of Done

- [ ] New job appears immediately after create.
- [ ] Edited job fields persist and render correctly.
- [ ] Validation blocks invalid form submission.
- [ ] Repository errors surface clear user-facing messages.

## Phase 3 - Job Detail Actions

### Checklist

- [ ] Replace Add Note stub with real create note flow.
- [ ] Replace Pin stub with real pin and unpin behavior.
- [ ] Replace crew assignment stub with create and update flow.
- [ ] Persist note and assignment writes through repository.
- [ ] Refresh tabs after action completion.

### Definition Of Done

- [ ] Notes appear immediately after creation.
- [ ] Pin state persists across app relaunch.
- [ ] Crew assignments reflect selected dates and users.
- [ ] No primary job detail action shows coming-soon behavior.

## Phase 4 - Contacts And Notes Feature Pages

### Checklist

- [ ] Replace contacts placeholder data with repository-backed data.
- [ ] Add contacts filtering or search.
- [ ] Replace notes feature placeholder page with functional list and create flow.
- [ ] Add loading, empty, and error states for both pages.

### Definition Of Done

- [ ] Contacts page is fully data-backed.
- [ ] Notes page is fully data-backed.
- [ ] Both pages remain usable under slow network and error conditions.

## Phase 5 - Attachments Flow

### Checklist

- [ ] Implement add photo or file action from job details.
- [ ] Upload attachment to configured backend storage.
- [ ] Save attachment metadata and link to job.
- [ ] Render attachments list or gallery in job details.
- [ ] Add upload and fetch failure handling.

### Definition Of Done

- [ ] Attachment upload succeeds end-to-end.
- [ ] Uploaded attachment is visible in the Attachments tab.
- [ ] Failed uploads provide retry path and clear error message.

## Phase 6 - Schedule Completion

### Checklist

- [ ] Validate day, week, and month schedule interactions against real data.
- [ ] Ensure selected date and schedule state stay in sync.
- [ ] Support crew assignment access from schedule workflow.
- [ ] Add empty and conflict states where needed.

### Definition Of Done

- [ ] Day, week, and month views are operational for dispatch workflow.
- [ ] Date selection consistently drives visible scheduled data.
- [ ] No schedule view contains placeholder-only content.

## Phase 7 - Quality Gate

### Checklist

- [ ] Add unit tests for controller critical paths.
- [ ] Add unit tests for repository success and failure paths.
- [ ] Add smoke tests for auth plus core jobs flow.
- [ ] Run flutter analyze with zero new warnings from this scope.
- [ ] Run flutter test and confirm all tests pass.

### Definition Of Done

- [ ] Critical auth and jobs flows are covered by automated tests.
- [ ] Analyze and test pass locally before release candidate build.
- [ ] No known blocker remains for external tester workflow.

## Final Release Checklist

- [ ] All prior phases complete.
- [ ] Documentation reflects shipped behavior.
- [ ] External tester script is written and reviewed.
- [ ] Beta build is created from main and smoke checked.
