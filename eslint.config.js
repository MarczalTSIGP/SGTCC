export default [
  {
    files: ['**/*.js'],
    ignores: ['utils.old/**', 'initializers.old/**'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        document: 'readonly',
        window: 'readonly',
        navigator: 'readonly'
      }
    },
    rules: {
      semi: ['error', 'always'],
      quotes: ['error', 'double'],
      'no-unused-vars': 'warn',
      'no-console': 'off'
    }
  }
];
