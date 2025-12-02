import { jest } from '@jest/globals';
import { EventEmitter } from 'events';

const createMockStream = () => {
  const stream = new EventEmitter();
  // @ts-expect-error minimal interface for test double
  stream.setEncoding = () => {};
  return stream as unknown as NodeJS.ReadableStream;
};

const createMockChild = () => {
  const stdout = createMockStream();
  const stderr = createMockStream();
  const child = new EventEmitter() as unknown as import('child_process').ChildProcessWithoutNullStreams;
  const stdin = { end: jest.fn() } as unknown as NodeJS.WritableStream;
  child.stdout = stdout;
  child.stderr = stderr;
  child.stdin = stdin;
  return { child, stdout, stderr };
};

describe('order validation without dart binary', () => {
  const originalExecutable = process.env.DART_EXECUTABLE;

  afterEach(async () => {
    process.env.DART_EXECUTABLE = originalExecutable;
    jest.resetModules();
  });

  it('applies zero-dose rule when dart binary is unavailable', async () => {
    process.env.DART_EXECUTABLE = 'nonexistent-dart';
    jest.resetModules();
    const { validateOrder } = await import('../src/services/validation/index.js');

    const result = await validateOrder({ allergies: [], medication: 'carprofen', dose: '0mg' });

    expect(result.safe).toBe(false);
    expect(result.warnings).toContain('zero-dose');
  });
});

describe('dart validator parse errors', () => {
  const originalExecutable = process.env.DART_EXECUTABLE;
  const originalValidatorPath = process.env.DART_VALIDATOR_PATH;

  afterEach(async () => {
    process.env.DART_EXECUTABLE = originalExecutable;
    process.env.DART_VALIDATOR_PATH = originalValidatorPath;
    jest.resetModules();
    jest.clearAllMocks();
  });

  it('surfaces stdout/stderr when dart output is not valid JSON', async () => {
    process.env.DART_EXECUTABLE = 'node';
    process.env.DART_VALIDATOR_PATH = '/fake/dart/validator.dart';

    const { child, stdout, stderr } = createMockChild();

    jest.unstable_mockModule('child_process', () => ({
      spawn: () => child
    }));

    const { runDartValidation } = await import('../src/services/validation/dartBridge.js');

    const validationPromise = runDartValidation({ allergies: [], medication: 'test-med' });

    stdout.emit('data', 'not-json');
    stderr.emit('data', 'syntax error at line 1');
    child.emit('close', 0);

    await expect(validationPromise).rejects.toThrow(/Failed to parse dart validator output/i);
    await expect(validationPromise).rejects.toThrow(/stdout="not-json"/i);
    await expect(validationPromise).rejects.toThrow(/stderr="syntax error at line 1"/i);
  });
});
