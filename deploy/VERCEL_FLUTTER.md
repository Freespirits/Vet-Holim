# Deploying the Flutter web client to Vercel

This repository includes a Flutter client under `client/`. The following configuration files at the repo root make it possible to deploy the generated web build to Vercel:

- `vercel.json` installs a pinned Flutter SDK, runs the Flutter web build from the `client` directory, and configures SPA routing to `index.html`.
- `.vercelignore` prevents backend and infrastructure files from being uploaded for this static deployment.

## Prerequisites

- A Vercel project connected to this repository.
- Network access during the Vercel install step to download the Flutter SDK tarball.

## Default build behavior

The root `vercel.json` issues the following commands during the Vercel build step:

```bash
bash deploy/install_flutter.sh
export PATH="$PWD/.flutter/flutter/bin:$PATH" && cd client && flutter pub get && flutter build web --release
```

It installs Flutter (defaults to `3.24.0-stable`), caches it under `.flutter/`, and then builds the web client. Client-side routing is supported via the configured fallback to `index.html`.

## Recommendations

- Override `FLUTTER_VERSION` or `FLUTTER_CHANNEL` in the Vercel project settings if you need a different SDK release.
- If you prebuild locally or in CI, ensure `client/build/web` is present before running `vercel --prod`.
- Keep Flutter and Dart caches out of the repository; Vercel handles dependencies per deployment.
- For Git-based deployments, set the project root to the repository root so the provided configuration files are applied.
