import { spawn } from 'child_process';
import { dirname } from 'path';
import { fileURLToPath } from 'url';
import { env } from '../../config/env.js';
import { logger } from '../../logger.js';

export type ValidationInput = {
  allergies: string[];
  medication: string;
  weightKg?: number;
  dose?: string;
};

export function runDartValidation(payload: ValidationInput): Promise<{ safe: boolean; warnings: string[] }> {
  return new Promise((resolvePromise, reject) => {
    const dartPath = env.dartValidatorPath;
    const cwd = dirname(fileURLToPath(new URL('../../../shared/dart/validation', import.meta.url)));
    const child = spawn('dart', ['run', dartPath], { cwd });
    let stdout = '';
    let stderr = '';
    child.stdout.on('data', (data) => {
      stdout += data.toString();
    });
    child.stderr.on('data', (data) => {
      stderr += data.toString();
    });
    child.on('error', (err) => {
      logger.warn({ err }, 'Failed to invoke dart validator, falling back');
      reject(err);
    });
    child.on('close', () => {
      if (stderr) logger.warn({ stderr }, 'dart validator stderr');
      try {
        const result = JSON.parse(stdout);
        resolvePromise(result);
      } catch (err) {
        reject(err);
      }
    });
    child.stdin.write(JSON.stringify(payload));
    child.stdin.end();
  });
}
