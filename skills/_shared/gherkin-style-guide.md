# Gherkin Style Guide
# QIOS — Shared Reference

> Used by: gherkin-spec-writer, qa-test-designer

---

## File Structure

```gherkin
Feature: [Short feature name — noun phrase]
  As a [role]
  I want [action]
  So that [benefit]

  Background:
    Given [shared precondition — max 2-3 steps]

  @tag1 @tag2
  Scenario: [Descriptive title — what is being tested]
    Given [initial state of the system]
    When  [action performed by the actor]
    Then  [observable, verifiable outcome]
    And   [additional outcome]
    But   [excluded or negative outcome]
```

---

## Step Writing Rules

### Given — System state (not an action)
```gherkin
# ✅ Correct
Given the user has a balance of 1000 USD
Given the product "SKU-123" is in stock

# ❌ Wrong — describes past action, not state
Given the user deposited 1000 USD
Given the admin added the product
```

### When — Single user action
```gherkin
# ✅ Correct
When the user submits the transfer form with amount 500

# ❌ Wrong — multiple actions in one step
When the user fills the form and clicks submit and confirms via SMS
```

### Then — Observable outcome only
```gherkin
# ✅ Correct — visible to user or verifiable via API
Then the success message "Transfer confirmed" is displayed
Then the API returns status 200 with a transaction_id

# ❌ Wrong — internal detail not observable by user
Then the database record is updated in the transactions table
```

---

## Background Rules

- Use only for steps repeated across ALL scenarios in the feature
- Maximum 3 steps
- Never put business-specific setup in Background — put it in the scenario

```gherkin
# ✅ Good Background
Background:
  Given the user is authenticated
  And the application is available

# ❌ Bad Background — too specific, not shared by all scenarios
Background:
  Given the user has a balance of 5000
  And the recipient "usr_456" exists
  And the daily transfer limit is 10000
```

---

## Scenario Outline Rules

Use when:
- 3 or more scenarios differ only by input values
- Testing boundary values across a data range
- Testing the same flow with different user roles

```gherkin
# ✅ Good use
Scenario Outline: Validate amount boundaries
  When the user transfers <amount>
  Then the result is <result>

  Examples:
    | amount | result   |
    | 0      | rejected |
    | 1      | accepted |
    | 10000  | accepted |
    | 10001  | rejected |

# ❌ Bad use — only 2 rows, use regular Scenario instead
```

---

## Tagging Strategy

```
@smoke          Critical path — run on every deploy (max 5-10 scenarios)
@regression     Full suite — run before every release
@api            API-level test (no UI)
@ui             UI / browser test
@mobile         Mobile app test
@critical       Feature cannot ship if this fails
@negative       Negative test case
@boundary       Boundary value test
@security       Security / auth test
@integration    Cross-service test
@performance    Response time / load test
@wip            Work in progress — exclude from automated runs
```

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| Describing implementation in Then | Describe only observable user outcomes |
| Scenarios with 15+ steps | Split into smaller, focused scenarios |
| Hardcoded test data everywhere | Use Examples table or fixtures |
| Vague Then: "the system works correctly" | Be specific: `the order status is "confirmed"` |
| Mixing multiple actions in one When | One When = one action |
| Duplicating Background in scenarios | Remove from scenario, keep only in Background |
