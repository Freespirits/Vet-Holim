import { Router } from 'express';
import { scheduleSync } from '../queues/syncQueue.js';
import { requirePermission } from '../middleware/auth.js';
import { getSyncBackoffPolicy } from '../config/syncConfig.js';

const router = Router();

router.post('/enqueue', requirePermission('patient.write'), async (req, res) => {
  const job = await scheduleSync({ payload: req.body });
  res.status(202).json({ jobId: job.id });
});

router.get('/backoff-policy', (_req, res) => {
  const policy = getSyncBackoffPolicy();
  res.json({
    strategy: policy.strategy,
    jitter: policy.jitter,
    baseMs: policy.baseMs,
    maxMs: policy.maxMs,
    attempts: policy.attempts
  });
});

export default router;
