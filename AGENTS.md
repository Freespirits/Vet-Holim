# Repository Guidelines

## Project Structure & Module Organization
- `server/`: TypeScript/Express API with telemetry, queues, and TypeORM entities (`src/`) plus Jest and Artillery tests in `tests/`.
- `client/`: Flutter tablet-first UI (`lib/` for features/config, `test/` for widget/unit tests).
- `shared/dart/`: Reusable Dart helpers consumed by the client.
- `deploy/`: Observability config (OTel collector). Root `docker-compose.yml` runs API, client, Postgres, Redis, and OTel.
- Use `env.example` as the template for `.env` files; never commit secrets.

## Build, Test, and Development Commands
- API (server): `npm install` then `npm run dev` for local watch mode; `npm run build && npm start` for production bundle; `npm run lint` for ESLint; `npm test` for Jest; `npm run load:test` for Artillery load (requires Redis/Postgres running, e.g., `docker-compose up db redis`).
- Client: `flutter pub get`, `flutter run -d chrome` or a device for live dev, `flutter analyze` for linting, `flutter test` for widget/unit coverage.
- Shared Dart: `dart pub get` then `dart test` inside `shared/dart`.
- Full stack: `docker-compose up --build` from the repo root to serve API on 4000 and client on 8080.

## Coding Style & Naming Conventions
- TypeScript: 2-space indent, ES modules, camelCase for vars/functions, PascalCase for classes/types, kebab-case filenames (e.g., `app.ts`). Keep controllers/services small and pure; prefer dependency injection via module exports.
- Flutter/Dart: `lower_snake_case` filenames, PascalCase widgets, camelCase members. Keep widgets small and rely on Riverpod providers for state. Run `flutter analyze` before opening a PR.
- Follow ESLint rules in `.eslintrc.cjs` and Dart lints in `analysis_options.yaml`; auto-format with your editor (Prettier/`dart format`).

## Testing Guidelines
- Place API tests under `server/tests` as `*.test.ts`; use supertest for HTTP integration. Reset mocks/state in `beforeEach` and prefer fast in-memory DB/Redis mocks when possible.
- Load tests live in `server/tests/load`; run only against disposable environments with `LOAD_TEST_TOKEN` set.
- Flutter tests belong in `client/test` using `testWidgets`/`test`; add focused fixtures under `client/lib/features/.../`.
- Shared Dart tests live in `shared/dart/test`; keep them deterministic and side-effect free.

## Commit & Pull Request Guidelines
- Keep commit subjects short, present-tense, and imperative (e.g., "Fix lint issues in queue"); align with existing history.
- For PRs: include a brief summary, linked issue (if any), tests run (`npm test`, `flutter test`, etc.), and screenshots for visible UI changes. Note any config changes (env vars, ports) and rollout considerations (DB/queue migrations).
