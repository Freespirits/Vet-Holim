import pino from 'pino';
import { env } from './config/env.js';

export const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  base: {
    service: env.serviceName,
    environment: env.environment
  },
  transport: process.env.NODE_ENV !== 'production' ? { target: 'pino-pretty' } : undefined
});
