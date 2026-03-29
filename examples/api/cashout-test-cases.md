# Example — API Test Cases
# POST /wallet/cashout

> Generated using QIOS api-deep-analyzer skill

## API Profile

```
Method        : POST
Path          : /wallet/cashout
Auth          : Bearer token (required)
Body          : { amount: number, currency: string, recipient_id: string }
Business Goal : Withdraw funds from a user's wallet to a recipient
Risk Domain   : Financial — audit log required
```

## Test Cases

| ID             | Category   | Scenario                                 | Test Data                             | Expected Result                               | Risk     |
|----------------|------------|------------------------------------------|---------------------------------------|-----------------------------------------------|----------|
| TC-CASH-001    | Happy Path | Valid cashout — standard amount          | amount:100, currency:USD, valid token | 200 + `{transaction_id, status:"pending"}`    | HIGH     |
| TC-CASH-002    | Happy Path | Cashout at minimum amount (1 USD)        | amount:1, valid token                 | 200 + transaction created                     | HIGH     |
| TC-CASH-003    | Happy Path | Cashout at maximum amount (10,000 USD)   | amount:10000, valid token             | 200 + transaction created                     | HIGH     |
| TC-CASH-004    | Negative   | Missing field: amount                    | body without amount                   | 400 + `{"error": "amount is required"}`       | HIGH     |
| TC-CASH-005    | Negative   | Missing field: currency                  | body without currency                 | 400 + `{"error": "currency is required"}`     | HIGH     |
| TC-CASH-006    | Negative   | Missing field: recipient_id              | body without recipient_id             | 400 + `{"error": "recipient_id is required"}` | HIGH     |
| TC-CASH-007    | Negative   | No authentication token                  | no Authorization header               | 401 Unauthorized                              | CRITICAL |
| TC-CASH-008    | Negative   | Expired token                            | expired JWT                           | 401 Unauthorized                              | CRITICAL |
| TC-CASH-009    | Negative   | Insufficient balance                     | amount > user balance                 | 422 + `{"error": "Insufficient balance"}`     | CRITICAL |
| TC-CASH-010    | Negative   | Recipient does not exist                 | recipient_id: "unknown_user"          | 404 + recipient not found                     | HIGH     |
| TC-CASH-011    | Negative   | Invalid field type: amount is string     | amount: "hundred"                     | 400 + type validation error                   | MEDIUM   |
| TC-CASH-012    | Boundary   | Amount = 0                               | amount: 0                             | 400 + amount must be > 0                      | HIGH     |
| TC-CASH-013    | Boundary   | Amount = -1 (negative)                   | amount: -1                            | 400 + amount must be positive                 | HIGH     |
| TC-CASH-014    | Boundary   | Amount = 10,001 (above max)              | amount: 10001                         | 422 + exceeds maximum                         | MEDIUM   |
| TC-CASH-015    | Edge       | amount is null                           | amount: null                          | 400 + validation error                        | MEDIUM   |
| TC-CASH-016    | Edge       | Duplicate request within 1 second        | same body sent twice                  | 409 Conflict                                  | HIGH     |
| TC-CASH-017    | Security   | SQL injection in recipient_id            | `' OR '1'='1`                         | 400, no DB error exposed                      | CRITICAL |
| TC-CASH-018    | Security   | IDOR — access another user's wallet      | user_B token on user_A wallet         | 403 Forbidden                                 | CRITICAL |

## Flags

```
[MISSING]    : Daily transfer limit per user — what is it and what error is returned?
[MISSING]    : Supported currency codes — is USD the only one?
[ASSUMPTION] : Maximum per transaction is 10,000 USD
[ASSUMPTION] : Idempotency expected — second identical request returns 409
```
