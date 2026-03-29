# Page Object Pattern
# QIOS — cypress-test-bootstrap

---

## What is the Page Object Pattern?

A Page Object is a class that encapsulates the selectors and actions
for a specific page or component. Tests interact with Page Objects
instead of directly accessing DOM selectors, while keeping assertions
in the spec file.

**Benefits:**
- Selectors defined in one place — change once, fix everywhere
- Tests read like user journeys, not DOM queries
- Reusable actions across multiple test files

---

## When to Use It

Use Page Objects when:
- A page has more than 5 selectors used across multiple tests
- Multiple test files test the same page or component
- The UI is complex and actions require multiple steps

Do not use for:
- Simple single-page specs with only 2-3 selectors
- API-only tests (no UI interaction needed)

---

## Page Object Structure

```javascript
// cypress/pages/TransferPage.js

class TransferPage {

  // ─── Selectors ───────────────────────────────────────────
  get amountInput()     { return cy.get('[data-testid="amount-input"]'); }
  get recipientInput()  { return cy.get('[data-testid="recipient-input"]'); }
  get submitButton()    { return cy.get('[data-testid="transfer-btn"]'); }
  get successMessage()  { return cy.get('[data-testid="success-message"]'); }
  get errorMessage()    { return cy.get('[data-testid="error-message"]'); }

  // ─── Actions ─────────────────────────────────────────────
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
```

---

## Using a Page Object in Tests

```javascript
// cypress/e2e/wallet/transfer.cy.js
import TransferPage from '../../pages/TransferPage';

describe('Money Transfer', () => {

  beforeEach(() => {
    cy.login(Cypress.env('TEST_USER_EMAIL'), Cypress.env('TEST_USER_PASSWORD'));
    TransferPage.visit();
  });

  context('Happy Path', () => {
    it('should successfully transfer a valid amount', () => {
      TransferPage.transfer('500', 'usr_456');
      TransferPage.successMessage
        .should('be.visible')
        .and('contain', 'Transfer confirmed');
    });
  });

  context('Negative Cases', () => {
    it('should reject transfer with insufficient balance', () => {
      TransferPage.transfer('999999', 'usr_456');
      TransferPage.errorMessage
        .should('be.visible')
        .and('contain', 'Insufficient balance');
    });

    it('should disable submit when amount is empty', () => {
      TransferPage.fillRecipient('usr_456');
      TransferPage.submitButton.should('be.disabled');
    });
  });

});
```

---

## File Organization

```
cypress/
└── pages/
    ├── LoginPage.js
    ├── WalletPage.js
    ├── TransferPage.js
    ├── HistoryPage.js
    └── components/
        ├── NavBar.js
        └── NotificationBanner.js
```

---

## Page Object Rules

| Rule | Reason |
|---|---|
| Never put assertions inside Page Objects | Keep assertion logic in tests |
| Use `get` properties for selectors | Lazy evaluation — always fresh DOM reference |
| One class per page or major component | Keeps files focused and maintainable |
| Export a singleton instance | `export default new TransferPage()` |
| Name files `[Feature]Page.js` | Easy to find and consistent |
