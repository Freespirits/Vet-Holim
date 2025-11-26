import Redis from 'ioredis';
import RedisMock from 'ioredis-mock';
import { env } from '../config/env.js';

export const redis: Redis = env.useMockRedis ? new (RedisMock as typeof Redis)() : new Redis(env.redisUrl);

export async function withLock(key: string, ttlMs: number, task: () => Promise<unknown>) {
  const lockKey = `lock:${key}`;
  const acquired = await redis.set(lockKey, '1', 'PX', ttlMs, 'NX');
  if (!acquired) throw new Error('Resource locked');
  try {
    return await task();
  } finally {
    await redis.del(lockKey);
  }
}
