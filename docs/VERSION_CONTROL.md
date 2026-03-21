# Version Control Workflow

This project uses Git with a lightweight, team-friendly workflow.

## Branch Strategy

- `main`: stable branch, always deployable.
- `feature/<short-description>`: new features.
- `fix/<short-description>`: bug fixes.
- `chore/<short-description>`: maintenance and tooling.

Examples:

- `feature/jobs-filtering`
- `fix/schedule-timezone-bug`
- `chore/flutter-upgrade-3-32`

## Daily Flow

1. Pull latest changes from `main`.
2. Create a branch from `main`.
3. Commit in small, focused chunks.
4. Push branch and open a pull request.
5. Squash-merge into `main` after review.

## Commit Message Convention

Use Conventional Commits:

- `feat: add jobs list filters`
- `fix: prevent crash on empty notes`
- `chore: update flutter sdk constraints`
- `docs: add architecture decisions`
- `refactor: simplify job card layout`
- `test: add dashboard widget tests`

Format:

`<type>: <short summary>`

## Local Quality Gates Before Commit

Run these before pushing:

```bash
flutter pub get
flutter analyze
flutter test
```

Optional formatting pass:

```bash
dart format .
```

## Pull Request Checklist

- Scope is small and focused.
- Analyzer and tests pass locally.
- UI changes include updated screenshots (if applicable).
- Docs updated when behavior/workflow changes.

## Tags and Releases

Create tags from `main` only:

- `v0.1.0`
- `v0.2.0`

Example:

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Recommended One-Time Setup

Set your default branch globally (optional):

```bash
git config --global init.defaultBranch main
```

Set your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
