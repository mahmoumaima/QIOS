---
name: api-deep-analyzer
description: >
  Deeply analyze an API endpoint and generate complete, structured test coverage.
  Use this skill whenever the user provides an API endpoint, a Swagger/OpenAPI spec,
  or describes an API to test. Triggers on: "analyze this API", "generate test cases
  for this endpoint", "what should I test on this API", "test coverage for POST/GET/PUT",
  "API test design", "generate API test cases". Always use this skill before writing
  API tests manually. Even if the user provides only a method and path, use this skill.
---

# API Deep Analyzer

## Purpose

Given an API endpoint, produce complete, structured test coverage ready to execute.
No manual brainstorming. No forgotten edge cases. Consistent quality every time.

---

## Input Accepted

- Endpoint: method + path (e.g. `POST /orders/checkout`)
- Headers, body schema, query params
- Swagger/OpenAPI snippet or full spec
- Plain business description of the endpoint
- Existing collection to extend

---

## Analysis Process

### Step 1 — API Profile

Extract and document:
```
Method        : POST / GET / PUT / DELETE / PATCH
Path          : /resource/action
Auth          : Bearer / API Key / None / Other
Headers       : Content-Type, Authorization, custom headers
Body Fields   : name, type, required/optional, constraints
Query Params  : name, type, description
Business Goal : what this endpoint does in the system
Dependencies  : which services / DB / events are involved
Sensitive Data: financial? PII? session? audit required?
```

### Step 2 — Risk Assessment

Tag every test area:
```
[CRITICAL]  → auth, financial data, data integrity, security breach
[HIGH]      → business rules, state changes, data persistence
[MEDIUM]    → error messages, response format, performance
[LOW]       → optional fields, cosmetic, non-critical behavior
```

### Step 3 — Test Generation

#### ✅ Happy Path
- Standard success with valid, complete data
- Success with minimum required fields only
- Success with boundary values (min, max)
- Success with different valid user roles (if applicable)

#### ❌ Negative Cases
- Each required field missing independently
- Invalid field type (string where number expected, etc.)
- Invalid value (negative amount, future date where past expected, etc.)
- No authentication token → 401
- Invalid / expired token → 401
- Wrong role → 403
- Duplicate / idempotency request

#### ⚠️ Edge Cases
- Null vs empty string vs missing field (3 distinct cases)
- Special characters in string fields
- Whitespace-only string values
- Maximum payload size exceeded
- Concurrent requests (race condition)

#### 🔒 Security Cases
- SQL injection: `' OR 1=1; --`
- XSS: `<script>alert(1)</script>`
- Mass assignment: extra unexpected fields in body
- IDOR: valid token of User B accessing User A's resource
- Rate limiting: 10+ identical requests in 1 second
- Path traversal in URL params: `../../etc/passwd`

---

## Output Format

### Test Case Table

```
| ID          | Category   | Scenario                          | Test Data                    | Expected Result              | Risk     |
|-------------|------------|-----------------------------------|------------------------------|------------------------------|----------|
| TC-XXX-001  | Happy Path | Valid request — success           | valid body + token           | 200 + expected response body | HIGH     |
| TC-XXX-002  | Negative   | Missing field [fieldName]         | body without [fieldName]     | 400 + validation error msg   | HIGH     |
| TC-XXX-003  | Negative   | No auth token                     | no Authorization header      | 401 Unauthorized             | CRITICAL |
| TC-XXX-004  | Boundary   | [field] at minimum value          | [field]: [min]               | 200 accepted                 | MEDIUM   |
| TC-XXX-005  | Security   | SQL injection in [field]          | [field]: "' OR 1=1; --"      | 400, no DB error exposed     | CRITICAL |
```

### Flags Section (always include)
```
[MISSING]    : List any information needed but not provided
[ASSUMPTION] : List all assumptions made to generate the cases
```

### Optional: Postman/Bruno Collection
When requested, generate importable collection.
→ Use skill `api-spec-generator` for full collection generation.

---

## References

- `references/api-testing-checklist.md` — Complete verification checklist
- `../../_shared/api-testing-checklist.md` — Shared version
- `../../_shared/qa-risk-classification.md` — Risk level definitions
- `../../_shared/test-case-template.md` — Full test case format
- `examples/input-endpoint.md` — Example input
- `examples/output-test-cases.md` — Example generated output
