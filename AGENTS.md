# UniStay — Agent Guide

This repository contains **UniStay**, a Flutter boarding-house discovery and landlord-management app with a small Node/Express backend. The project was bootstrapped with the standard Flutter template and targets Android, iOS, web, and Linux.

## Project Overview

- **Frontend:** Flutter (Dart SDK `^3.12.0`), Material 3 design.
- **Backend:** Node.js/Express (`backend/`), JWT auth, in-memory stores, Lenco Pay collection integration in mock mode by default.
- **Package name:** `com.example.unistay`
- **Architecture note:** The entire Flutter app is deliberately structured as a **single Dart library** split with `part` / `part of` directives. All library files are imported as `part` files from `lib/main.dart`. New code must follow this pattern.

## Technology Stack

### Frontend (`/`)

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Flutter package manifest. Dependencies: `cupertino_icons`, `http`, `google_maps_flutter`. Dev: `flutter_lints`, `flutter_test`. |
| `analysis_options.yaml` | Uses `package:flutter_lints/flutter.yaml` with no custom rule overrides. |
| `.metadata` | Flutter tool metadata; project is on the `stable` channel. |
| `lib/main.dart` | App entry point and the single library root that declares every `part` file. |
| `android/app/build.gradle.kts` | Android app module. `namespace = "com.example.unistay"`, Java/Kotlin target JVM 17, signing uses debug config in release builds (not production-ready). |

### Backend (`backend/`)

| File | Purpose |
|------|---------|
| `package.json` | Node module manifest. `type: "module"`. Scripts: `dev` (watch mode), `start`. Dependencies: `express`, `bcryptjs`, `jsonwebtoken`, `cors`, `dotenv`, `nanoid`. |
| `.env.example` | Required environment variables: `PORT`, `JWT_SECRET`, `JWT_EXPIRES_IN`, `LENCO_MOCK`, `LENCO_SECRET_KEY`, `LENCO_BASE_URL`, `CORS_ORIGINS`. |
| `src/server.js` | Single-file Express server with auth, payment, and webhook routes. Uses in-memory `Map`s for users and payments. |

## Code Organization

All Flutter code lives under `lib/`. Because the project uses `part of '../main.dart'` in every file, the directory structure is mainly for human organization; the analyzer treats it as one library.

```
lib/
├── main.dart                      # Entry point + part declarations
├── app/unistay_app.dart           # MaterialApp, theme, onGenerateRoute
├── core/
│   ├── app_constants.dart         # Brand colors (orangePrimary, mintGreen, etc.)
│   └── routes.dart                # String route constants
├── models/                        # House, Room, PaymentSession, UniversityOption
├── data/mock_data.dart            # Sample houses, rooms, universities
├── services/unistay_api.dart      # HTTP client for backend + Lenco Pay
├── screens/                       # One folder per feature area
│   ├── auth/                      # splash, login, signup, verification
│   ├── student/                   # home, house detail, room list, notifications
│   ├── payment/                   # payment, success, receipt
│   ├── account/                   # account, profile, settings, customer care, my accommodation
│   ├── map/                       # map screen
│   ├── search/                    # university search, filters
│   └── landlord/                  # landlord home, property/room/amenity screens, profile, payment details, registration success
└── widgets/                       # Reusable UI pieces (auth, home, room, payment, map, landlord, common, etc.)
```

### Important Conventions

- Every Dart file under `lib/` starts with `part of '../main.dart'` (or `../../main.dart` for nested files).
- Do **not** add `import` statements in part files for project code. Use the shared imports declared at the top of `main.dart` (`material`, `services`, `http`, `google_maps_flutter`, etc.).
- Constants are defined in `lib/core/app_constants.dart` and used throughout the app.
- Navigation is centralized in `lib/app/unistay_app.dart` via `onGenerateRoute`. Add new routes to both `lib/core/routes.dart` and the switch statement in `unistay_app.dart`.
- Currency formatting uses `kwacha(int)` from `lib/utils/formatters.dart`.
- Feedback uses `showSnack(BuildContext, String)` from `lib/utils/ui_feedback.dart`.

## Build and Run

### Frontend

```bash
flutter pub get
flutter run
```

For Android emulator against the local backend, the default API base URL is `http://10.0.2.2:4000/api`. For web or desktop, override it at build time:

```bash
flutter run --dart-define=UNISTAY_API_BASE_URL=http://localhost:4000/api
```

### Backend

```bash
cd backend
cp .env.example .env
# Edit .env and set JWT_SECRET to a long random value.
npm install
npm run dev
```

The server listens on `http://localhost:4000` by default.

### Available Backend Routes

| Method | Route | Notes |
|--------|-------|-------|
| `GET` | `/health` | Service health + Lenco mode |
| `POST` | `/api/auth/register` | `{ fullName, phone, email, password, role? }` |
| `POST` | `/api/auth/login` | `{ phone, password }` |
| `POST` | `/api/payments/lenco/mobile-money` | Auth required; `{ amount, currency?, phone, operator, roomType? }` |
| `GET` | `/api/payments/lenco/:reference` | Auth required; checks payment status |
| `POST` | `/api/webhooks/lenco` | Raw JSON webhook endpoint (currently just acknowledges) |

Auth accepts a real JWT **or** the literal `Bearer dev-student-token` outside production.

## Testing

### Frontend

```bash
flutter analyze
flutter test
```

Current test coverage is minimal: `test/widget_test.dart` contains two widget tests verifying the splash screen and login navigation.

### Backend

There are no automated backend tests yet. Verify manually with `curl` or run the app against the local server.

## Code Style Guidelines

- Follow the default `flutter_lints` rules. Run `flutter analyze` before finishing changes.
- Prefer `const` constructors where possible.
- Keep widgets small and stateless when feasible; reuse components in `lib/widgets/`.
- Use the existing color constants from `lib/core/app_constants.dart` rather than inline hex colors.
- Match the existing rounded-corner aesthetic (large border radii, orange primary, mint green for prices).
- Do not introduce new top-level imports in part files. If a new third-party package is needed, add it to `pubspec.yaml` and import it once in `lib/main.dart`.

## Security Considerations

- **Backend secrets:** `JWT_SECRET` must be replaced with a cryptographically secure random value for any real deployment. The example `.env` values are not safe for production.
- **Lenco credentials:** `LENCO_SECRET_KEY` is never sent to the Flutter app. The backend attaches it when calling Lenco. Keep `LENCO_MOCK=true` until live credentials are available.
- **In-memory storage:** The backend stores users and payments in `Map` objects. This is fine for development and demos but must be replaced with a real database before production.
- **CORS:** Configure `CORS_ORIGINS` with the actual deployed frontend origin(s).
- **Debug signing:** The Android release build currently signs with the debug keystore. Replace `signingConfig` before releasing.
- **Dev token:** `dev-student-token` is accepted when `NODE_ENV !== 'production'`. Do not deploy with this behavior enabled.

## Deployment Notes

- No CI/CD configuration or Docker files are present in the repository.
- The backend expects environment variables at runtime; copy `.env.example` to `.env` and fill in real values on the host.
- The Flutter web build can be produced with `flutter build web` and served from any static host. Remember to set `UNISTAY_API_BASE_URL` to the deployed backend.
- The Android release APK/App Bundle requires a proper signing configuration in `android/app/build.gradle.kts`.

## Useful Documentation

- `README.md` — Quick start for frontend and backend.
- `backend/README.md` — Backend setup and route summary.
- `TECHNICAL_DOCUMENTATION.md` — Detailed UI/UX specification (screen layouts, color palette, navigation flows) written for the original design; the Flutter implementation is based on it.
