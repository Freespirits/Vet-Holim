# Project Roadmap

This roadmap translates the specification into actionable next steps so we can keep momentum across client, server, and infrastructure.

## 1) Backend foundations (Weeks 1–2)
- **Database bootstrap:** Add Postgres container, baseline schema for users, patients, encounters, medications, and audit events. Use TypeORM migrations to keep environments reproducible.
- **Authentication/authorization:** Wire OIDC/OAuth2 login, role-based guards, and MFA policy enforcement in the Express app. Add JWT validation middleware and session device binding hooks.
- **Observability defaults:** Enable pino structured logging and OpenTelemetry traces/metrics in the server bootstrap, plus `/health` and `/ready` endpoints for liveness and readiness.
- **Seed + fixtures:** Provide seed scripts to load a minimal clinic, a vet, a technician, and mock patients for local development and integration tests.

## 2) Client pillars (Weeks 1–3)
- **App shell + navigation:** Implement the bottom navigation/rail scaffold with placeholders for Patients, Encounters, Meds, Tasks, and Settings. Ensure localization keys exist for all labels.
- **Patient card screen:** Replace the mock data in `PatientCardScreen` with a typed model, offline cache, and repository powered by REST calls to the server. Add loading/empty/error states and barcode entry points.
- **UI safety affordances:** Add status badges for online/sync/offline, blocking warnings for allergies/controlled meds, and confirmation modals aligned to the spec’s safety rules.
- **Testing:** Start widget tests for the patient card and navigation to prevent regressions as offline behaviors and warnings land.

## 3) Shared validation + sync (Weeks 3–4)
- **Shared models/validators:** Stand up a shared Dart package for dosing calculators, interaction checks, and request DTO validation so both client and jobs use identical rules.
- **Sync queues:** Define per-entity sync queues with retry/backoff and conflict markers surfaced in the UI. Add manual retry and “clear queue” controls in Settings.

## 4) Integration + jobs (Weeks 4–6)
- **Clinica Online toggle:** Add an admin setting to enable/disable Clinica Online sync; build idempotent upsert endpoints for patients/appointments and log each sync attempt in the audit stream.
- **Background jobs:** Add BullMQ workers for audit log exports, retry queues, and barcode dictionary refresh; expose metrics for queue depth and failures.

## 5) Quality gates and delivery
- **CI pipeline:** Lint + test for Flutter, Node.js, and shared Dart packages. Add Docker builds and basic load test execution for the sync/audit paths.
- **Release cadence:** Target a tablet MVP that includes patient overview, encounter basics, medication ordering with double confirmation, offline drafts, and audit logging, then iterate with controlled-substance workflows and richer templates.

## 6) Near-term “next step”
Stand up the **backend foundations** first: scaffold the database + migrations, OIDC login, role guards, and health/telemetry endpoints. This unblocks the client from consuming real data and lets us wire the offline cache against a stable API surface.
