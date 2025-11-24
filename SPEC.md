# Veterinary Clinic Tablet App Specification

## 1. Context and Goals
- **Purpose:** Build an Android-tablet-first clinical application for veterinarians and technicians to manage patient care, orders, medications, and encounter documentation within small animal practices. The product must support low-connectivity clinics with offline-friendly behaviors, deterministic reconciliation, and a safety-first workflow for prescribing and administration.
- **Deployment model:** Front end in **Flutter**; backend services in **Node.js** (for web APIs, orchestration, integrations) and **Dart server components** (shared models/validation, background jobs). Cloud-native target with containerization; self-hosting option acceptable. Database is assumed to be PostgreSQL, with Prisma or TypeORM on Node.js.
- **Primary goals:**
  - Reduce medication errors through double confirmations, barcode scanning, and proactive warnings.
  - Accelerate encounter documentation with reusable templates and structured data capture.
  - Ensure full auditability (user, time, device, location) for regulatory and quality purposes.
  - Enable optional integration with **Clinica Online** while keeping the system operable without it.
- **Non-goals (MVP):** Client-facing portal, advanced billing, and inventory forecasting.

## 2. Technology Stack
### 2.1 Front End (Flutter)
- Flutter 3.x, targeting Android tablets (API 29+). Use Material 3 components and adaptive layout.
- State management: Riverpod or Provider; avoid global mutable state. Internationalization-ready (English primary; future Hebrew labels/summaries linkable via localization ARB files and translation keys).
- Networking: REST/JSON over HTTPS; offline cache via `sqflite` or `drift`. WebSockets optional for realtime updates.
- Testing: widget tests with `flutter_test`, golden tests for critical screens.

### 2.2 Backend (Node.js and Dart)
- Node.js 20+ for REST APIs (Express/Fastify), authentication, and integration with external systems.
- Dart server modules for shared validation logic and event processing; compiled to native executables for jobs/cron workers where latency is critical.
- Database: PostgreSQL with migration tooling. Redis for ephemeral locks/queues.
- Observability: structured logging (pino), OpenTelemetry traces/metrics, health checks, and readiness probes.

### 2.3 Infrastructure
- Containerized with Docker; deploy via Kubernetes or ECS. Use secrets management (e.g., SSM, Vault) and parameterized config per environment.
- File storage for attachments (photos, lab PDFs) via S3-compatible bucket.
- CI: linting, tests, and formatting on both Flutter and Node/Dart codebases.

## 3. User Roles and Permissions
- **Veterinarian (Vet):** Full clinical privileges—create/close encounters, prescribe medications, approve controlled substances, finalize orders, and override alerts with rationale.
- **Technician/Nurse:** Create encounters, capture vitals, administer meds once a vet prescribes, record treatments, cannot override controlled-substance policies.
- **Pharmacist (optional role):** Verify prescriptions, manage dispensing batches, handle substitutions, run inventory checks.
- **Reception/Front Desk:** Create/update patient records, schedule encounters, view non-clinical demographics, cannot see medication administration notes unless granted explicit permission.
- **Administrator:** Manage users, roles, permissions, facility settings, integration toggles (including Clinica Online), and audit queries.
- **Auditor (read-only):** View encounters, orders, and audit logs; cannot mutate data.

Permission model should be role-based with fine-grained checks at the operation level (e.g., `encounter.close`, `medication.dispense`, `audit.view`). Support temporary privilege escalation with double confirmation and reason capture.

## 4. Core Entities and Data Model
### 4.1 Users
- Fields: id, name, email, phone, role(s), license number (for vets/pharmacists), locale, status (active/locked), MFA setup, last_login, created_at, updated_at.
- Behaviors: MFA enforcement, session tokens with device binding, audit trails on role changes.

### 4.2 Patients (Animals)
- Fields: id, name, species, breed, sex, weight history, age/DOB, color, microchip id, owner contact(s), allergies, flags (aggressive, isolation), primary veterinarian, photo, created_at, updated_at.
- Behaviors: weight-aware dosing calculators, allergy cross-checks, duplicate detection, merge flow with audit trail.

### 4.3 Encounters
- Fields: id, patient_id, reason for visit, presenting complaint, vitals, diagnoses (ICD/clinically relevant codes), progress notes, orders, status (open/in-progress/closed), location, assigned team, created_at, closed_at.
- Behaviors: template-based note sections, structured vitals timeline, discharge instructions, consent forms, offline draft caching with conflict resolution.

### 4.4 Medications
- Fields: id, generic_name, brand_name, form (tablet, liquid, injection), strength, route, frequency, duration, indications, contraindications, warning flags (controlled substance, high-risk), inventory metadata (lot, expiry), barcode(s), created_at, updated_at.
- Behaviors: dosing guidance by species/weight, interaction checks, allergy checks, double confirmation for controlled/high-risk meds, substitution rules.

### 4.5 Orders and Administration Events
- **Orders:** link encounter + medication, with dose, route, schedule, instructions, prescriber, status (draft/pending approval/active/held/completed/cancelled), required confirmations, and rationale on overrides.
- **MAR (Medication Administration Record) events:** timestamp, administering user, dose given, site, refusal/hold reason, barcode scan result, patient verification step, co-signature if required.
- **Audit:** Every order and MAR change is versioned with who/when/where (device id, IP, approximate location if enabled).

## 5. Safety and Compliance Features
- **Double confirmations:**
  - Controlled substances and high-risk meds require prescriber sign-off + administering user confirmation; optionally require co-sign by second clinician for first dose.
  - Dose edits after activation require two-user confirmation or administrator override with reason.
- **Warnings and holds:**
  - Allergies, weight anomalies (>10% change), interaction conflicts, and expired/recall batches trigger blocking or interruptive warnings with explicit acknowledgment text.
  - Automatic hold placement when patient status is “isolation” or “NPO,” with reason and expected duration.
- **Barcode workflows:**
  - Scan patient wristband/label + medication barcode; enforce match before administration. Offline mode must queue scans and reconcile.
- **Audit logs:**
  - Immutable event stream capturing create/update/delete, authentication, privilege changes, integration syncs, and failed attempts. Provide filterable UI by user, patient, date, action. Retention configurable per tenant.
- **Session and device safety:**
  - Automatic logout timers, device PIN/biometric for quick re-entry, optional geo-fencing for controlled workflows.
- **Error recovery:**
  - Draft recovery for notes, retry queues for failed integrations, reconciliation UI for conflicts (show local vs server state).

## 6. Integration Guidelines (Clinica Online optional)
- Integrate via REST/JSON; avoid hard dependency so local workflows function without Clinica Online.
- Syncable objects: patients, appointments, basic billing codes, and finalized encounter summaries. Use idempotent upserts with external_id mapping table.
- Use webhooks or polling with backoff; log each sync attempt in audit stream. Allow admin toggle per clinic and per module (e.g., only appointments).
- Transformations: maintain species/breed vocab mapping; handle locale differences; support Hebrew label mapping for downstream documents if partner requires it.

## 7. UI/UX Requirements for Android Tablets
- **Layout:** Two-column master/detail where space allows; responsive breakpoints for 8–11" tablets. Persistent patient header with key vitals/allergies and quick actions.
- **Navigation:** Bottom navigation or rail for primary areas (Patients, Encounters, Meds, Tasks, Settings). Use FAB for add actions when relevant.
- **Offline cues:** Clear status badges (Online/Syncing/Offline), retry buttons, conflict indicators on records.
- **Forms:** Large touch targets, stepper flows for medication ordering and administration, inline validation. Support numeric keypad for dosing.
- **Safety affordances:** Confirmation modals with explicit risk messaging, color-coded warnings (red: blocking, amber: caution), double confirmation UI capturing both users.
- **Internationalization:** All text sourced from localization files with key naming that supports future Hebrew summaries/labels. Links in the UI to Hebrew reference summaries where applicable; ensure RTL compatibility in styles.
- **Accessibility:** High-contrast theme, screen reader labels, and focus order suitable for touch/keyboard.
- **Media capture:** Camera integration for wound photos; offline storage until upload success with progress indicators.

## 8. Security and Privacy
- OAuth2/OIDC for authentication; short-lived access tokens, refresh tokens with rotation. MFA required for vets/pharmacists by policy flag.
- Role-based authorization enforced on server and mirrored in client guards. Never rely solely on client checks.
- PHI/PII encryption at rest (database + file storage) and in transit (TLS).
- Data retention policies per tenant; soft delete with retention windows and purge jobs.
- Device hygiene: jailbreak/root detection flags; block if policy enabled. Configurable clipboard restrictions for sensitive data.

## 9. Data Validation and Business Rules
- Weight-based dosing calculators per species with min/max bounds; require weight freshness check (e.g., measured within 24h) before new orders.
- Allergy and interaction checks must run on every order change and administration attempt; allow overrides only with rationale.
- Encounter closure requires resolution of active orders, completion of discharge instructions, and signature by vet.
- Versioning: optimistic concurrency with `updated_at` checks; conflict UI shows field-level diffs.

## 10. Observability and Operations
- Centralized audit and application logs with trace correlation IDs shared between client and server.
- Metrics: request latency, sync queue depth, barcode scan success rate, override frequency, and offline duration per device.
- Alerts: failed sync bursts, repeated override spikes, offline devices > threshold, and authentication anomaly detection.
- Feature flags for gradual rollout of high-risk capabilities (e.g., new dosing calculators).

## 11. Offline and Sync Strategy
- Local cache for patients, encounters, medication dictionary, and pending tasks. Use CRDT-friendly merge or last-write-wins with user-visible conflict resolution.
- Sync queues per entity type with exponential backoff and jitter. Manual retry and clear options in settings.
- Visual indicators for unsynced data; prevent irreversible actions (e.g., encounter closure) when critical data unsynced unless admin override.

## 12. Testing Strategy
- Unit tests for calculators (dosing, interaction rules) in Dart shared modules.
- Integration tests for REST APIs and auth flows in Node.js with in-memory Postgres and Redis mocks.
- End-to-end tests on Android emulator using Flutter integration test suites; include barcode scan mocks.
- Load tests for sync endpoints and audit log write path.

## 13. Deployment and Environments
- Environments: dev, staging, production with isolated databases and buckets.
- Migrations run via CI/CD with preflight checks. Feature flags scoped per environment and tenant.
- Blue/green or canary for backend; staged rollout via Play Console internal testing for the Flutter app.

## 14. Codex Usage Guidance
- **Purpose:** Use Codex (GPT-based code generation) to accelerate boilerplate and suggest API/client patterns, while keeping human-reviewed code as the source of truth.
- **Allowed uses:**
  - Scaffolding Flutter screens, Riverpod providers, and form validation snippets.
  - Generating Node.js route handlers, DTOs, and Prisma/TypeORM models.
  - Drafting Dart shared validators or calculators before manual refinement.
- **Prohibited uses:**
  - Unreviewed production code, secrets, or license-protected content generation.
  - Auto-committing Codex output without human review.
- **Quality controls:** Run linters/formatters post-generation, add tests for Codex-assisted code, and require peer review. Document prompts for traceability in PR descriptions.
- **Sample Codex API call (Node.js pseudo-code):**
  ```js
  import OpenAI from "openai";
  const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  const response = await openai.chat.completions.create({
    model: "gpt-4.1",
    messages: [
      { role: "system", content: "You are a senior Flutter engineer." },
      { role: "user", content: "Generate a Riverpod provider for patient search with debounce." }
    ],
    temperature: 0.2,
    max_tokens: 400
  });
  console.log(response.choices[0].message.content);
  ```
- **Hebrew summaries/labels linkage:** Maintain translation keys (e.g., `encounter.summary.he` or `med.warning.he`) and keep a mapping file for future Hebrew outputs. When generating Codex prompts, reference keys instead of hard-coded Hebrew strings to simplify localization workflows.

## 15. Future Enhancements (Post-MVP)
- Owner portal with appointment scheduling and vaccination records.
- Inventory depletion and reordering logic with supplier integration.
- Smart dosing suggestions based on historical response and lab data.
- Structured lab result ingestion with trend visualization.

## 16. Acceptance Criteria
- Specification document delivered in English (1k–2k words) covering the topics above.
- Front end defined as Flutter targeting Android tablets; backend defined as Node.js/Dart.
- Clear role/permission model, entity definitions, safety mechanisms, integration stance, UI requirements, and Codex usage guidance with sample call.
- Localization ready with explicit mention of future Hebrew summary/label support.
