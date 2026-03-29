# Test Case Template — qa-test-designer
# (Local reference — source of truth: ../../_shared/test-case-template.md)

See full template at: `../../_shared/test-case-template.md`

## Quick Format Reference

```
ID           : TC-[MODULE]-[NUMBER]
Title        : [Short, specific description]
Category     : Happy Path | Negative | Boundary | Edge | Security | Integration | Performance
Priority     : P1 | P2 | P3
Risk         : [CRITICAL] | [HIGH] | [MEDIUM] | [LOW]
Preconditions: [What must be true before executing]
Steps        : [Numbered actions]
Test Data    : [Specific field values]
Expected     : [Exact expected outcome]
```

## Coverage Minimum per Feature

| Type | Minimum | Priority |
|---|---|---|
| Happy Path | 1 | P1 |
| Negative (per business rule) | 1 per rule | P1 |
| Boundary (per numeric/date field) | 2 (min + max) | P2 |
| Security (if auth involved) | 1 (no token + wrong role) | P1 |
| Edge (null/empty/special chars) | 1 per sensitive field | P2 |
