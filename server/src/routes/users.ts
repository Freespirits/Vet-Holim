import { Router } from 'express';
import { AppDataSource } from '../db/data-source.js';
import { User } from '../entities/User.js';
import { requirePermission } from '../middleware/auth.js';
import type { AuthenticatedRequest } from '../middleware/auth.js';

const router = Router();
const repo = () => AppDataSource.getRepository(User);

router.get('/', requirePermission('audit.view'), async (_req, res) => {
  const users = await repo().find();
  res.json(users);
});

router.post('/', requirePermission('audit.view'), async (req: AuthenticatedRequest, res) => {
  const user = repo().create(req.body as User);
  await repo().save(user);
  res.status(201).json(user);
});

export default router;
