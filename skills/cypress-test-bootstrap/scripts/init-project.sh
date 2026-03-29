#!/bin/bash
# init-project.sh
# QIOS — cypress-test-bootstrap
#
# Usage: bash init-project.sh [project-name]
# Scaffolds a complete, production-ready Cypress project.

set -e

PROJECT=${1:-"cypress-tests"}

echo ""
echo "🚀 QIOS — Scaffolding Cypress project: $PROJECT"
echo "──────────────────────────────────────────────"

# ─── Directories ─────────────────────────────────────────────
mkdir -p "$PROJECT"/cypress/{e2e/wallet,fixtures,support,pages}

# ─── cypress.config.js ───────────────────────────────────────
cat > "$PROJECT/cypress.config.js" << 'EOF'
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
    specPattern: 'cypress/e2e/**/*.cy.{js,ts}',
    supportFile: 'cypress/support/e2e.js',
    retries: {
      runMode: 2,
      openMode: 0,
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
EOF

# ─── package.json ────────────────────────────────────────────
cat > "$PROJECT/package.json" << 'EOF'
{
  "name": "cypress-tests",
  "version": "1.0.0",
  "description": "E2E test suite — scaffolded by QIOS",
  "scripts": {
    "cy:open":       "cypress open",
    "cy:run":        "cypress run",
    "cy:smoke":      "cypress run --env tags=smoke",
    "cy:regression": "cypress run --env tags=regression",
    "cy:security":   "cypress run --env tags=security"
  },
  "devDependencies": {
    "cypress": "^13.0.0"
  }
}
EOF

# ─── .env.example ────────────────────────────────────────────
cat > "$PROJECT/.env.example" << 'EOF'
# Application URLs
BASE_URL=http://localhost:3000
API_URL=http://localhost:4000

# Test user credentials
TEST_USER_EMAIL=test@example.com
TEST_USER_PASSWORD=Test@1234

# Admin credentials
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=Admin@1234
EOF

# ─── .gitignore ──────────────────────────────────────────────
cat > "$PROJECT/.gitignore" << 'EOF'
node_modules/
cypress/videos/
cypress/screenshots/
cypress/downloads/
.env
cypress.env.json
EOF

# ─── cypress/support/e2e.js ──────────────────────────────────
cat > "$PROJECT/cypress/support/e2e.js" << 'EOF'
// Global setup — runs before all tests
import './commands';

// Suppress uncaught exception errors from the app under test
// Remove this line if you want Cypress to fail on uncaught exceptions
Cypress.on('uncaught:exception', () => false);
EOF

# ─── cypress/support/api-helpers.js ──────────────────────────
cat > "$PROJECT/cypress/support/api-helpers.js" << 'EOF'
// Shared API helper functions — scaffolded by QIOS

export const apiUrl = (path) => `${Cypress.env('API_URL')}${path}`;

export const jsonHeaders = {
  'Content-Type': 'application/json',
};

export const authHeaders = (token) => ({
  Authorization: `Bearer ${token}`,
  ...jsonHeaders,
});
EOF

# ─── cypress/support/commands.js ─────────────────────────────
cat > "$PROJECT/cypress/support/commands.js" << 'EOF'
// Custom Cypress commands — scaffolded by QIOS

import { apiUrl, authHeaders } from './api-helpers';

Cypress.Commands.add('login', (email, password) => {
  cy.request({
    method: 'POST',
    url: apiUrl('/auth/login'),
    body: { email, password },
    failOnStatusCode: true,
  }).then(({ body }) => {
    window.localStorage.setItem('token', body.token);
    if (body.user_id) window.localStorage.setItem('user_id', body.user_id);
  });
});

Cypress.Commands.add('loginAsAdmin', () => {
  cy.login(Cypress.env('ADMIN_EMAIL'), Cypress.env('ADMIN_PASSWORD'));
});

Cypress.Commands.add('apiRequest', (method, path, body = {}) => {
  const token = window.localStorage.getItem('token');
  return cy.request({
    method,
    url: apiUrl(path),
    headers: authHeaders(token),
    body,
    failOnStatusCode: false,
  });
});
EOF

# ─── cypress/pages/TransferPage.js ───────────────────────────
cat > "$PROJECT/cypress/pages/TransferPage.js" << 'EOF'
// Page Object for the transfer screen — scaffolded by QIOS

class TransferPage {
  get amountInput()    { return cy.get('[data-testid="amount-input"]'); }
  get recipientInput() { return cy.get('[data-testid="recipient-input"]'); }
  get submitButton()   { return cy.get('[data-testid="transfer-btn"]'); }
  get successMessage() { return cy.get('[data-testid="success-message"]'); }
  get errorMessage()   { return cy.get('[data-testid="error-message"]'); }

  visit() {
    cy.visit('/wallet/transfer');
  }

  fillAmount(amount) {
    this.amountInput.clear().type(amount);
  }

  fillRecipient(recipientId) {
    this.recipientInput.clear().type(recipientId);
  }

  submit() {
    this.submitButton.click();
  }

  transfer(amount, recipientId) {
    this.fillAmount(amount);
    this.fillRecipient(recipientId);
    this.submit();
  }
}

export default new TransferPage();
EOF

# ─── cypress/fixtures/users.json ─────────────────────────────
cat > "$PROJECT/cypress/fixtures/users.json" << 'EOF'
{
  "validUser": {
    "email": "test@example.com",
    "password": "Test@1234"
  },
  "adminUser": {
    "email": "admin@example.com",
    "password": "Admin@1234"
  },
  "inactiveUser": {
    "email": "inactive@example.com",
    "password": "Test@1234"
  }
}
EOF

# ─── cypress/fixtures/transactions.json ──────────────────────
cat > "$PROJECT/cypress/fixtures/transactions.json" << 'EOF'
{
  "validTransfer": {
    "amount": 100,
    "currency": "USD",
    "recipient_id": "usr_456"
  },
  "minTransfer": {
    "amount": 1,
    "currency": "USD",
    "recipient_id": "usr_456"
  },
  "maxTransfer": {
    "amount": 10000,
    "currency": "USD",
    "recipient_id": "usr_456"
  }
}
EOF

# ─── Sample spec: wallet/transfer.cy.js ──────────────────────
cat > "$PROJECT/cypress/e2e/wallet/transfer.cy.js" << 'EOF'
// cypress/e2e/wallet/transfer.cy.js
// Generated by QIOS — adapt selectors, messages, and routes to your project

import TransferPage from '../../pages/TransferPage';

describe('Money Transfer', () => {

  beforeEach(() => {
    cy.login(Cypress.env('TEST_USER_EMAIL'), Cypress.env('TEST_USER_PASSWORD'));
    TransferPage.visit();
  });

  context('Happy Path', () => {
    it('should successfully transfer a valid amount to an existing recipient', () => {
      TransferPage.transfer('500', 'usr_456');
      TransferPage.successMessage
        .should('be.visible')
        .and('contain', 'Transfer confirmed');
    });
  });

  context('Negative Cases', () => {
    it('should reject a transfer with insufficient balance', () => {
      TransferPage.transfer('999999', 'usr_456');
      TransferPage.errorMessage
        .should('be.visible')
        .and('contain', 'Insufficient balance');
    });

    it('should reject a transfer to a non-existent recipient', () => {
      TransferPage.transfer('100', 'unknown_user_xyz');
      TransferPage.errorMessage
        .should('be.visible')
        .and('contain', 'Recipient not found');
    });
  });

  context('Boundary Cases', () => {
    it('should accept the minimum valid amount (1 USD)', () => {
      TransferPage.transfer('1', 'usr_456');
      TransferPage.successMessage.should('be.visible');
    });

    it('should reject amount = 0', () => {
      TransferPage.fillAmount('0');
      TransferPage.fillRecipient('usr_456');
      TransferPage.submitButton.should('be.disabled');
    });
  });

});
EOF

echo ""
echo "✅ Project scaffolded in: $PROJECT/"
echo ""
echo "📋 Next steps:"
echo "   1. cd $PROJECT"
echo "   2. cp .env.example .env"
echo "   3. Edit .env with your real credentials"
echo "   4. npm install"
echo "   5. npm run cy:open"
echo ""
echo "📁 Structure created:"
find "$PROJECT" -type f | sort
echo ""
