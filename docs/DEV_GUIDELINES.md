# Dev Guidelines

## General Rules

* Keep files small
* One responsibility per file
* No massive widgets

---

## Naming

Bad:

data.dart
utils.dart
stuff.dart

Good:

job_model.dart
job_service.dart
job_list_page.dart

Use suffixes consistently:

* `_page.dart` for top-level screens
* `_card.dart`, `_tab.dart`, `_tile.dart` for UI widgets
* singular model files like `job.dart`

---

## Widgets

* Break everything down
* Reusable > duplicated

---

## State Management

DO NOT:

* Put logic in UI files

DO:

* Move logic into services/providers

---

## Data Handling

* UI should NOT build data manually
* Backend should return clean data
* Use models everywhere
* Keep model key mapping in model classes (`fromJson` / `toJson`)

---

## Routing

* Define route names in one place (`app_router.dart`)
* Use `onGenerateRoute` from `MaterialApp`
* Avoid route string literals throughout feature code

---

## Styling

* Centralize colors
* No random hex values everywhere

---

## Big Rule

If something feels messy:
→ it is messy
→ fix it early
