import { jest } from '@jest/globals';

describe('sync backoff policy env overrides', () => {
  const originalBase = process.env.OFFLINE_BACKOFF_MS;
  const originalExplicitBase = process.env.OFFLINE_BACKOFF_BASE_MS;

  afterEach(() => {
    process.env.OFFLINE_BACKOFF_MS = originalBase;
    process.env.OFFLINE_BACKOFF_BASE_MS = originalExplicitBase;
    jest.resetModules();
  });

  it('prefers OFFLINE_BACKOFF_BASE_MS when provided', async () => {
    process.env.OFFLINE_BACKOFF_MS = '1000';
    process.env.OFFLINE_BACKOFF_BASE_MS = '2500';
    jest.resetModules();
    const { getSyncBackoffPolicy } = await import('../src/config/syncConfig.js');

    const policy = getSyncBackoffPolicy();

    expect(policy.baseMs).toBe(2500);
  });
});
