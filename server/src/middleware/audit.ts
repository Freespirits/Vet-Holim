import type { Request, Response, NextFunction } from 'express';
import { AppDataSource } from '../db/data-source.js';
import { AuditLog } from '../entities/AuditLog.js';
import type { AuthenticatedRequest } from './auth.js';

export async function audit(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  const start = Date.now();
  res.on('finish', async () => {
    if (!req.user) return;
    const repo = AppDataSource.getRepository(AuditLog);
    await repo.save({
      actorId: req.user.id,
      action: `${req.method} ${req.path}`,
      metadata: { status: res.statusCode, durationMs: Date.now() - start },
      ipAddress: req.ip
    });
  });
  next();
}
