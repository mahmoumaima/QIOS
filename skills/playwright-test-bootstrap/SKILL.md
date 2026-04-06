---
name: playwright-test-bootstrap
description: >
  Scaffold a complete Playwright automation project or generate structured
  Playwright test files to add to an existing suite. Use this skill whenever the
  user wants to set up Playwright, create a new Playwright test file, scaffold
  an E2E project, or generate Playwright automation code. Triggers on: "init
  Playwright project", "scaffold Playwright tests", "create Playwright test
  file", "add test to Playwright suite", "generate Playwright spec", "setup E2E
  automation with Playwright", "Playwright test template", "bootstrap
  automation project with Playwright", "automate this with Playwright". Always
  use this skill for any Playwright test generation or project setup.
---

# Playwright Test Bootstrap

## Purpose

Scaffold a production-ready Playwright project or generate structured test files
following best practices — organized for maintainability, reliability, and QA
team reuse.

---

## Input Accepted

- Request to init a new Playwright project from scratch
- Feature name or module to add tests for
- User Story or Gherkin scenarios to automate
- API endpoint to validate through UI + API setup
- Existing Playwright suite to extend

---

## Project Structure (Full Bootstrap)

```
[project-name]/
├── playwright.config.ts
├── package.json
├── tsconfig.json
├── .env.example
├── .gitignore
├── tests/
│   ├── auth.setup.ts              ← API login + storage state setup
│   └── [module]/
│       └── [feature].spec.ts
├── pages/
│   └── [FeatureName]Page.ts       ← Page Object Model
└── utils/
    └── api-client.ts              ← API helper functions
```

---

## Generation Process

### Full Project Bootstrap — generates:
1. `playwright.config.ts` — config with projects, artifacts, retries, base URL
2. `package.json` — dependencies and run scripts
3. `tsconfig.json` — TypeScript configuration
4. `.env.example` — environment variable template
5. `.gitignore` — excludes artifacts, credentials, node_modules
6. `tests/auth.setup.ts` — API login + storage state bootstrap
7. `utils/api-client.ts` — reusable API helper functions
8. `pages/TransferPage.ts` — sample page object
9. Sample transfer spec ready to adapt to the target feature

### Single Spec File — generates:
- `test.describe()` block for the feature
- `beforeEach` with navigation and stable setup
- `test()` blocks for Happy Path / Negative / Boundary cases
- Assertions with `await expect(...)` — never `waitForTimeout()`
- Stable locators with `getByTestId()` when available

---

## Key Conventions

```
✅ For authenticated features, create auth state via API in setup — not via UI in every test
✅ Use getByTestId() or equally stable locators
✅ Use await expect(...) for web-first assertions
✅ Use test.describe() and test.step() for readable structure
✅ Avoid waitForTimeout() and brittle sleeps
✅ Keep each test independent and cleanup-friendly
✅ Store credentials and URLs in environment variables only
```

---

## References

- `references/playwright-conventions.md` — selector, assertion, auth, and config rules
- `references/page-object-pattern.md` — Page Object Model implementation guide for Playwright
- `examples/playwright.config.ts` — production-ready configuration
- `examples/auth.setup.ts` — authenticated storage state example
- `examples/transfer.spec.ts` — complete spec file example
- `scripts/init-project.sh` — CLI scaffold script
