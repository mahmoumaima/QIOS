# Gherkin Best Practices
# QIOS — gherkin-spec-writer

---

## File and Feature Rules

- One Feature per `.feature` file
- File name matches the feature: `money-transfer.feature`, `user-login.feature`
- One clear business goal per Feature
- Feature title is a noun phrase: `Money Transfer`, not `Test the transfer`

---

## Scenario Rules

- Title must be unique and self-explanatory without reading the steps
- Maximum 7 steps per scenario — split if longer
- One behavior tested per scenario — not multiple assertions about different things
- No scenario should depend on another — each is fully independent
- Scenarios ordered: Happy Path → Negative → Boundary → Security → Edge

---

## Step Writing Rules

### Given — Describes system state (not past actions)

```gherkin
# ✅ Correct — describes a state
Given the user has a balance of 1000 USD
Given the product "SKU-123" is in stock
Given the user "usr_456" has an active account

# ❌ Wrong — describes a past action
Given the user deposited 1000 USD
Given the admin added the product to the catalogue
```

### When — Single user action

```gherkin
# ✅ Correct — one action
When the user submits the transfer form
When the user clicks "Confirm"

# ❌ Wrong — multiple actions combined
When the user fills the form and clicks submit and confirms via SMS
```

### Then — Observable, user-facing outcome

```gherkin
# ✅ Correct — observable, verifiable
Then the confirmation message "Transfer confirmed" is displayed
Then the user balance is 4900 USD
Then the API returns status 200 with a transaction_id

# ❌ Wrong — internal implementation detail
Then the transactions table has a new record
Then the database is updated
```

### And / But — Continuation of same step type

```gherkin
# ✅ Correct
Then the transfer is confirmed
And the sender receives a notification
But the original balance is not restored

# ❌ Wrong — And changes step type
When the user clicks submit
And the system should display a message  ← this is a Then, not a When
```

---

## Background Rules

- Use only for preconditions truly shared by ALL scenarios in the file
- Maximum 3 steps in Background
- If a precondition applies to only some scenarios → keep it inside those scenarios

```gherkin
# ✅ Good — truly shared
Background:
  Given the user is authenticated

# ❌ Bad — too specific, not shared by all
Background:
  Given the user has a balance of 10000 USD
  And the recipient "usr_456" is active
  And the daily limit is not reached
```

---

## Scenario Outline Rules

Use when 3 or more scenarios share the same flow but differ only by data:

```gherkin
# ✅ Good use — multiple data sets
Scenario Outline: Amount boundary validation
  When the user transfers <amount> USD
  Then the result is <expected>

  Examples:
    | amount | expected |
    | 0      | rejected |
    | 1      | accepted |
    | 10000  | accepted |
    | 10001  | rejected |

# ❌ Wrong — only 2 rows → use two regular Scenarios instead
```

---

## Common Mistakes

| Mistake | Correct Approach |
|---|---|
| Technical details in `Then`: "DB record is saved" | Write what user sees: "transaction appears in history" |
| Giant scenario with 15+ steps | Split into multiple focused scenarios |
| Hardcoded test data scattered everywhere | Use Examples table or named fixtures |
| Vague `Then`: "the system works" | Be specific: `the order status is "confirmed"` |
| Multiple actions in one `When` | One `When` = one action |
| Background used for business-specific setup | Keep specific setup in the scenario itself |
| Duplicate Background steps inside scenarios | Remove from scenario if already in Background |
