import express from 'express';
import pinoHttp from 'pino-http';
import { logger } from './logger.js';
import { authenticate, nonceMiddleware, verifyMfa } from './middleware/auth.js';
import { audit } from './middleware/audit.js';
import userRoutes from './routes/users.js';
import patientRoutes from './routes/patients.js';
import encounterRoutes from './routes/encounters.js';
import orderRoutes from './routes/orders.js';
import marRoutes from './routes/mar.js';
import syncRoutes from './routes/sync.js';

export const app = express();
app.use(express.json());
app.use(pinoHttp({ logger }));

app.get('/.well-known/nonce', nonceMiddleware);

app.use(authenticate, verifyMfa, audit);
app.use('/users', userRoutes);
app.use('/patients', patientRoutes);
app.use('/encounters', encounterRoutes);
app.use('/orders', orderRoutes);
app.use('/mar', marRoutes);
app.use('/sync', syncRoutes);

app.get('/health', (_req, res) => res.json({ status: 'ok' }));
