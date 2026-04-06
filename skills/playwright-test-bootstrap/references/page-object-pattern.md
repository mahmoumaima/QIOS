# QIOS — playwright-test-bootstrap

## Page Object Pattern

Use page objects to centralize stable locators and repeated user actions.

### Recommended

- Locators live in the page object
- Reusable actions live in the page object
- Business assertions stay in the spec file

### Example

```ts
import { expect, type Page } from '@playwright/test';

export class TransferPage {
  constructor(private readonly page: Page) {}

  amountInput = this.page.getByTestId('amount-input');
  recipientInput = this.page.getByTestId('recipient-input');
  submitButton = this.page.getByTestId('transfer-btn');
  successMessage = this.page.getByTestId('success-message');

  async visit() {
    await this.page.goto('/wallet/transfer');
  }

  async transfer(amount: string, recipientId: string) {
    await this.amountInput.fill(amount);
    await this.recipientInput.fill(recipientId);
    await this.submitButton.click();
  }
}
```

### Keep assertions in specs

```ts
const transferPage = new TransferPage(page);
await transferPage.visit();
await transferPage.transfer('500', 'usr_456');
await expect(transferPage.successMessage).toContainText('Transfer confirmed');
```

This keeps page objects reusable and test intent visible in the spec.
