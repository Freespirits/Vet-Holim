import { Router } from 'express';
import { AppDataSource } from '../db/data-source.js';
import { Encounter } from '../entities/Encounter.js';
import { Patient } from '../entities/Patient.js';
import { requirePermission } from '../middleware/auth.js';
import type { AuthenticatedRequest } from '../middleware/auth.js';

const router = Router();
const encounterRepo = () => AppDataSource.getRepository(Encounter);
const patientRepo = () => AppDataSource.getRepository(Patient);

router.post('/', requirePermission('encounter.create'), async (req: AuthenticatedRequest, res) => {
  const patient = await patientRepo().findOne({ where: { id: req.body.patientId } });
  if (!patient) return res.status(404).json({ error: 'Patient missing' });
  const encounter = encounterRepo().create({
    patient,
    reason: req.body.reason,
    status: 'open',
    assignedTeamMember: req.user
  });
  await encounterRepo().save(encounter);
  res.status(201).json(encounter);
});

router.post('/:id/close', requirePermission('encounter.close'), async (req, res) => {
  const encounter = await encounterRepo().findOne({ where: { id: req.params.id } });
  if (!encounter) return res.status(404).json({ error: 'Not found' });
  encounter.status = 'closed';
  await encounterRepo().save(encounter);
  res.json(encounter);
});

export default router;
