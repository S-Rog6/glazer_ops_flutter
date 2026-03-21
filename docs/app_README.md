# Flutter App

## Run the App

flutter pub get
flutter run
flutter analyze

---

## Folder Structure (Current)

/lib
  main.dart                  -> app entry point
  app.dart                   -> MaterialApp setup
  /core
    /constants               -> app colors and size tokens
    /theme                   -> app theme setup
    /widgets                 -> shared shell/nav/drawer widgets
    /utils                   -> responsive helpers
  /features
    /auth
    /contacts
    /dashboard
    /jobs                    -> pages, widgets, models
    /notes
    /schedule
    /settings
  /routes                    -> route names + route generation

---

## First Targets

* Keep the app booting through centralized routes
* Build a clickable jobs flow using mock data
* Replace placeholder pages with real feature UI

---

## Notes

Start simple:

* Hardcode data first
* No API calls yet
* Keep business logic out of UI widgets

---

## Debug Tips

If something breaks:

* Hot restart (not just reload)
* Check console logs
* Simplify before fixing

---

## Goal

Get to a clickable prototype ASAP.
