import express from 'express';
import pinoHttp from 'pino-http';
import { randomUUID } from 'crypto';
import path from 'path';
import { fileURLToPath } from 'url';
import { logger } from './logger.js';
import { authenticate, nonceMiddleware, verifyMfa } from './middleware/auth.js';
import { audit } from './middleware/audit.js';
import userRoutes from './routes/users.js';
import patientRoutes from './routes/patients.js';
import encounterRoutes from './routes/encounters.js';
import orderRoutes from './routes/orders.js';
import marRoutes from './routes/mar.js';
import syncRoutes from './routes/sync.js';
import { AppDataSource } from './db/data-source.js';
import { redis } from './queues/lockService.js';
import { getFeatureFlags } from './config/featureFlags.js';

export const app = express();
app.use(express.json());
app.use(
  pinoHttp({
    logger: logger as any,
    genReqId: (req) => req.headers['x-request-id'] || randomUUID()
  })
);

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const siteRoot = path.resolve(__dirname, '..', '..', 'web');

function serveSiteAsset(relativePath: string) {
  return (_req: express.Request, res: express.Response, next: express.NextFunction) => {
    const absolutePath = path.join(siteRoot, relativePath);
    res.sendFile(absolutePath, (err) => {
      if (err) next(err);
    });
  };
}

app.get('/.well-known/nonce', nonceMiddleware);
app.get('/health', (_req, res) => res.json({ status: 'ok' }));
app.get('/readiness', async (_req, res) => {
  const checks: Record<string, unknown> = {};
  try {
    checks.database = AppDataSource.isInitialized;
    if (AppDataSource.isInitialized) await AppDataSource.query('SELECT 1');
  } catch (err) {
    checks.database = (err as Error).message;
  }

  try {
    const pong = await redis.ping();
    checks.redis = pong === 'PONG';
  } catch (err) {
    checks.redis = (err as Error).message;
  }

  const healthy = Object.values(checks).every((value) => value === true);
  return res.status(healthy ? 200 : 503).json({ status: healthy ? 'ready' : 'degraded', checks });
});
app.get('/feature-flags', (_req, res) => {
  res.json({ flags: getFeatureFlags() });
});

app.get('/', serveSiteAsset('index.html'));
app.get(['/app.js', '/styles.css'], (req, res, next) => serveSiteAsset(req.path.slice(1))(req, res, next));

app.use(authenticate, verifyMfa, audit);
app.use('/users', userRoutes);
app.use('/patients', patientRoutes);
app.use('/encounters', encounterRoutes);
app.use('/orders', orderRoutes);
app.use('/mar', marRoutes);
app.use('/sync', syncRoutes);
