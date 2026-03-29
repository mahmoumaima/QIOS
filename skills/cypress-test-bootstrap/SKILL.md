---
name: cypress-test-bootstrap
description: >
  Scaffold a complete Cypress automation project or generate structured test files
  to add to an existing suite. Use this skill whenever the user wants to set up
  Cypress, create a new test file, scaffold an E2E project, or generate Cypress
  test code. Triggers on: "init Cypress project", "scaffold Cypress tests",
  "create Cypress test file", "add test to Cypress suite", "generate Cypress spec",
  "setup E2E automation with Cypress", "Cypress test template", "bootstrap
  automation project", "automate this with Cypress". Always use this skill
  for any Cypress test generation or project setup.
---

# Cypress Test Bootstrap

## Purpose

Scaffold a production-ready Cypress project or generate structured test files
following best practices — organized for maintainability and QA team reuse.

---

## Input Accepted

- Request to init a new Cypress project from scratch
- Feature name or module to add tests for
- User Story or Gherkin scenarios to automate
- API endpoint to test via `cy.request()`
- Existing test suite to extend

---

## Project Structure (Full Bootstrap)

```
[project-name]/
├── cypress.config.js
├── package.json
├── .env.example
├── .gitignore
└── cypress/
    ├── e2e/                        ← test specs by feature/module
    │   └── [module]/
    │       └── [feature].cy.js
    ├── fixtures/                   ← test data (JSON files)
    │   ├── users.json
    │   └── transactions.json
    ├── support/
    │   ├── e2e.js                  ← global setup / imports
    │   ├── commands.js             ← custom reusable commands
    │   └── api-helpers.js          ← API utility functions
    └── pages/                      ← Page Object Model
        └── [FeatureName]Page.js
```

---

## Generation Process

### Full Project Bootstrap — generates:
1. `cypress.config.js` — config with env variables
2. `package.json` — dependencies and run scripts
3. `.env.example` — environment variable template
4. `.gitignore` — excludes artifacts, credentials, node_modules
5. `cypress/support/commands.js` — login + apiRequest custom commands
6. `cypress/support/e2e.js` — global imports
7. `cypress/fixtures/users.json` — test data structure
8. Sample transfer spec file ready to adapt to the target feature

### Single Spec File — generates:
- `describe` block for the feature
- `beforeEach` with API login for authenticated flows
- `context('Happy Path')` / `context('Negative Cases')` / `context('Boundary Cases')`
- `it` blocks with clear descriptive names
- Assertions with `.should()` — never `cy.wait(ms)`
- Custom commands for repeated actions

---

## Key Conventions

```
✅ For authenticated features, login via API in beforeEach (cy.request) — not via UI
✅ Use data-testid selectors exclusively
✅ Group tests: context('Happy Path') / context('Negative Cases')
✅ Store all credentials and URLs in environment variables
✅ Use .should() assertions — never cy.wait(ms)
✅ Each test is fully independent — no shared state
✅ Clean up test data after tests when needed
```

---

## References

- `references/cypress-conventions.md` — Full selector, assertion, and structure rules
- `references/page-object-pattern.md` — Page Object Model implementation guide
- `examples/cypress.config.js` — Production-ready configuration
- `examples/transfer.cy.js` — Complete spec file example
- `examples/commands.js` — Custom commands reference
- `scripts/init-project.sh` — CLI scaffold script
