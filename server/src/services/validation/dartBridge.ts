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

class DartValidationParseError extends Error {
  constructor(
    context: DartExecutionContext,
    stdout: string,
    stderr: string,
    exitCode?: number | null,
    signal?: NodeJS.Signals | null
  ) {
    const summary = buildContextSummary(context, stdout, stderr, exitCode, signal);
    super(`Failed to parse dart validator output${summary ? ` (${summary})` : ''}`);
    this.name = 'DartValidationParseError';
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

const summarizeField = (label: string, value?: string | null) => {
  if (!value) return '';
  const compactValue = value.trim().replace(/\s+/g, ' ').slice(0, 120);
  return compactValue ? `${label}="${compactValue}"` : '';
};

const buildContextSummary = (
  context: DartExecutionContext,
  stdout: string,
  stderr: string,
  exitCode?: number | null,
  signal?: NodeJS.Signals | null
) =>
  [
    summarizeField('validator', context.dartPath),
    summarizeField('executable', context.executable),
    exitCode !== undefined && exitCode !== null ? `exit=${exitCode}` : '',
    signal ? `signal=${signal}` : '',
    summarizeField('stdout', stdout),
    summarizeField('stderr', stderr)
  ]
    .filter(Boolean)
    .join('; ');

const collectDartResult = (
  child: ChildProcessWithoutNullStreams,
  payload: ValidationInput,
  context: DartExecutionContext
) =>
  new Promise<{ safe: boolean; warnings: string[] }>((resolvePromise, reject) => {
    const buffer = { stdout: '', stderr: '' };
    const rejectWithParseError = (exitCode?: number | null, signal?: NodeJS.Signals | null) => {
      const err = new DartValidationParseError(context, buffer.stdout, buffer.stderr, exitCode, signal);
      logger.warn({ err }, 'Failed to parse dart validator output, falling back');
      reject(err);
    };
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
    child.once('close', (code, signal) => {
      if (buffer.stderr) logger.warn({ stderr: buffer.stderr }, 'dart validator stderr');
      if (code !== null && code !== 0) return rejectWithParseError(code, signal);
      try {
        resolvePromise(JSON.parse(buffer.stdout));
      } catch (err) {
        rejectWithParseError(code, signal);
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
