import { Router } from 'express';
import { AppDataSource } from '../db/data-source.js';
import { MedicationAdministrationRecord } from '../entities/MedicationAdministrationRecord.js';
import { Order } from '../entities/Order.js';
import { requirePermission, type AuthenticatedRequest } from '../middleware/auth.js';

const router = Router();
const marRepo = () => AppDataSource.getRepository(MedicationAdministrationRecord);
const orderRepo = () => AppDataSource.getRepository(Order);

router.post('/', requirePermission('mar.record'), async (req: AuthenticatedRequest, res) => {
  const order = await orderRepo().findOne({ where: { id: req.body.orderId }, relations: ['encounter', 'encounter.patient'] });
  if (!order) return res.status(404).json({ error: 'Order missing' });
  const mar = marRepo().create({
    order,
    administeredBy: req.user!,
    doseGiven: req.body.doseGiven,
    site: req.body.site,
    reason: req.body.reason,
    overrideRequired: req.body.overrideRequired || false
  });
  await marRepo().save(mar);
  res.status(201).json(mar);
});

export default router;
