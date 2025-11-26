import request from 'supertest';
import { app } from '../src/app.js';
import { AppDataSource } from '../src/db/data-source.js';
import { User } from '../src/entities/User.js';
import { Patient } from '../src/entities/Patient.js';
import { Encounter } from '../src/entities/Encounter.js';
import { Order } from '../src/entities/Order.js';
import { MedicationAdministrationRecord } from '../src/entities/MedicationAdministrationRecord.js';
import { AuditLog } from '../src/entities/AuditLog.js';

const headersFor = (user: User) => ({ 'x-test-user': JSON.stringify(user) });

describe('API integration', () => {
  let vet: User;
  beforeEach(async () => {
    await AppDataSource.createQueryBuilder().delete().from(MedicationAdministrationRecord).execute();
    await AppDataSource.createQueryBuilder().delete().from(Order).execute();
    await AppDataSource.createQueryBuilder().delete().from(Encounter).execute();
    await AppDataSource.createQueryBuilder().delete().from(Patient).execute();
    await AppDataSource.createQueryBuilder().delete().from(AuditLog).execute();
    await AppDataSource.createQueryBuilder().delete().from(User).execute();
    const repo = AppDataSource.getRepository(User);
    vet = repo.create({ name: 'Vet', email: 'vet@example.com', roles: ['vet'], active: true, mfaEnabled: false });
    await repo.save(vet);
  });

  it('serves the inpatients home page from the root', async () => {
    const res = await request(app).get('/').expect(200);

    expect(res.headers['content-type']).toContain('text/html');
    expect(res.text).toContain('tab-inpatients');
    expect(res.text).toContain('Vet Holim');
  });

  it('creates patient and encounter, then order passes validation', async () => {
    const patientRepo = AppDataSource.getRepository(Patient);
    const encounterRepo = AppDataSource.getRepository(Encounter);
    const patient = patientRepo.create({ name: 'Rex', species: 'canine', allergies: ['beef'] });
    await patientRepo.save(patient);

    const encounterRes = await request(app)
      .post('/encounters')
      .set(headersFor(vet))
      .send({ patientId: patient.id, reason: 'checkup' })
      .expect(201);

    const encounterId = encounterRes.body.id;
    await request(app)
      .post('/orders')
      .set(headersFor(vet))
      .send({ encounterId, medication: 'amoxicillin', dose: '50mg', route: 'po' })
      .expect(201);
  });

  it('blocks order when allergy validation fails', async () => {
    const patientRepo = AppDataSource.getRepository(Patient);
    const patient = patientRepo.create({ name: 'Milo', species: 'feline', allergies: ['penicillin'] });
    await patientRepo.save(patient);
    const encounterRes = await request(app)
      .post('/encounters')
      .set(headersFor(vet))
      .send({ patientId: patient.id, reason: 'injury' })
      .expect(201);
    await request(app)
      .post('/orders')
      .set(headersFor(vet))
      .send({ encounterId: encounterRes.body.id, medication: 'penicillin', dose: '5mg' })
      .expect(400);
  });

  it('enqueues offline sync payload with backoff policy exposed', async () => {
    await request(app).get('/sync/backoff-policy').set(headersFor(vet)).expect(200);
    const syncRes = await request(app).post('/sync/enqueue').set(headersFor(vet)).send({ entity: 'patient', id: '1' });
    expect(syncRes.status).toBe(202);
    expect(syncRes.body.jobId).toBeDefined();
  });
});
