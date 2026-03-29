# Example Input — api-deep-analyzer

## Endpoint

```
POST /wallet/cashout
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "amount": 100,
  "currency": "USD",
  "recipient_id": "usr_123"
}
```

## Business Context

This endpoint processes a withdrawal from a user's wallet to an external recipient.
The system handles real financial transactions.
A transaction record must be created on success.
Users cannot withdraw more than their current balance.
Maximum withdrawal per transaction: 10,000 USD.
Minimum withdrawal: 1 USD.
