# Risk Classification — qa-test-designer
# (Local reference — source of truth: ../../_shared/qa-risk-classification.md)

See full classification at: `../../_shared/qa-risk-classification.md`

## Quick Reference

| Level | When to use | Release action |
|---|---|---|
| [CRITICAL] | Auth, financial data, security breach, data loss | Block release |
| [HIGH] | Core business logic broken, no workaround | Fix before release |
| [MEDIUM] | Secondary feature degraded, workaround exists | Fix in next sprint |
| [LOW] | Cosmetic, no functional impact | Backlog |

## Priority Quick Reference

| Priority | Meaning |
|---|---|
| P1 | Must pass before any release |
| P2 | Must pass before major release |
| P3 | Test when time allows |
