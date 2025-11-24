import { app } from './app.js';
import { AppDataSource } from './db/data-source.js';
import { env } from './config/env.js';
import { logger } from './logger.js';
import './queues/syncQueue.js';

AppDataSource.initialize()
  .then(() => {
    app.listen(env.port, () => logger.info({ port: env.port }, 'API listening'));
  })
  .catch((err) => {
    logger.error({ err }, 'Failed to start server');
    process.exit(1);
  });
