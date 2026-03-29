# Gherkin Tagging Strategy
# QIOS — gherkin-spec-writer

---

## Tag Definitions

| Tag | Purpose | When to apply |
|---|---|---|
| `@smoke` | Critical path — run on every deployment | The single most important scenario per feature — happy path only |
| `@regression` | Full regression suite | All scenarios that should run before every release |
| `@critical` | Feature cannot ship if this fails | Auth, financial flows, data integrity, core business rules |
| `@high` | Important but not blocking alone | Secondary business rules, key validations |
| `@negative` | Negative test case | Any scenario testing invalid input or error handling |
| `@boundary` | Boundary value test | Min/max value scenarios, numeric thresholds |
| `@security` | Security / auth test | Authentication, authorization, injection, IDOR |
| `@api` | API-level test (no UI) | Scenarios testing API responses directly |
| `@ui` | UI / browser test | Scenarios testing visual elements or user interactions |
| `@mobile` | Mobile application test | Scenarios specific to mobile behavior |
| `@integration` | Cross-service test | Scenarios testing interaction between multiple services |
| `@performance` | Response time / load | Scenarios with timing or throughput assertions |
| `@edge` | Edge case | Null, empty, special characters, concurrent requests |
| `@wip` | Work in progress | Scenarios not yet stable — excluded from automated runs |

---

## Tagging Rules

1. **Always tag `@smoke`** on the main happy path of every feature (max 1-2 per feature)
2. **Always tag `@critical`** on any scenario that would block the app if it failed
3. **Never combine `@smoke` and `@negative`** — smoke tests are happy path only
4. **Remove `@wip`** before merging to main branch
5. **Maximum 3 tags per scenario** — if you need more, the scenario is likely too broad

---

## Tag Combinations

| Scenario Type | Typical Tags |
|---|---|
| Main happy path | `@smoke @critical` |
| Secondary happy path | `@regression` |
| No auth token | `@negative @critical @security` |
| Missing required field | `@negative @high` |
| Boundary min/max | `@boundary @regression` |
| SQL injection | `@security @critical` |
| IDOR check | `@security @critical` |
| Edge: null vs empty | `@edge @regression` |
| Performance threshold | `@performance @regression` |

---

## Execution Example

```yaml
# Run only smoke tests for a quick validation pass
cypress run --env tags="@smoke"

# Run full regression before release
cypress run --env tags="@regression"

# Run security-focused scenarios
cypress run --env tags="@security"

# Exclude WIP from all automated runs
cypress run --env tags="not @wip"
```
