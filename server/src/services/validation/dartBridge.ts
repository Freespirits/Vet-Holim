import { spawn, type ChildProcessWithoutNullStreams } from 'child_process';
import { existsSync } from 'fs';
import { dirname, join, delimiter } from 'path';
import { fileURLToPath } from 'url';
import { env } from '../../config/env.js';
import { logger } from '../../logger.js';

class DartExecutableNotFoundError extends Error {
  constructor(executable: string, validatorPath: string, cwd: string) {
    super(`dart executable "${executable}" not found while running validator "${validatorPath}" from "${cwd}"`);
    this.name = 'DartExecutableNotFoundError';
  }

  toString() {
    return `⚠️ ${this.name}: ${this.message}`;
  }
}

const isExecutableOnPath = (executable: string) => {
  if (executable.includes('/') || executable.includes('\\')) return existsSync(executable);
  const pathEntries = process.env.PATH?.split(delimiter) || [];
  return pathEntries.some((entry) => existsSync(join(entry, executable)));
};

export type ValidationInput = {
  allergies: string[];
  medication: string;
  weightKg?: number;
  dose?: string;
};

type DartExecutionContext = { executable: string; dartPath: string; cwd: string };

const collectDartResult = (
  child: ChildProcessWithoutNullStreams,
  payload: ValidationInput,
  context: DartExecutionContext
) =>
  new Promise<{ safe: boolean; warnings: string[] }>((resolvePromise, reject) => {
    const buffer = { stdout: '', stderr: '' };
    (['stdout', 'stderr'] as const).forEach((key) => {
      child[key].setEncoding('utf8');
      child[key].on('data', (chunk: string) => {
        buffer[key] += chunk;
      });
    });
    child.once('error', (err) => {
      logger.warn({ err, ...context }, 'Failed to invoke dart validator, falling back');
      reject(err);
    });
    child.once('close', () => {
      if (buffer.stderr) logger.warn({ stderr: buffer.stderr }, 'dart validator stderr');
      try {
        resolvePromise(JSON.parse(buffer.stdout));
      } catch (err) {
        reject(err);
      }
    });
    child.stdin.end(JSON.stringify(payload));
  });

export function runDartValidation(payload: ValidationInput) {
  const context: DartExecutionContext = {
    executable: env.dartExecutable,
    dartPath: env.dartValidatorPath,
    cwd: dirname(fileURLToPath(new URL('../../../shared/dart/validation', import.meta.url)))
  };

  if (!isExecutableOnPath(context.executable)) {
    const err = new DartExecutableNotFoundError(context.executable, context.dartPath, context.cwd);
    logger.warn({ err }, 'Failed to invoke dart validator, falling back');
    return Promise.reject(err);
  }

  const child = spawn(context.executable, ['run', context.dartPath], { cwd: context.cwd });
  return collectDartResult(child, payload, context);
}
