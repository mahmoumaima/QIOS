// tests/auth.setup.ts
// QIOS — playwright-test-bootstrap

import { test as setup, expect } from '@playwright/test';
import path from 'path';

const authFile = path.join('playwright', '.auth', 'user.json');

setup('authenticate via API and save storage state', async ({ page, request }) => {
  const baseUrl = process.env.BASE_URL || 'http://localhost:3000';
  const apiUrl = process.env.API_URL || 'http://localhost:4000';

  const response = await request.post(`${apiUrl}/auth/login`, {
    data: {
      email: process.env.TEST_USER_EMAIL || 'test@example.com',
      password: process.env.TEST_USER_PASSWORD || 'Test@1234',
    },
  });

  expect(response.ok()).toBeTruthy();

  const body = await response.json();

  await page.goto(baseUrl);
  await page.evaluate(({ token, userId }) => {
    window.localStorage.setItem('token', token);
    if (userId) window.localStorage.setItem('user_id', userId);
  }, {
    token: body.token,
    userId: body.user_id,
  });

  await page.context().storageState({ path: authFile });
});
