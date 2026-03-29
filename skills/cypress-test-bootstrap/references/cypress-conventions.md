# Cypress Conventions
# QIOS — cypress-test-bootstrap

---

## File Naming

```
cypress/e2e/[module]/[feature].cy.js

Examples:
  cypress/e2e/wallet/transfer.cy.js
  cypress/e2e/wallet/cashout.cy.js
  cypress/e2e/orders/checkout.cy.js
```

---

## Test Structure

```javascript
describe('[Feature Name]', () => {

  beforeEach(() => {
    cy.login(...);       // For authenticated flows: API login — not UI login
    cy.visit('/path');
  });

  context('Happy Path', () => {
    it('should [expected behavior with valid input]', () => { ... });
  });

  context('Negative Cases', () => {
    it('should reject [invalid condition]', () => { ... });
  });

  context('Boundary Cases', () => {
    it('should accept/reject [edge value]', () => { ... });
  });

});
```

---

## Selectors — Rules

```javascript
// ✅ Always: data-testid attributes
cy.get('[data-testid="submit-btn"]')
cy.get('[data-testid="error-message"]')

// ❌ Never: CSS classes (break with design changes)
cy.get('.btn-primary')
cy.get('.error-container > span')

// ❌ Never: text content (break with copy changes or translations)
cy.contains('Submit')
cy.contains('Error: invalid input')

// ❌ Never: XPath or nth-child
cy.get('form > div:nth-child(2) > input')
```

---

## Assertions

```javascript
// ✅ Chain assertions — readable and efficient
cy.get('[data-testid="message"]')
  .should('be.visible')
  .and('contain', 'Success')
  .and('have.class', 'success');

// ✅ Wait for state change — not for time
cy.get('[data-testid="loader"]').should('not.exist');
cy.get('[data-testid="result-list"]').should('have.length.greaterThan', 0);

// ❌ Never use arbitrary waits
cy.wait(3000);
cy.wait(500);

// ✅ Wait for API response using route aliasing
cy.intercept('POST', '/api/transfer').as('transferRequest');
cy.get('[data-testid="submit-btn"]').click();
cy.wait('@transferRequest').its('response.statusCode').should('eq', 200);
```

---

## Environment Variables

```javascript
// ✅ Always use env vars
cy.visit(Cypress.env('BASE_URL') || '/');
cy.login(Cypress.env('TEST_USER_EMAIL'), Cypress.env('TEST_USER_PASSWORD'));

// ❌ Never hardcode URLs or credentials
cy.visit('https://app.myproject.com');
cy.login('user@test.com', 'password123');
```

Store credentials in:
- `.env` (local — gitignored)
- `cypress.env.json` (local — gitignored)
- a secure team vault when credentials must be shared

---

## Test Independence

Each test must:
- Set up its own preconditions in `beforeEach` or within the `it` block
- Not depend on state left by a previous test
- Clean up test data it creates (when possible)

```javascript
// ✅ Each test sets up its own state
it('should show history after transfer', () => {
  cy.apiRequest('POST', '/wallet/transfer', { amount: 100, recipient_id: 'usr_456' });
  cy.visit('/wallet/history');
  cy.get('[data-testid="transaction-list"]').should('contain', '100');
});
```

---

## Login Strategy

```javascript
// ✅ API login in beforeEach for authenticated features — fast, no UI dependency
beforeEach(() => {
  cy.login(Cypress.env('TEST_USER_EMAIL'), Cypress.env('TEST_USER_PASSWORD'));
});

// ❌ Never login via UI in every test — slow, fragile
beforeEach(() => {
  cy.visit('/login');
  cy.get('[data-testid="email"]').type('user@test.com');
  cy.get('[data-testid="password"]').type('password');
  cy.get('[data-testid="submit"]').click();
});
```

Exception:
- If the feature under test is the login screen itself, test the UI login flow directly.

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| `cy.wait(ms)` for loading | Use `.should('be.visible')` or intercept alias |
| CSS class selectors | Use `data-testid` attributes |
| UI login in every test | Use `cy.login()` custom command via API |
| Tests that depend on each other | Make every test fully independent |
| Hardcoded credentials | Use `Cypress.env()` variables |
| Missing assertions after action | Always assert the outcome, not just the action |
