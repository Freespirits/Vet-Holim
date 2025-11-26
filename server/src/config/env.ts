import dotenv from 'dotenv';

dotenv.config();

const runningOnVercel = Boolean(process.env.VERCEL);
const vercelDatabaseUrl =
  process.env.POSTGRES_PRISMA_URL ||
  process.env.POSTGRES_URL_NON_POOLING ||
  process.env.POSTGRES_URL ||
  process.env.POSTGRES_CONNECTION_STRING;

const databaseUrl =
  process.env.DATABASE_URL || vercelDatabaseUrl || 'postgres://postgres:postgres@localhost:5432/vetholim';
const shouldUseSsl =
  process.env.DATABASE_SSL === 'true' || (process.env.DATABASE_SSL !== 'false' && Boolean(vercelDatabaseUrl));
const useMockRedis = process.env.MOCK_REDIS === 'true' || (!process.env.REDIS_URL && runningOnVercel);
const disableBackgroundWorkers = process.env.DISABLE_BACKGROUND_WORKERS === 'true' || runningOnVercel;

export const env = {
  port: parseInt(process.env.PORT || '4000', 10),
  databaseUrl,
  databaseSsl: shouldUseSsl,
  oidcIssuer: process.env.OIDC_ISSUER || 'https://example-issuer',
  oidcClientId: process.env.OIDC_CLIENT_ID || 'vetholim-api',
  redisUrl: process.env.REDIS_URL || 'redis://localhost:6379',
  auditRetentionDays: parseInt(process.env.AUDIT_RETENTION_DAYS || '30', 10),
  dartValidatorPath:
    process.env.DART_VALIDATOR_PATH || new URL('../../shared/dart/validation/bin/validator.dart', import.meta.url).pathname,
  offlineBackoffBaseMs: parseInt(process.env.OFFLINE_BACKOFF_MS || '1000', 10),
  offlineBackoffMaxMs: parseInt(process.env.OFFLINE_BACKOFF_MAX_MS || '32000', 10),
  offlineBackoffAttempts: parseInt(process.env.OFFLINE_BACKOFF_ATTEMPTS || '5', 10),
  offlineBackoffJitter: process.env.OFFLINE_BACKOFF_JITTER
    ? process.env.OFFLINE_BACKOFF_JITTER === 'true'
    : true,
  environment: process.env.APP_ENV || process.env.NODE_ENV || 'development',
  useInMemoryDb: process.env.USE_IN_MEMORY_DB === 'true',
  useMockRedis,
  disableBackgroundWorkers,
  otelExporterEndpoint: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://otel-collector:4318',
  serviceName: process.env.SERVICE_NAME || 'vetholim-server',
  featureFlags: JSON.parse(
    process.env.FEATURE_FLAGS ||
      JSON.stringify({
        enableOfflineSync: true,
        enableAuditTrail: true,
        enableClinicaIntegration: false
      })
  ),
  loadTestToken: process.env.LOAD_TEST_TOKEN || ''
};
