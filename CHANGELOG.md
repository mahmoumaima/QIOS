# Changelog

All notable changes to QIOS are documented in this file.

Format: [Semantic Versioning](https://semver.org/) — `MAJOR.MINOR.PATCH`

---

## [1.0.1] — 2026-03-29

### Fixed — Example consistency and execution safety

Patch release for example quality fixes after the initial launch.

**Examples**
- fixed the invalid `<r>` placeholder in `skills/gherkin-spec-writer/examples/output-login.feature`
- removed ambiguous expected results from API and QA example test cases
- aligned duplicate-request expectations to a single expected result: `409 Conflict`
- aligned recipient-not-found examples to a single expected result: `404`

This release improves execution safety and keeps example outputs unambiguous and testable.

---

## [1.0.0] — 2026-03-29

### Added — Initial release

Initial release of QIOS (Quality Intelligence Operating System).

QIOS is a structured QA skill framework designed to guide AI agents toward consistent, risk-aware, and execution-ready testing outputs.

This release establishes the foundation of QIOS as a QA skills system for AI-assisted testing.

**Core principles**
- structured QA reasoning
- reusable testing logic
- consistent output format
- versioned QA knowledge

**Framework**
- `AGENTS.md` — global AI working agreement
- `CONTRIBUTING.md` — contributor guidelines
- `docs/architecture.md` — system architecture with Mermaid diagrams
- `docs/usage.md` — installation and usage guide
- `docs/examples.md` — real-world usage walkthrough

**Skills**
- `api-deep-analyzer` — complete API test coverage from an endpoint or specification
- `api-spec-generator` — Postman / Bruno collection generation
- `qa-test-designer` — structured test cases from User Stories or Jira tickets
- `gherkin-spec-writer` — BDD feature generation from requirements
- `cypress-test-bootstrap` — Cypress project scaffolding

**Shared references**
- `_shared/api-testing-checklist.md`
- `_shared/qa-risk-classification.md`
- `_shared/test-case-template.md`
- `_shared/gherkin-style-guide.md`

**Templates**
- `templates/postman/` — Postman collection template
- `templates/bruno/` — Bruno collection template
- `templates/cypress/` — Cypress project template

**Examples**
- `examples/api/cashout-test-cases.md`
- `examples/api/cashout-collection.json`
- `examples/gherkin/transfer.feature`
- `examples/cypress/transfer.cy.js`

---

## Roadmap

### Planned for v1.1.0
- `performance-test-designer` skill — k6 / Gatling test scaffolding
- `bug-report-writer` skill — structured bug report from a description
- `test-data-generator` skill — realistic test data sets

### Planned for v1.2.0
- Bruno collection examples extended
- `_shared/` reference for mobile testing conventions

---

> See [README](README.md) for the full project overview.
