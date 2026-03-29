// cypress/support/commands.js
// QIOS — cypress-test-bootstrap
// Custom reusable Cypress commands

// ─────────────────────────────────────────────────────────────
// AUTHENTICATION
// ─────────────────────────────────────────────────────────────

/**
 * Login via API — bypasses UI for speed and reliability.
 * Stores token in localStorage for subsequent authenticated requests.
 */
Cypress.Commands.add('login', (email, password) => {
  cy.request({
    method: 'POST',
    url: `${Cypress.env('API_URL')}/auth/login`,
    body: { email, password },
    failOnStatusCode: true,
  }).then(({ body }) => {
    window.localStorage.setItem('token', body.token);
    if (body.user_id) {
      window.localStorage.setItem('user_id', body.user_id);
    }
  });
});

/**
 * Login as admin user.
 */
Cypress.Commands.add('loginAsAdmin', () => {
  cy.login(Cypress.env('ADMIN_EMAIL'), Cypress.env('ADMIN_PASSWORD'));
});

/**
 * Logout — clear localStorage and redirect to login page.
 */
Cypress.Commands.add('logout', () => {
  window.localStorage.clear();
  cy.visit('/login');
});

// ─────────────────────────────────────────────────────────────
// API REQUESTS
// ─────────────────────────────────────────────────────────────

/**
 * Make an authenticated API request.
 * Returns the full Cypress request chain.
 * failOnStatusCode: false — allows testing error responses.
 */
Cypress.Commands.add('apiRequest', (method, path, body = {}) => {
  const token = window.localStorage.getItem('token');
  return cy.request({
    method,
    url: `${Cypress.env('API_URL')}${path}`,
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body,
    failOnStatusCode: false,
  });
});

/**
 * Make an unauthenticated API request.
 * Used for testing 401 scenarios.
 */
Cypress.Commands.add('apiRequestUnauthenticated', (method, path, body = {}) => {
  return cy.request({
    method,
    url: `${Cypress.env('API_URL')}${path}`,
    headers: { 'Content-Type': 'application/json' },
    body,
    failOnStatusCode: false,
  });
});

// ─────────────────────────────────────────────────────────────
// DATA SETUP / TEARDOWN
// ─────────────────────────────────────────────────────────────

/**
 * Create a test user via API.
 * Returns the created user object.
 */
Cypress.Commands.add('createTestUser', (userData = {}) => {
  return cy.apiRequest('POST', '/users', {
    email: userData.email || `test_${Date.now()}@example.test`,
    password: userData.password || 'Test@Qios1234',
    role: userData.role || 'user',
    ...userData,
  });
});

/**
 * Wait for an element to be visible (alias for readability).
 */
Cypress.Commands.add('waitFor', (selector) => {
  cy.get(selector).should('be.visible');
});
