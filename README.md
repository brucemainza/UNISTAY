# UniStay

UniStay is a Flutter implementation of the boarding house rental application described in `TECHNICAL_DOCUMENTATION.md`.

## Implemented

- Student and landlord authentication flows with role selection.
- OTP verification countdown.
- Student discovery home, house detail, room list, booking payment, success, receipt, map, account, profile, settings, support, filters, and university search screens.
- Landlord dashboard, property detail, room, amenity, profile, payment details, and registration success screens.
- Mock property/room data and server-backed Lenco Pay checkout flow.
- Responsive Flutter UI that runs on Android, web, and desktop.

## Run

```bash
flutter pub get
flutter run
```

## Backend

The Node/Express API lives in `backend/`. It includes JWT auth routes and server-side Lenco Pay routes so the Flutter app never calls Lenco with secret keys directly.

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

## Verify

```bash
flutter analyze
flutter test
```
