// tests/wallet/transfer.spec.ts
// QIOS — playwright-test-bootstrap

import { test, expect } from '@playwright/test';

test.describe('Money Transfer', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/wallet/transfer');
  });

  test.describe('Happy Path', () => {
    test('should successfully transfer a valid amount to an existing recipient', async ({ page }) => {
      await page.getByTestId('amount-input').fill('500');
      await page.getByTestId('recipient-input').fill('usr_456');
      await page.getByTestId('transfer-btn').click();

      await expect(page.getByTestId('success-message')).toContainText('Transfer confirmed');
    });
  });

  test.describe('Negative Cases', () => {
    test('should reject a transfer with insufficient balance', async ({ page }) => {
      await page.getByTestId('amount-input').fill('999999');
      await page.getByTestId('recipient-input').fill('usr_456');
      await page.getByTestId('transfer-btn').click();

      await expect(page.getByTestId('error-message')).toContainText('Insufficient balance');
    });

    test('should reject a transfer to a non-existent recipient', async ({ page }) => {
      await page.getByTestId('amount-input').fill('100');
      await page.getByTestId('recipient-input').fill('unknown_user_xyz');
      await page.getByTestId('transfer-btn').click();

      await expect(page.getByTestId('error-message')).toContainText('Recipient not found');
    });
  });

  test.describe('Boundary Cases', () => {
    test('should accept the minimum valid amount (1 USD)', async ({ page }) => {
      await page.getByTestId('amount-input').fill('1');
      await page.getByTestId('recipient-input').fill('usr_456');
      await page.getByTestId('transfer-btn').click();

      await expect(page.getByTestId('success-message')).toBeVisible();
    });

    test('should reject amount above maximum (10,001 USD)', async ({ page }) => {
      await page.getByTestId('amount-input').fill('10001');
      await page.getByTestId('recipient-input').fill('usr_456');
      await page.getByTestId('transfer-btn').click();

      await expect(page.getByTestId('error-message')).toContainText('exceeds maximum');
    });
  });
});
