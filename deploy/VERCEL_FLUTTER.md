# Deploying the Flutter web client to Vercel

This repository includes a Flutter client under `client/`. The following configuration files at the repo root make it possible to deploy the generated web build to Vercel:

- `vercel.json` runs the Flutter web build from the `client` directory and configures SPA routing to `index.html`.
- `.vercelignore` prevents backend and infrastructure files from being uploaded for this static deployment.

## Prerequisites

- A Vercel project connected to this repository.
- A Flutter SDK available during the Vercel build. Vercel environments do not include Flutter by default, so install it in your project settings ("Install Command") or build via CI and upload the prepared `client/build/web` directory.

## Default build behavior

The root `vercel.json` issues the following command during the Vercel build step:

```bash
cd client && flutter pub get && flutter build web --release
```

It expects the final static assets under `client/build/web`, which Vercel then serves. Client-side routing is supported via the configured fallback to `index.html`.

## Recommendations

- If you prebuild locally or in CI, ensure `client/build/web` is present before running `vercel --prod`.
- Keep Flutter and Dart caches out of the repository; Vercel handles dependencies per deployment.
- For Git-based deployments, set the project root to the repository root so the provided configuration files are applied.
