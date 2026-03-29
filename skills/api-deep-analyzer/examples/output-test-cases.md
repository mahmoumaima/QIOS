# Example Output — api-deep-analyzer
# Endpoint: POST /wallet/cashout

## API Profile

```
Method        : POST
Path          : /wallet/cashout
Auth          : Bearer token (required)
Body Fields   : amount (number, required), currency (string, required), recipient_id (string, required)
Business Goal : Withdraw funds from a user's wallet to a recipient
Sensitive Data: Financial transaction — audit log required
Dependencies  : Wallet service, User service, Transaction DB, Notification service
```

---

## Test Cases

| ID             | Category   | Scenario                                    | Test Data                                      | Expected Result                             | Risk     |
|----------------|------------|---------------------------------------------|------------------------------------------------|---------------------------------------------|----------|
| TC-CASH-001    | Happy Path | Valid cashout — standard                    | amount:100, currency:USD, valid token          | 200 + `{transaction_id, status:"pending"}`  | HIGH     |
| TC-CASH-002    | Happy Path | Cashout at minimum amount                   | amount:1, currency:USD, valid token            | 200 + transaction created                   | HIGH     |
| TC-CASH-003    | Happy Path | Cashout at maximum amount                   | amount:10000, currency:USD, valid token        | 200 + transaction created                   | HIGH     |
| TC-CASH-004    | Negative   | Missing field: amount                       | body without amount                            | 400 + `{"error": "amount is required"}`     | HIGH     |
| TC-CASH-005    | Negative   | Missing field: currency                     | body without currency                          | 400 + `{"error": "currency is required"}`   | HIGH     |
| TC-CASH-006    | Negative   | Missing field: recipient_id                 | body without recipient_id                      | 400 + `{"error": "recipient_id required"}`  | HIGH     |
| TC-CASH-007    | Negative   | No authentication token                     | no Authorization header                        | 401 Unauthorized                            | CRITICAL |
| TC-CASH-008    | Negative   | Expired token                               | expired JWT in Authorization                   | 401 Unauthorized                            | CRITICAL |
| TC-CASH-009    | Negative   | Invalid token format                        | Authorization: Bearer invalid_xyz              | 401 Unauthorized                            | CRITICAL |
| TC-CASH-010    | Negative   | Insufficient balance                        | amount: 999999, user balance: 200              | 422 + `{"error": "Insufficient balance"}`   | CRITICAL |
| TC-CASH-011    | Negative   | Recipient does not exist                    | recipient_id: "unknown_user"                   | 404 + recipient not found error             | HIGH     |
| TC-CASH-012    | Negative   | Wrong field type: amount is a string        | amount: "one hundred"                          | 400 + type validation error                 | MEDIUM   |
| TC-CASH-013    | Boundary   | Amount = 0                                  | amount: 0                                      | 400 + amount must be greater than 0         | HIGH     |
| TC-CASH-014    | Boundary   | Amount = -1 (negative)                      | amount: -1                                     | 400 + amount must be positive               | HIGH     |
| TC-CASH-015    | Boundary   | Amount = 10001 (above max)                  | amount: 10001                                  | 422 + exceeds maximum per transaction       | MEDIUM   |
| TC-CASH-016    | Edge       | amount is null                              | amount: null                                   | 400 + validation error                      | MEDIUM   |
| TC-CASH-017    | Edge       | amount is empty string                      | amount: ""                                     | 400 + validation error                      | MEDIUM   |
| TC-CASH-018    | Edge       | Duplicate request within 1 second           | same body sent twice immediately               | 409 Conflict                                | HIGH     |
| TC-CASH-019    | Security   | SQL injection in recipient_id               | recipient_id: `' OR '1'='1`                    | 400, no DB error exposed in response        | CRITICAL |
| TC-CASH-020    | Security   | XSS in recipient_id                         | recipient_id: `<script>alert(1)</script>`      | 400, no script execution                    | CRITICAL |
| TC-CASH-021    | Security   | IDOR: access another user's wallet          | valid token for user_B accessing user_A wallet | 403 Forbidden                               | CRITICAL |
| TC-CASH-022    | Security   | Rate limiting                               | 15 identical requests in 1 second             | 429 Too Many Requests after threshold       | HIGH     |

---

## Flags

```
[MISSING]    : What is the exact daily withdrawal limit per user?
[MISSING]    : Is there a currency whitelist? Which currencies are accepted?
[MISSING]    : What happens if the notification service is down — is the transaction still created?
[ASSUMPTION] : Minimum amount is 1 USD (not specified in input)
[ASSUMPTION] : Maximum per transaction is 10,000 USD (stated in business context)
[ASSUMPTION] : Duplicate identical request within 1 second returns 409 Conflict
```
