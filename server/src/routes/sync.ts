import { Router } from 'express';
import { scheduleSync } from '../queues/syncQueue.js';
import { requirePermission } from '../middleware/auth.js';

const router = Router();

router.post('/enqueue', requirePermission('patient.write'), async (req, res) => {
  const job = await scheduleSync({ payload: req.body });
  res.status(202).json({ jobId: job.id });
});

router.get('/backoff-policy', (_req, res) => {
  res.json({ strategy: 'exponential', jitter: true });
});

export default router;
