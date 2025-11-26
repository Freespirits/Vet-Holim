import 'reflect-metadata';
import { createRequire } from 'module';
import { randomUUID } from 'crypto';
import { DataSource } from 'typeorm';
import { env } from '../config/env.js';
import { User } from '../entities/User.js';
import { Patient } from '../entities/Patient.js';
import { Encounter } from '../entities/Encounter.js';
import { Order } from '../entities/Order.js';
import { MedicationAdministrationRecord } from '../entities/MedicationAdministrationRecord.js';
import { AuditLog } from '../entities/AuditLog.js';
import { logger } from '../logger.js';

const require = createRequire(import.meta.url);

const entities = [User, Patient, Encounter, Order, MedicationAdministrationRecord, AuditLog];

function buildDataSource(): DataSource {
  if (process.env.NODE_ENV === 'test' || env.useInMemoryDb) {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const { newDb } = require('pg-mem');
    const db = newDb();
    db.public.registerFunction({ name: 'version', returns: 'text', implementation: () => 'pg-mem' });
    db.public.registerFunction({ name: 'current_database', returns: 'text', implementation: () => 'pg-mem' });
    db.public.registerFunction({
      name: 'uuid_generate_v4',
      returns: 'uuid',
      implementation: () => randomUUID(),
      impure: true
    });
    db.public.none('CREATE TABLE IF NOT EXISTS pg_views (schemaname text, viewname text)');
    db.public.none('CREATE TABLE IF NOT EXISTS pg_matviews (schemaname text, matviewname text)');
    db.public.none('CREATE TABLE IF NOT EXISTS pg_tables (schemaname text, tablename text)');
    return db.adapters.createTypeormDataSource({ type: 'postgres', entities, synchronize: true }) as DataSource;
  }
  try {
    const dbHost = new URL(env.databaseUrl).hostname;
    logger.info({ dbHost, databaseSsl: env.databaseSsl }, 'configuring postgres datasource');
  } catch (err) {
    logger.warn({ err, databaseUrl: env.databaseUrl }, 'failed to parse database url');
  }
  return new DataSource({
    type: 'postgres',
    url: env.databaseUrl,
    ssl: env.databaseSsl ? { rejectUnauthorized: false } : undefined,
    extra: env.databaseSsl ? { ssl: { rejectUnauthorized: false } } : undefined,
    entities,
    synchronize: true
  });
}

export const AppDataSource = buildDataSource();
