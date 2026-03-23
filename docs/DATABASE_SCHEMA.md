# Database Schema Notes

## Storage directory automation

This project now includes a recommended trigger pattern for bootstrapping the
expected storage paths for new users and new jobs. The SQL lives in
`docs/supabase-schema-sql.txt`.

### Important Supabase behavior

Supabase Storage treats folders as path prefixes, not first-class directories.
That means you normally **do not need to create folders first**. Uploading a
file such as `jobs/<job_id>/photos/image-001.jpg` is enough for that folder path
to exist logically.

Because of that, the schema uses an application-owned table called
`public.storage_directories` instead of writing directly into `storage.objects`.
This is safer, keeps your schema compatible with Supabase updates, and gives
you a clean place to define the expected folder layout.

### Trigger behavior

#### On `auth.users` insert
The trigger inserts these rows into `public.storage_directories`:
- `users/<user_id>/profile/`
- `users/<user_id>/documents/`
- `users/<user_id>/photos/`

#### On `public.jobs` insert
The trigger inserts these rows into `public.storage_directories`:
- `jobs/<job_id>/contracts/`
- `jobs/<job_id>/photos/`
- `jobs/<job_id>/shop-drawings/`
- `jobs/<job_id>/daily-reports/`

### Placeholder support

The table exposes a generated `placeholder_object` column. If you want empty
folders to show up in your own admin UI, your app or a background worker can
upload a zero-byte file to that path, for example:
- `users/<user_id>/profile/.keep`
- `jobs/<job_id>/photos/.keep`

### Suggested follow-up

If you want the app to fully automate the visible folder creation step, add a
small backend job or Edge Function that watches `public.storage_directories` and
uploads the `.keep` objects with a service role key.
