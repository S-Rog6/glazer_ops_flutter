# Authentication And Onboarding Policy

## Status

Current decision: user onboarding is invite-only.

Public self-signup is not allowed for this beta.

## Policy

- Allowed: invited users who receive an authorized invite link.
- Not allowed: public account creation from app login screen.
- Login providers: email/password for invited accounts only.
- Future providers (Google or others) are deferred until after beta stability.

## Supabase Configuration Requirements

- Disable open email signups in Supabase Auth settings.
- Keep confirmation and reset flows enabled for invited users.
- Restrict account creation to trusted admin workflows only.

## Invite Workflow

1. Admin creates an invite for a specific email.
2. User receives invite email and completes account setup.
3. User signs in from the app login screen.
4. App routes authenticated users into the main shell.

## App UX Requirements

- Login page must not expose a public "Create account" action.
- Login page should include a short "Need access? Contact admin" message.
- Unauthorized or non-invited users should receive a clear denial message.

## Data And Access Requirements

- User-scoped reads and writes must rely on authenticated user identity.
- RLS policies must deny data access for non-authenticated users.
- Profile linkage should stay consistent with auth user IDs.

## Beta Exit Criteria For Auth

- Public signup is disabled in Supabase and verified.
- Invite flow works end-to-end for a new user.
- Login/logout/session routing works without bypass flags.
- No auth route allows unauthenticated access to protected screens.