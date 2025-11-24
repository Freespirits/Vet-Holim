import { Router } from 'express';
import { AppDataSource } from '../db/data-source.js';
import { Encounter } from '../entities/Encounter.js';
import { Order } from '../entities/Order.js';
import { User } from '../entities/User.js';
import { requirePermission, type AuthenticatedRequest } from '../middleware/auth.js';
import { validateOrder } from '../services/validation/index.js';
import { withLock } from '../queues/lockService.js';

const router = Router();
const orderRepo = () => AppDataSource.getRepository(Order);
const encounterRepo = () => AppDataSource.getRepository(Encounter);
const userRepo = () => AppDataSource.getRepository(User);

router.post('/', requirePermission('order.create'), async (req: AuthenticatedRequest, res) => {
  const encounter = await encounterRepo().findOne({ where: { id: req.body.encounterId }, relations: ['patient'] });
  const prescriber = req.user ? await userRepo().findOneByOrFail({ id: req.user.id }) : null;
  if (!encounter || !prescriber) return res.status(404).json({ error: 'Encounter or prescriber missing' });
  const validation = await validateOrder({
    allergies: encounter.patient.allergies,
    medication: req.body.medication,
    weightKg: encounter.patient.weightKg,
    dose: req.body.dose
  });
  if (!validation.safe) return res.status(400).json({ error: 'Validation failed', warnings: validation.warnings });

  const created = orderRepo().create({
    encounter,
    prescriber,
    medication: req.body.medication,
    dose: req.body.dose,
    route: req.body.route,
    status: 'pending approval',
    schedule: req.body.schedule || {}
  });
  await orderRepo().save(created);
  res.status(201).json(created);
});

router.post('/:id/approve', requirePermission('order.approve'), async (req, res) => {
  const order = await orderRepo().findOne({ where: { id: req.params.id }, relations: ['encounter', 'encounter.patient'] });
  if (!order) return res.status(404).json({ error: 'Not found' });
  await withLock(`order:${order.id}`, 10000, async () => {
    order.status = 'active';
    await orderRepo().save(order);
  });
  res.json(order);
});

export default router;
