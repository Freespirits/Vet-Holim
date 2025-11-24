jest.mock('ioredis', () => require('ioredis-mock'));

import { AppDataSource } from '../src/db/data-source.js';

process.env.NODE_ENV = 'test';

beforeAll(async () => {
  if (!AppDataSource.isInitialized) {
    await AppDataSource.initialize();
  }
});

afterAll(async () => {
  if (AppDataSource.isInitialized) await AppDataSource.destroy();
});
