import { env } from './env.js';

export type BackoffPolicy = {
  strategy: 'jittered-exponential';
  baseMs: number;
  maxMs: number;
  attempts: number;
  jitter: boolean;
};

export function getSyncBackoffPolicy(): BackoffPolicy {
  return {
    strategy: 'jittered-exponential',
    baseMs: env.offlineBackoffBaseMs,
    maxMs: env.offlineBackoffMaxMs,
    attempts: env.offlineBackoffAttempts,
    jitter: env.offlineBackoffJitter
  };
}
