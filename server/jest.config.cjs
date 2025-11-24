/** @type {import('jest').Config} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  moduleFileExtensions: ['ts', 'js'],
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  extensionsToTreatAsEsm: ['.ts'],
  globals: {
    'ts-jest': {
      useESM: true
    }
  }
};
