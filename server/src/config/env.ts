import dotenv from 'dotenv';

dotenv.config();

export const env = {
  port: parseInt(process.env.PORT || '4000', 10),
  databaseUrl: process.env.DATABASE_URL || 'postgres://postgres:postgres@localhost:5432/vetholim',
  oidcIssuer: process.env.OIDC_ISSUER || 'https://example-issuer',
  oidcClientId: process.env.OIDC_CLIENT_ID || 'vetholim-api',
  redisUrl: process.env.REDIS_URL || 'redis://localhost:6379',
  auditRetentionDays: parseInt(process.env.AUDIT_RETENTION_DAYS || '30', 10),
  dartValidatorPath:
    process.env.DART_VALIDATOR_PATH || new URL('../../shared/dart/validation/bin/validator.dart', import.meta.url).pathname,
  offlineBackoffBaseMs: parseInt(process.env.OFFLINE_BACKOFF_MS || '1000', 10)
};
