import { Queue, Worker } from 'bullmq';
import { getSyncBackoffPolicy } from '../config/syncConfig.js';
import { redis } from './lockService.js';
import { logger } from '../logger.js';

export const syncQueue = new Queue('offline-sync', { connection: redis });

const backoffStrategies = {
  'jittered-exponential': (attemptsMade: number) => {
    const policy = getSyncBackoffPolicy();
    const exponent = Math.max(attemptsMade - 1, 0);
    const idealDelay = Math.min(policy.maxMs, policy.baseMs * 2 ** exponent);
    if (!policy.jitter) return idealDelay;
    const jitterFactor = 0.5 + Math.random();
    return Math.min(policy.maxMs, Math.round(idealDelay * jitterFactor));
  }
};

new Worker(
  'offline-sync',
  async (job) => {
    logger.info({ jobId: job.id, type: job.name }, 'processing offline sync');
  },
  { connection: redis, settings: { backoffStrategies } }
).on('failed', (job, err) => logger.error({ jobId: job?.id, err }, 'sync job failed'));

export function scheduleSync(task: Record<string, unknown>) {
  const backoff = getSyncBackoffPolicy();
  return syncQueue.add('sync', task, {
    attempts: backoff.attempts,
    backoff: {
      type: 'jittered-exponential',
      delay: backoff.baseMs
    }
  });
}
