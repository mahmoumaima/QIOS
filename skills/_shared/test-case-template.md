# Test Case Template
# QIOS — Shared Reference

> Used by: qa-test-designer, api-deep-analyzer

---

## Full Test Case Format

```
ID           : TC-[MODULE]-[NUMBER]   (e.g. TC-WALLET-001)
Title        : [Short, clear description of what is being tested]
Category     : Happy Path | Negative | Boundary | Edge | Security | Integration
Priority     : P1 | P2 | P3
Risk         : [CRITICAL] | [HIGH] | [MEDIUM] | [LOW]

Preconditions:
  - [Condition 1 that must be true before executing this test]
  - [Condition 2]

Test Data:
  - field_name: value
  - field_name: value

Steps:
  1. [Action 1]
  2. [Action 2]
  3. [Action 3]

Expected Result:
  - [Exactly what should happen — status code, message, data, state change]

Actual Result:      [Leave blank — filled during execution]
Status:             [Pass | Fail | Blocked | Skip]
Notes:              [Optional — known issues, dependencies, edge context]
```

---

## Condensed Table Format (for plans with many cases)

```
| ID          | Title                              | Category   | Priority | Expected Result               | Risk     |
|-------------|-------------------------------------|------------|----------|-------------------------------|----------|
| TC-XXX-001  | Valid request — success             | Happy Path | P1       | 200 + response body           | HIGH     |
| TC-XXX-002  | Missing required field              | Negative   | P1       | 400 + error message           | HIGH     |
| TC-XXX-003  | No authentication token             | Negative   | P1       | 401 Unauthorized              | CRITICAL |
| TC-XXX-004  | Amount at minimum boundary          | Boundary   | P2       | 200 + accepted                | MEDIUM   |
| TC-XXX-005  | Amount below minimum                | Boundary   | P2       | 400 + validation error        | MEDIUM   |
| TC-XXX-006  | SQL injection in text field         | Security   | P1       | 400 + no DB error leaked      | CRITICAL |
```

---

## Naming Conventions

### Test Case ID
```
TC-[MODULE]-[NUMBER]

Examples:
  TC-AUTH-001     → Authentication module, first case
  TC-WALLET-012   → Wallet module, 12th case
  TC-ORDER-003    → Order module, 3rd case
```

### Title Rules
- Start with what is being tested, not how
- Use "should" or action verb: "Reject transfer with negative amount"
- Be specific enough to understand without reading the steps
- Max 10 words

---

## Test Suite Structure

```
Feature: [Feature Name]
│
├── 1. Happy Path (P1)
│     TC-XXX-001  Main success scenario
│     TC-XXX-002  Alternative success scenario (different role or input)
│
├── 2. Negative Cases (P1)
│     TC-XXX-003  Missing required field A
│     TC-XXX-004  Missing required field B
│     TC-XXX-005  Invalid field type
│     TC-XXX-006  Business rule violation
│
├── 3. Boundary Cases (P2)
│     TC-XXX-007  Minimum value accepted
│     TC-XXX-008  Below minimum rejected
│     TC-XXX-009  Maximum value accepted
│     TC-XXX-010  Above maximum rejected
│
├── 4. Security Cases (P1)
│     TC-XXX-011  No auth token
│     TC-XXX-012  Invalid token
│     TC-XXX-013  Expired token
│     TC-XXX-014  IDOR attempt
│
└── 5. Edge Cases (P2-P3)
      TC-XXX-015  Null vs empty string
      TC-XXX-016  Special characters
      TC-XXX-017  Concurrent request
```
