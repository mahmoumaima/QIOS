# QA Risk Classification
# QIOS — Shared Reference

> Used by: qa-test-designer, api-deep-analyzer, gherkin-spec-writer, cypress-test-bootstrap

---

## Risk Levels

### [CRITICAL]
The application is unusable, data is corrupted, or security is breached.

**Examples:**
- Authentication bypass
- Payment processing failure
- Data loss or corruption
- System crash or unhandled exception
- Security vulnerability exposed

**Action:** Block release immediately. No deployment until fixed.

---

### [HIGH]
A core feature is broken or a business rule is violated.
A workaround does not exist or is not acceptable.

**Examples:**
- Core calculation returns wrong result
- Record not saved to database
- Required notification not sent
- Incorrect status transition

**Action:** Fix before release. Priority in current sprint.

---

### [MEDIUM]
A secondary feature is degraded. A workaround exists.

**Examples:**
- Wrong error message displayed
- UI misalignment on edge case
- Response time slightly above threshold
- Non-critical field not trimmed

**Action:** Fix in next sprint. Document workaround if needed.

---

### [LOW]
Cosmetic issue. No functional or business impact.

**Examples:**
- Typo in label or tooltip
- Minor visual inconsistency
- Non-critical optional field behavior
- Unused field in response payload

**Action:** Backlog. Fix when convenient.

---

## Priority Levels

| Priority | Meaning | When to test |
|---|---|---|
| **P1** | Must pass before any release | Every deployment |
| **P2** | Must pass before major release | Every sprint release |
| **P3** | Nice to have covered | Full regression only |

---

## Risk × Priority Matrix

| Scenario Type | Risk | Priority |
|---|---|---|
| Authentication (login, token, session) | CRITICAL | P1 |
| Financial transaction (payment, transfer, refund) | CRITICAL | P1 |
| Data creation / update / deletion | HIGH | P1 |
| Business rule validation | HIGH | P1 |
| Authorization (roles, permissions) | HIGH | P1 |
| Boundary value (min/max) | MEDIUM | P2 |
| Error message accuracy | MEDIUM | P2 |
| Integration with external service | HIGH | P2 |
| UI / visual rendering | LOW | P3 |
| Optional or non-critical fields | LOW | P3 |
