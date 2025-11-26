# Repository Guidelines

## Project Structure & Module Organization
- `server/`: TypeScript/Express API with telemetry hooks, Redis-backed queues, and TypeORM entities under `src/`; Jest unit/integration suites and Artillery load profiles live in `tests/`.
- `client/`: Flutter tablet-first UI; feature code in `lib/`, localization config in `l10n.yaml`, widget/unit tests in `test/`.
- `shared/dart/`: Reusable Dart utilities (`lib/`), deterministic tests in `test/`, plus a `validation/` package for YAML-driven rules.
- `deploy/`: OpenTelemetry collector config; root `docker-compose.yml` starts API (4000), client (8080), Postgres, Redis, and OTel.
- Copy `env.example` to `.env*` variants locally; never commit secrets or tokens.

## Build, Test, and Development Commands
- API (server): `npm install`; `npm run dev` for watch mode; `npm run build && npm start` for the compiled bundle; `npm run lint` for ESLint; `npm test` for Jest; `npm run load:test` for Artillery (requires Redis/Postgres running, e.g., `docker-compose up db redis`).
- Client: `flutter pub get`, then `flutter run -d chrome` (or a device) for live dev; `flutter analyze` for lints; `flutter test` for widget/unit coverage.
- Shared Dart: from `shared/dart`, run `dart pub get` then `dart test`; use `dart format .` before committing.
- Full stack: `docker-compose up --build` from repo root to run everything with sensible dev defaults.

## Coding Style & Naming Conventions
- TypeScript: 2-space indent, ES modules, camelCase for vars/functions, PascalCase for classes/types, kebab-case file names. Keep controllers/services small and inject dependencies; log via `pino` wrappers.
- Flutter/Dart: `lower_snake_case` files, PascalCase widgets/types, camelCase members; prefer Riverpod for state and `const` widgets where possible. Follow `analysis_options.yaml` (const-first rules) and format with `dart format`.
- Honor lint configs (`server/.eslintrc.cjs`, Flutter lints); avoid unchecked any/nullable drift.

## Testing Guidelines
- API: place specs in `server/tests` as `*.test.ts`; Jest config (`jest.config.cjs`) treats TS as ESM. Use supertest for HTTP, reset mocks in `beforeEach`, and prefer `pg-mem`/`ioredis-mock` over live services.
- Load: `server/tests/load` contains Artillery plans; run only against disposable envs with `LOAD_TEST_TOKEN` set.
- Flutter: add widget/unit tests under `client/test`; co-locate fixtures in `client/lib/features/...` for readability.
- Shared Dart: keep tests in `shared/dart/test`; maintain deterministic, side-effect-free cases.

## Commit & Pull Request Guidelines
- Commits: short, present-tense, imperative subjects (e.g., `Add audit queue handler`); scope changes narrowly.
- PRs: include a concise summary, linked issue, test matrix (`npm test`, `flutter test`, etc.), screenshots for UI changes, and call out config/migration impacts (env vars, ports, queues, DB).
