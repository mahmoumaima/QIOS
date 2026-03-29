# Example Output — qa-test-designer

```
═══════════════════════════════════════════════════
 TEST PLAN
 Feature      : Money Transfer
 Reference    : US-042
 Total Cases  : 18
 Coverage     : Functional ✅  Boundary ✅  Negative ✅  Security ✅  Performance ✅
 Flags        : 3 MISSING  0 AMBIGUOUS  2 ASSUMPTION
═══════════════════════════════════════════════════
```

---

## Test Cases

| ID           | Title                                                  | Category    | Priority | Expected Result                                          | Risk     |
|--------------|--------------------------------------------------------|-------------|----------|----------------------------------------------------------|----------|
| TC-TRSF-001  | Successful transfer — valid amount and recipient        | Happy Path  | P1       | 200 — transaction created, both users notified           | HIGH     |
| TC-TRSF-002  | Successful transfer — minimum amount (1 USD)            | Boundary    | P1       | 200 — transaction created                                | HIGH     |
| TC-TRSF-003  | Successful transfer — maximum amount (10,000 USD)       | Boundary    | P1       | 200 — transaction created                                | HIGH     |
| TC-TRSF-004  | Transaction appears in sender's history                 | Functional  | P1       | Transaction record visible with correct details          | HIGH     |
| TC-TRSF-005  | Transaction appears in recipient's history              | Functional  | P1       | Transaction record visible with correct details          | HIGH     |
| TC-TRSF-006  | Transfer without authentication                         | Security    | P1       | 401 Unauthorized                                         | CRITICAL |
| TC-TRSF-007  | Transfer with insufficient balance                      | Negative    | P1       | 422 — "Insufficient balance" error                       | CRITICAL |
| TC-TRSF-008  | Transfer to non-existent recipient                      | Negative    | P1       | 404 or 422 — "Recipient not found" error                 | HIGH     |
| TC-TRSF-009  | Transfer to inactive account                            | Negative    | P1       | 422 — "Recipient account is inactive" error              | HIGH     |
| TC-TRSF-010  | Transfer amount below minimum (0 USD)                   | Boundary    | P2       | 400 — "Amount must be at least 1"                        | HIGH     |
| TC-TRSF-011  | Transfer amount above maximum (10,001 USD)              | Boundary    | P2       | 422 — "Amount exceeds maximum per transaction"           | MEDIUM   |
| TC-TRSF-012  | Transfer amount is negative                             | Negative    | P1       | 400 — validation error                                   | HIGH     |
| TC-TRSF-013  | Missing required field: amount                          | Negative    | P1       | 400 — "amount is required"                               | HIGH     |
| TC-TRSF-014  | Missing required field: recipient_id                    | Negative    | P1       | 400 — "recipient_id is required"                         | HIGH     |
| TC-TRSF-015  | Sender transfers to themselves                          | Negative    | P2       | 422 — self-transfer not allowed (or defined behavior)    | MEDIUM   |
| TC-TRSF-016  | Duplicate transfer — same payload within 1 second       | Edge        | P2       | 409 Conflict or idempotent 200 with same transaction_id  | HIGH     |
| TC-TRSF-017  | IDOR — access another user's wallet via own token       | Security    | P1       | 403 Forbidden                                            | CRITICAL |
| TC-TRSF-018  | Transfer completes within performance threshold         | Performance | P2       | Response received within 5 seconds                       | MEDIUM   |

---

## Flags

```
[MISSING]    : What happens if the notification service is unavailable?
               Is the transfer still processed, or is it rolled back?

[MISSING]    : Is there a daily transfer limit per user?
               If so, what is the threshold and what error is returned when exceeded?

[MISSING]    : Are there supported currencies other than USD?
               If yes, is currency validation required?

[ASSUMPTION] : A user cannot transfer to themselves — confirm with business rules.

[ASSUMPTION] : "Instantly" in the story means response time < 5 seconds,
               as stated in the acceptance criteria.
```

---

## Coverage Summary

| Type | Status | Cases |
|---|---|---|
| Functional | ✅ | TC-001 to TC-005 |
| Boundary | ✅ | TC-002, TC-003, TC-010, TC-011 |
| Negative | ✅ | TC-007 to TC-015 |
| Security | ✅ | TC-006, TC-017 |
| Edge | ✅ | TC-016 |
| Performance | ✅ | TC-018 |

---

## Next Steps

```
→ Run gherkin-spec-writer on this plan to generate the .feature file
→ Run api-deep-analyzer on POST /wallet/transfer for API-level coverage
→ Run cypress-test-bootstrap to scaffold E2E automation
```
