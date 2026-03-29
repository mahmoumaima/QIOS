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
- `performance-test-designer` skill — basic performance test scaffolding with a k6 focus
- `bug-report-writer` skill — structured bug report generation
- `test-data-generator` skill — reusable QA test data sets
- initial CI validation for examples — Gherkin syntax, JSON validity, and structure checks

---

### Planned for v1.2.0
- `_shared/` reference for mobile testing conventions
- `_shared/` reference for accessibility QA heuristics
- `test-reviewer` skill — structured review of QA artifacts such as test cases and Gherkin files
- Bruno collection examples extended

---

### Planned for v1.3.0
- `traceability-mapper` skill — link requirements to test cases
- `api-regression-pack-builder` skill — reusable API regression scenarios
- `_shared/` reference for exploratory testing heuristics
- additional real-world examples across skills

---

### Planned for v2.0.0
- improved CI validation for QIOS artifacts
- validation of examples such as Gherkin, JSON, and scripts
- consistency checks across skills, templates, and references
- repository validation scripts for local checks
- release checklist for quality control

---

### Planned for v2.1.0
- stronger validation rules for QA artifacts
- Gherkin structure checks
- JSON and API consistency checks
- contributor guidance for skill completeness
- improved documentation for skill usage and extension

---

### Planned for v3.0.0
- multi-skill usage patterns — documented, not automated
- end-to-end QA workflows from requirement to test cases and examples
- consistency guidelines across QA artifacts such as test cases, Gherkin, and API collections

---

## Roadmap Philosophy

QIOS evolves in three stages:
- `1.x` — structured QA capabilities
- `2.x` — validated and reliable QA framework
- `3.x` — structured QA workflows across artifacts

---

> See [README](README.md) for the full project overview.
