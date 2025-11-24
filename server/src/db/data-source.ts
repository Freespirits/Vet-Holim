import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { env } from '../config/env.js';
import { User } from '../entities/User.js';
import { Patient } from '../entities/Patient.js';
import { Encounter } from '../entities/Encounter.js';
import { Order } from '../entities/Order.js';
import { MedicationAdministrationRecord } from '../entities/MedicationAdministrationRecord.js';
import { AuditLog } from '../entities/AuditLog.js';

const entities = [User, Patient, Encounter, Order, MedicationAdministrationRecord, AuditLog];

function buildDataSource(): DataSource {
  if (process.env.NODE_ENV === 'test') {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const { newDb } = require('pg-mem');
    const db = newDb();
    return db.adapters.createTypeormDataSource({ type: 'postgres', entities, synchronize: true }) as DataSource;
  }
  return new DataSource({
    type: 'postgres',
    url: env.databaseUrl,
    entities,
    synchronize: true
  });
}

export const AppDataSource = buildDataSource();
