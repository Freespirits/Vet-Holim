# Deploying the Flutter web client + API to Vercel

This repo now deploys both the Flutter web client (static) and the Express API (serverless function) on Vercel. The API expects a managed Postgres instance (Vercel Postgres recommended) and uses in-memory Redis mocks by default in serverless to avoid long-lived connections.

## What the config does
- `vercel.json` installs a pinned Flutter SDK, installs server deps, builds the API (`npm run build` in `server/`), and builds the Flutter web client (`client/build/web`).
- Routing: `/api/(.*)` hits `api/index.ts`, which wraps the Express app; all other paths serve the Flutter SPA with asset passthrough.
- `.vercelignore` only skips infra assets (e.g., `deploy/k8s`); server code is included.

## Required env vars (Vercel Project Settings)
- Database (choose one): `POSTGRES_URL` (Vercel Postgres) or `DATABASE_URL`. SSL is enabled automatically when a Vercel Postgres URL is present.
- Serverless-safe defaults: `DISABLE_BACKGROUND_WORKERS=true`, `MOCK_REDIS=true` (prevents BullMQ workers and external Redis connections). If you add Upstash, set `MOCK_REDIS=false` and `REDIS_URL=...`.
- Auth/telemetry (optional): `OIDC_ISSUER`, `OIDC_CLIENT_ID`, `OTEL_EXPORTER_OTLP_ENDPOINT`.

## Build and deploy steps (already encoded in vercel.json)
```bash
# Install
FLUTTER_ROOT="$PWD/.flutter"; export PATH="$FLUTTER_ROOT/flutter/bin:$PATH"; bash deploy/install_flutter.sh; npm install --prefix server
# Build
FLUTTER_ROOT="$PWD/.flutter"; export PATH="$FLUTTER_ROOT/flutter/bin:$PATH"; cd server && npm run build && cd ../client && flutter pub get && flutter build web --release
```
`functions.api/index.ts.runtime=nodejs20.x` ensures the API runs on Node 20; `includeFiles` ships `server/dist/**`.

## Verifying a deploy
1) Set env vars above; connect Vercel Postgres.
2) Deploy from the repo root. Vercel serves the client from `client/build/web`.
3) Hit `/api/health` or `/api/readiness` to confirm the API and database are reachable.

## Notes and limitations
- Background sync queue workers are disabled in serverless; API calls that enqueue sync tasks will no-op unless a Redis URL and a long-lived worker environment are provided.
- The Dart validator will fall back to in-process rules if the `dart` binary is unavailable on Vercel.
- For local testing: `npm install && npm run dev` in `server/`; `flutter run -d chrome` in `client/`; `vercel dev` requires `npm run build --prefix server` beforehand so `server/dist` exists.
