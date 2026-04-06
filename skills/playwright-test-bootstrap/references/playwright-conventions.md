# QIOS — playwright-test-bootstrap

## Core conventions

- Prefer TypeScript for Playwright projects
- Use `getByTestId()` when the application exposes stable test ids
- Use `await expect(...)` for assertions — no manual polling loops
- Avoid `waitForTimeout()` except for explicit debugging
- Keep tests independent and cleanup-friendly

## Authentication

- For authenticated flows, prefer API login in `auth.setup.ts`
- Save authenticated state with `storageState()`
- Do not repeat UI login in every test unless login itself is the feature under test

## Test structure

- Use `test.describe()` to group scenarios by feature
- Group cases as Happy Path / Negative Cases / Boundary Cases when applicable
- Use `test.step()` for long business flows
- Keep assertions in specs; keep low-level actions in page objects

## Selectors

Preferred order:
1. `getByTestId()`
2. `getByRole()` with accessible name
3. stable CSS selectors only when test ids are unavailable

Avoid:
- brittle nth-child selectors
- text selectors for unstable UI copy
- XPath unless there is no stable alternative

## Artifacts and retries

- Enable trace on first retry
- Keep screenshots on failure only
- Retain video on failure only when it adds debugging value
- Use limited retries in CI, not as a substitute for stability
