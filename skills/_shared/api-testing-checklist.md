# API Testing Checklist
# QIOS — Shared Reference

> Used by: api-deep-analyzer, api-spec-generator, qa-test-designer

---

## 1. Request Structure

- [ ] All required fields present and validated
- [ ] Each required field tested missing independently (not all at once)
- [ ] Optional fields tested both present and absent
- [ ] Field type mismatches: string / int / boolean / array / object
- [ ] Field length: min length, max length, exact limits
- [ ] Null vs empty string vs missing field (3 distinct test cases)
- [ ] Special characters in string fields: `"`, `'`, `<>`, `/`, `\`, `%`, `@`
- [ ] Unicode and emoji in text fields
- [ ] Whitespace: leading, trailing, only whitespace

---

## 2. Authentication & Authorization

- [ ] No token → 401 Unauthorized
- [ ] Invalid / malformed token → 401 Unauthorized
- [ ] Expired token → 401 Unauthorized
- [ ] Valid token, wrong role → 403 Forbidden
- [ ] Valid token, correct role → expected success response
- [ ] Token belonging to another user → 403 (IDOR check)
- [ ] Admin token on user endpoint → check permission boundary

---

## 3. Business Logic

- [ ] Happy path with valid, complete data
- [ ] Boundary values: minimum accepted value
- [ ] Boundary values: maximum accepted value
- [ ] Boundary values: one below minimum → rejected
- [ ] Boundary values: one above maximum → rejected
- [ ] Business rules enforced correctly
- [ ] State transitions are correct (pending → confirmed → failed)
- [ ] Idempotency: duplicate request handling (same payload sent twice)
- [ ] Concurrent requests: race condition check

---

## 4. Response Validation

- [ ] Status code is exactly correct (not just 2xx range)
- [ ] Response body contains all expected fields
- [ ] Field types in response are correct
- [ ] Field values are accurate (not dummy data)
- [ ] Error messages are clear, consistent, and non-technical
- [ ] No sensitive data leaked in error responses (no stack traces, no DB info)
- [ ] Response time within acceptable threshold (default: < 2000ms)
- [ ] Content-Type header is correct (application/json)
- [ ] CORS headers present if cross-origin expected

---

## 5. Security Basics

- [ ] SQL injection in string fields: `'; DROP TABLE users; --`
- [ ] XSS in text inputs: `<script>alert(1)</script>`
- [ ] Mass assignment: extra unexpected fields in request body
- [ ] IDOR: access another user's resource with valid own token
- [ ] Rate limiting: repeated rapid requests (10+ in 1 second)
- [ ] Large payload: stress test with oversized body
- [ ] Path traversal in URL parameters: `../../etc/passwd`

---

## 6. Financial / Sensitive Domain (when applicable)

- [ ] Negative amounts rejected
- [ ] Zero amount: defined and tested behavior
- [ ] Decimal precision: correct number of decimal places
- [ ] Currency code validated (ISO 4217)
- [ ] Double-charge / double-submission prevention
- [ ] Transaction rollback on partial failure
- [ ] Audit trail: transaction is logged correctly
