# UniStay Backend

Node/Express API for UniStay authentication and server-side Lenco Pay collection logic.

## Setup

```bash
cp .env.example .env
npm install
npm run dev
```

The server listens on `http://localhost:4000` by default.

## Key Routes

- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/payments/lenco/mobile-money`
- `GET /api/payments/lenco/:reference`
- `POST /api/webhooks/lenco`

## Lenco Notes

Keep `LENCO_MOCK=true` while developing without Lenco credentials. When credentials are ready, set:

```bash
LENCO_MOCK=false
LENCO_SECRET_KEY=your_lenco_secret_key
```

The mobile app should call this backend, not Lenco directly. The backend sends `Authorization: Bearer LENCO_SECRET_KEY` to Lenco and returns only the payment session/status to the app.
