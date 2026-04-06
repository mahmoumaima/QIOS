// examples/playwright/transfer.spec.ts
// QIOS — playwright-test-bootstrap

import { test, expect } from '@playwright/test';

test.describe('Money Transfer', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/wallet/transfer');
  });

  test('should successfully transfer a valid amount to an existing recipient', async ({ page }) => {
    await page.getByTestId('amount-input').fill('500');
    await page.getByTestId('recipient-input').fill('usr_456');
    await page.getByTestId('transfer-btn').click();

    await expect(page.getByTestId('success-message')).toContainText('Transfer confirmed');
  });

  test('should reject a transfer to a non-existent recipient', async ({ page }) => {
    await page.getByTestId('amount-input').fill('100');
    await page.getByTestId('recipient-input').fill('unknown_user_xyz');
    await page.getByTestId('transfer-btn').click();

    await expect(page.getByTestId('error-message')).toContainText('Recipient not found');
  });
});
