#!/bin/bash
# init-project.sh
# QIOS — playwright-test-bootstrap
#
# Usage: bash init-project.sh [project-name]
# Scaffolds a complete, production-ready Playwright project.

set -e

PROJECT=${1:-"playwright-tests"}

echo ""
echo "🚀 QIOS — Scaffolding Playwright project: $PROJECT"
echo "──────────────────────────────────────────────"

mkdir -p "$PROJECT"/{tests/wallet,playwright/.auth,pages,utils}

cat > "$PROJECT/playwright.config.ts" << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [['html'], ['list']],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'setup',
      testMatch: /.*auth\.setup\.ts/,
    },
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'playwright/.auth/user.json',
      },
      dependencies: ['setup'],
    },
  ],
});
EOF

cat > "$PROJECT/package.json" << 'EOF'
{
  "name": "playwright-tests",
  "version": "1.0.0",
  "description": "E2E test suite — scaffolded by QIOS",
  "scripts": {
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:headed": "playwright test --headed"
  },
  "devDependencies": {
    "@playwright/test": "^1.54.0",
    "dotenv": "^16.4.5"
  }
}
EOF

cat > "$PROJECT/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "moduleResolution": "node",
    "strict": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "types": ["node", "@playwright/test"]
  },
  "include": ["tests/**/*.ts", "pages/**/*.ts", "utils/**/*.ts", "playwright.config.ts"]
}
EOF

cat > "$PROJECT/.env.example" << 'EOF'
BASE_URL=http://localhost:3000
API_URL=http://localhost:4000
TEST_USER_EMAIL=test@example.com
TEST_USER_PASSWORD=Test@1234
EOF

cat > "$PROJECT/.gitignore" << 'EOF'
node_modules/
playwright-report/
test-results/
blob-report/
.env
EOF

cat > "$PROJECT/utils/api-client.ts" << 'EOF'
export const apiUrl = (path: string) => `${process.env.API_URL || 'http://localhost:4000'}${path}`;
EOF

cat > "$PROJECT/pages/TransferPage.ts" << 'EOF'
import type { Page } from '@playwright/test';

export class TransferPage {
  constructor(private readonly page: Page) {}

  amountInput = this.page.getByTestId('amount-input');
  recipientInput = this.page.getByTestId('recipient-input');
  submitButton = this.page.getByTestId('transfer-btn');
  successMessage = this.page.getByTestId('success-message');
  errorMessage = this.page.getByTestId('error-message');

  async visit() {
    await this.page.goto('/wallet/transfer');
  }

  async transfer(amount: string, recipientId: string) {
    await this.amountInput.fill(amount);
    await this.recipientInput.fill(recipientId);
    await this.submitButton.click();
  }
}
EOF

cat > "$PROJECT/tests/auth.setup.ts" << 'EOF'
import { test as setup, expect } from '@playwright/test';

setup('authenticate', async ({ page, request }) => {
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

  await page.context().storageState({ path: 'playwright/.auth/user.json' });
});
EOF

cat > "$PROJECT/tests/wallet/transfer.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';
import { TransferPage } from '../../pages/TransferPage';

test.describe('Money Transfer', () => {
  test.beforeEach(async ({ page }) => {
    const transferPage = new TransferPage(page);
    await transferPage.visit();
  });

  test('should successfully transfer a valid amount to an existing recipient', async ({ page }) => {
    const transferPage = new TransferPage(page);
    await transferPage.transfer('500', 'usr_456');
    await expect(transferPage.successMessage).toContainText('Transfer confirmed');
  });

  test('should reject a transfer with insufficient balance', async ({ page }) => {
    const transferPage = new TransferPage(page);
    await transferPage.transfer('999999', 'usr_456');
    await expect(transferPage.errorMessage).toContainText('Insufficient balance');
  });
});
EOF

echo ""
echo "✅ Playwright project scaffolded successfully"
echo ""
echo "Next steps:"
echo "  cd $PROJECT"
echo "  npm install"
echo "  npx playwright install"
echo "  cp .env.example .env"
echo "  npm run test:e2e"
