// cypress.config.js
// QIOS — cypress-test-bootstrap

const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    // Base URL — set via environment variable or .env
    baseUrl: process.env.BASE_URL || 'http://localhost:3000',

    // Viewport
    viewportWidth: 1280,
    viewportHeight: 720,

    // Artifacts
    video: false,
    screenshotOnRunFailure: true,

    // Timeouts
    defaultCommandTimeout: 8000,
    requestTimeout: 10000,
    responseTimeout: 10000,
    pageLoadTimeout: 30000,

    // Test file pattern
    specPattern: 'cypress/e2e/**/*.cy.{js,ts}',
    supportFile: 'cypress/support/e2e.js',

    // Retry on failure during headless runs
    retries: {
      runMode: 2,     // in headless mode (cypress run)
      openMode: 0,    // in interactive mode (cypress open)
    },

    setupNodeEvents(on, config) {
      // Add plugins here if needed
      return config;
    },
  },

  env: {
    // API base URL
    API_URL: process.env.API_URL || 'http://localhost:4000',

    // Test user credentials (set in .env or a secure secret store — never hardcode)
    TEST_USER_EMAIL:    process.env.TEST_USER_EMAIL,
    TEST_USER_PASSWORD: process.env.TEST_USER_PASSWORD,
    ADMIN_EMAIL:        process.env.ADMIN_EMAIL,
    ADMIN_PASSWORD:     process.env.ADMIN_PASSWORD,
  },
});
