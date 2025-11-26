import { jest } from '@jest/globals';

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
