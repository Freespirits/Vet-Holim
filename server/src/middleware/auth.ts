import { createRemoteJWKSet, jwtVerify } from 'jose';
import { generators } from 'openid-client';
import { totp } from 'otplib';
import type { Request, Response, NextFunction } from 'express';
import { env } from '../config/env.js';
import { hasPermission, type Permission } from '../utils/rbac.js';
import { AppDataSource } from '../db/data-source.js';
import { User } from '../entities/User.js';

export type AuthenticatedRequest = Request & { user?: User };

let jwks: ReturnType<typeof createRemoteJWKSet> | null = null;

async function ensureJwks() {
  if (!jwks) {
    jwks = createRemoteJWKSet(new URL(`${env.oidcIssuer}/.well-known/jwks.json`));
  }
  return jwks;
}

export async function authenticate(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  if (process.env.NODE_ENV === 'test' && req.headers['x-test-user']) {
    req.user = JSON.parse(String(req.headers['x-test-user'])) as User;
    return next();
  }
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Missing bearer token' });
    }
    const token = authHeader.slice(7);
    const jwksClient = await ensureJwks();
    const { payload } = await jwtVerify(token, jwksClient, {
      issuer: env.oidcIssuer,
      audience: env.oidcClientId
    });
    const repo = AppDataSource.getRepository(User);
    const user = await repo.findOne({ where: { email: String(payload.email) } });
    if (!user) return res.status(401).json({ error: 'Unknown user' });
    req.user = user;
    return next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token', details: (err as Error).message });
  }
}

export function requirePermission(permission: Permission) {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (!req.user) return res.status(401).json({ error: 'Unauthenticated' });
    if (!hasPermission(req.user.roles, permission)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    return next();
  };
}

export function verifyMfa(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  if (!req.user?.mfaEnabled) return next();
  const code = req.headers['x-mfa-code'];
  if (!code || typeof code !== 'string' || !req.user.mfaSecret) {
    return res.status(401).json({ error: 'MFA required' });
  }
  const valid = totp.check(code, req.user.mfaSecret);
  if (!valid) return res.status(401).json({ error: 'Invalid MFA code' });
  return next();
}

export function nonceMiddleware(req: Request, res: Response) {
  const nonce = generators.nonce();
  res.json({ nonce });
}
