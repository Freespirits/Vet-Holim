process.env.NODE_ENV = 'test';
process.env.USE_IN_MEMORY_DB = 'true';

jest.mock('ioredis', () => require('ioredis-mock'));

import type { DataSource } from 'typeorm';

let AppDataSource: DataSource;

beforeAll(async () => {
  if (!AppDataSource) {
    ({ AppDataSource } = await import('../src/db/data-source.js'));
  }
  if (!AppDataSource.isInitialized) {
    await AppDataSource.initialize();
  }
});

afterAll(async () => {
  if (AppDataSource?.isInitialized) await AppDataSource.destroy();
});
