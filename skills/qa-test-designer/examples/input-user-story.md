# Example Input — qa-test-designer

## User Story

```
US-042: Money Transfer

As a mobile application user,
I want to transfer money to another registered user,
So that I can send funds instantly and securely.

Acceptance Criteria:
- The user must be authenticated to perform a transfer
- The transfer amount must be between 1 and 10,000 USD
- The recipient must have an active account in the system
- The user must have sufficient balance to cover the transfer amount
- On success, the sender receives an in-app notification
- On success, the recipient receives an in-app notification
- A transaction record is created and visible in the history
- The operation must complete within 5 seconds
```

## Additional Context

- This feature is part of the Wallet module
- It depends on: Auth service, User service, Notification service, Transaction DB
- Financial data — audit log required for every transaction
