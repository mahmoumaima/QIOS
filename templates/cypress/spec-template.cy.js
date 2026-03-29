// cypress/e2e/[module]/[feature].cy.js
// QIOS — Cypress spec template
// Replace [Feature], selectors, and assertions with your actual values

describe('[Feature Name]', () => {

  beforeEach(() => {
    // For authenticated flows, login via API — never via UI
    cy.login(Cypress.env('TEST_USER_EMAIL'), Cypress.env('TEST_USER_PASSWORD'));
    cy.visit('/[path]');
  });

  // ─── Happy Path ────────────────────────────────────────────

  context('Happy Path', () => {

    it('should [expected behavior with valid input]', () => {
      cy.get('[data-testid="input-field"]').type('valid-value');
      cy.get('[data-testid="submit-btn"]').click();

      cy.get('[data-testid="success-message"]')
        .should('be.visible')
        .and('contain', 'Expected success text');
    });

  });

  // ─── Negative Cases ────────────────────────────────────────

  context('Negative Cases', () => {

    it('should reject [invalid input or condition]', () => {
      cy.get('[data-testid="input-field"]').type('invalid-value');
      cy.get('[data-testid="submit-btn"]').click();

      cy.get('[data-testid="error-message"]')
        .should('be.visible')
        .and('contain', 'Expected error text');
    });

    it('should disable submit when required field is empty', () => {
      cy.get('[data-testid="submit-btn"]').should('be.disabled');
    });

  });

  // ─── Boundary Cases ────────────────────────────────────────

  context('Boundary Cases', () => {

    it('should accept the minimum valid value', () => {
      cy.get('[data-testid="amount-input"]').type('[min-value]');
      cy.get('[data-testid="submit-btn"]').click();
      cy.get('[data-testid="success-message"]').should('be.visible');
    });

    it('should reject a value below minimum', () => {
      cy.get('[data-testid="amount-input"]').type('[below-min-value]');
      cy.get('[data-testid="submit-btn"]').should('be.disabled');
    });

  });

});
