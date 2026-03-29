// cypress.config.js
// QIOS — Cypress project template
// Copy and adapt for your project

const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: process.env.BASE_URL || 'http://localhost:3000',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: false,
    screenshotOnRunFailure: true,
    defaultCommandTimeout: 8000,
    requestTimeout: 10000,
    responseTimeout: 10000,
    pageLoadTimeout: 30000,
    specPattern: 'cypress/e2e/**/*.cy.{js,ts}',
    supportFile: 'cypress/support/e2e.js',
    retries: {
      runMode: 2,
      openMode: 0,
    },
    setupNodeEvents(on, config) {
      return config;
    },
  },
  env: {
    API_URL:            process.env.API_URL            || 'http://localhost:4000',
    TEST_USER_EMAIL:    process.env.TEST_USER_EMAIL,
    TEST_USER_PASSWORD: process.env.TEST_USER_PASSWORD,
    ADMIN_EMAIL:        process.env.ADMIN_EMAIL,
    ADMIN_PASSWORD:     process.env.ADMIN_PASSWORD,
  },
});
