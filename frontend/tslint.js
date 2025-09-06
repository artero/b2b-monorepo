module.exports = {
  linterOptions: {
    exclude: ['**/app/i18n/*.ts']
  },
  extends: '@marsbased/marstyle-angular',
  rules: {
    // Codelyzer
    'no-host-metadata-property': [false],
    //'component-selector': [true, 'attribute', 'nvs', 'kebab-case'],
    'directive-selector': [true, 'attribute', 'nvs', 'camelCase'],

    // TSLint
    'max-classes-per-file': [false],
    'no-import-side-effect': [true, 'hammerjs'],
    'no-implicit-dependencies': [false],

    // TSLint Microsoft Contrib
    'mocha-no-side-effect-code': [false]
  }
};
