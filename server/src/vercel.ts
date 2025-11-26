import { app } from './app.js';
import { AppDataSource } from './db/data-source.js';
import { logger } from './logger.js';
import { shutdownTelemetry, startTelemetry } from './telemetry.js';
import type { NodeSDK } from '@opentelemetry/sdk-node';
import { env } from './config/env.js';

let telemetryReady: Promise<NodeSDK | void> | null = null;
let dataSourceReady: Promise<void> | null = null;
let shutdownHookRegistered = false;

async function ensureTelemetry() {
  if (telemetryReady) return telemetryReady;
  telemetryReady = startTelemetry().catch((err) => {
    logger.warn({ err }, 'Telemetry failed to start in serverless environment');
  });
  return telemetryReady;
}

async function ensureDataSource() {
  if (AppDataSource.isInitialized) return AppDataSource;
  if (!dataSourceReady) {
    dataSourceReady = AppDataSource.initialize().catch((err) => {
      dataSourceReady = null;
      throw err;
    }) as unknown as Promise<void>;
  }
  return dataSourceReady;
}

// Vercel serverless handler: initialize dependencies once and delegate to Express.
export default async function handler(req: any, res: any) {
  try {
    await Promise.all([ensureTelemetry(), ensureDataSource()]);
    if (!shutdownHookRegistered) {
      process.on('beforeExit', shutdownTelemetry);
      shutdownHookRegistered = true;
    }
    try {
      const dbHost = new URL(env.databaseUrl).hostname;
      const redisHost = env.redisUrl ? new URL(env.redisUrl).hostname : 'mock';
      logger.info(
        { dbHost, redisHost, useMockRedis: env.useMockRedis, disableBackgroundWorkers: env.disableBackgroundWorkers },
        'serverless handler env'
      );
    } catch (envErr) {
      logger.warn({ err: envErr }, 'failed to log env hosts');
    }
    return (app as any)(req, res);
  } catch (err) {
    logger.error({ err }, 'Failed to handle serverless request');
    res.status(500).json({ error: 'server_initialization_failed' });
  }
}
