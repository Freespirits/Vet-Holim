module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint', 'import'],
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended', 'plugin:import/recommended', 'prettier'],
  env: {
    node: true,
    jest: true,
    es2020: true
  },
  rules: {
    'import/no-unresolved': 'off'
  }
};
