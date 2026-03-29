// cypress/e2e/wallet/transfer.cy.js
// QIOS — cypress-test-bootstrap

describe('Money Transfer', () => {

  beforeEach(() => {
    // Login via API — never via UI (faster, more reliable)
    cy.login(Cypress.env('TEST_USER_EMAIL'), Cypress.env('TEST_USER_PASSWORD'));
    cy.visit('/wallet/transfer');
  });

  // ─── Happy Path ────────────────────────────────────────────────

  context('Happy Path', () => {

    it('should successfully transfer a valid amount to an existing recipient', () => {
      cy.get('[data-testid="amount-input"]').type('500');
      cy.get('[data-testid="recipient-input"]').type('usr_456');
      cy.get('[data-testid="transfer-btn"]').click();

      cy.get('[data-testid="success-message"]')
        .should('be.visible')
        .and('contain', 'Transfer confirmed');
    });

    it('should display the transaction in the transfer history', () => {
      cy.get('[data-testid="amount-input"]').type('100');
      cy.get('[data-testid="recipient-input"]').type('usr_456');
      cy.get('[data-testid="transfer-btn"]').click();

      cy.get('[data-testid="success-message"]').should('be.visible');

      cy.visit('/wallet/history');
      cy.get('[data-testid="transaction-list"]')
        .should('contain', '100')
        .and('contain', 'usr_456');
    });

    it('should update the sender balance after a successful transfer', () => {
      cy.get('[data-testid="balance"]').invoke('text').then((balanceBefore) => {
        cy.get('[data-testid="amount-input"]').type('100');
        cy.get('[data-testid="recipient-input"]').type('usr_456');
        cy.get('[data-testid="transfer-btn"]').click();
        cy.get('[data-testid="success-message"]').should('be.visible');

        cy.visit('/wallet');
        cy.get('[data-testid="balance"]')
          .invoke('text')
          .should('not.eq', balanceBefore);
      });
    });

  });

  // ─── Negative Cases ────────────────────────────────────────────

  context('Negative Cases', () => {

    it('should reject a transfer with insufficient balance', () => {
      cy.get('[data-testid="amount-input"]').type('999999');
      cy.get('[data-testid="recipient-input"]').type('usr_456');
      cy.get('[data-testid="transfer-btn"]').click();

      cy.get('[data-testid="error-message"]')
        .should('be.visible')
        .and('contain', 'Insufficient balance');
    });

    it('should reject a transfer to a non-existent recipient', () => {
      cy.get('[data-testid="amount-input"]').type('100');
      cy.get('[data-testid="recipient-input"]').type('unknown_user_xyz');
      cy.get('[data-testid="transfer-btn"]').click();

      cy.get('[data-testid="error-message"]')
        .should('be.visible')
        .and('contain', 'Recipient not found');
    });

    it('should disable the transfer button when the amount field is empty', () => {
      cy.get('[data-testid="recipient-input"]').type('usr_456');
      cy.get('[data-testid="transfer-btn"]').should('be.disabled');
    });

    it('should disable the transfer button when the recipient field is empty', () => {
      cy.get('[data-testid="amount-input"]').type('100');
      cy.get('[data-testid="transfer-btn"]').should('be.disabled');
    });

  });

  // ─── Boundary Cases ────────────────────────────────────────────

  context('Boundary Cases', () => {

    it('should accept the minimum valid amount (1 USD)', () => {
      cy.get('[data-testid="amount-input"]').type('1');
      cy.get('[data-testid="recipient-input"]').type('usr_456');
      cy.get('[data-testid="transfer-btn"]').click();
      cy.get('[data-testid="success-message"]').should('be.visible');
    });

    it('should accept the maximum valid amount (10,000 USD)', () => {
      cy.get('[data-testid="amount-input"]').type('10000');
      cy.get('[data-testid="recipient-input"]').type('usr_456');
      cy.get('[data-testid="transfer-btn"]').click();
      cy.get('[data-testid="success-message"]').should('be.visible');
    });

    it('should reject amount = 0', () => {
      cy.get('[data-testid="amount-input"]').type('0');
      cy.get('[data-testid="transfer-btn"]').should('be.disabled');
    });

    it('should reject amount above maximum (10,001 USD)', () => {
      cy.get('[data-testid="amount-input"]').type('10001');
      cy.get('[data-testid="recipient-input"]').type('usr_456');
      cy.get('[data-testid="transfer-btn"]').click();

      cy.get('[data-testid="error-message"]')
        .should('be.visible')
        .and('contain', 'exceeds maximum');
    });

  });

});
