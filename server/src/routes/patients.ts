import { Router } from 'express';
import { AppDataSource } from '../db/data-source.js';
import { Patient } from '../entities/Patient.js';
import { requirePermission } from '../middleware/auth.js';

const router = Router();
const repo = () => AppDataSource.getRepository(Patient);

router.get('/', requirePermission('patient.read'), async (_req, res) => {
  res.json(await repo().find());
});

router.post('/', requirePermission('patient.write'), async (req, res) => {
  const patient = repo().create(req.body as Patient);
  await repo().save(patient);
  res.status(201).json(patient);
});

export default router;
