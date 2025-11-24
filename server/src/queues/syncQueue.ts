import { Queue, Worker } from 'bullmq';
import { env } from '../config/env.js';
import { redis } from './lockService.js';
import { logger } from '../logger.js';

export const syncQueue = new Queue('offline-sync', { connection: redis as any });

new Worker(
  'offline-sync',
  async (job) => {
    logger.info({ jobId: job.id, type: job.name }, 'processing offline sync');
  },
  { connection: redis as any }
).on('failed', (job, err) => logger.error({ jobId: job?.id, err }, 'sync job failed'));

export function scheduleSync(task: Record<string, unknown>) {
  return syncQueue.add('sync', task, {
    attempts: 5,
    backoff: {
      type: 'exponential',
      delay: env.offlineBackoffBaseMs
    }
  });
}
