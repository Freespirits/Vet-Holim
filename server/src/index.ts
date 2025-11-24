import { app } from './app.js';
import { AppDataSource } from './db/data-source.js';
import { env } from './config/env.js';
import { logger } from './logger.js';
import './queues/syncQueue.js';
import { shutdownTelemetry, startTelemetry } from './telemetry.js';

async function bootstrap() {
  try {
    await startTelemetry();
  } catch (err) {
    logger.warn({ err }, 'Telemetry failed to start, continuing without exporter');
  }
  await AppDataSource.initialize();
  const server = app.listen(env.port, () => logger.info({ port: env.port }, 'API listening'));

  const shutdown = async () => {
    logger.info('Shutting down server');
    server.close();
    await shutdownTelemetry();
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);
}

bootstrap().catch((err) => {
  logger.error({ err }, 'Failed to start server');
  process.exit(1);
});
