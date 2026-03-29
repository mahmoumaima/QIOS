---
name: qa-test-designer
description: >
  Generate a complete test plan and structured test cases from a User Story,
  Jira ticket, or feature description. Use this skill whenever the user wants
  to design tests for a feature, requirement, or business rule. Triggers on:
  "generate test plan", "write test cases for this US", "what to test for this
  feature", "create test scenarios", "design tests for this ticket", "test this
  user story", "test plan for this feature", "test cases from acceptance criteria",
  "QA coverage for this requirement". Always use this skill before writing
  test cases manually from a spec or ticket.
---

# QA Test Designer

## Purpose

Transform a User Story, acceptance criteria, or feature description into a
structured, complete, ready-to-execute test plan — with risk levels, flags,
and coverage analysis.

---

## Input Accepted

- User Story format: `As a [role] / I want [action] / So that [benefit]`
- Acceptance criteria (bullet points or Given/When/Then)
- Jira ticket content (paste the full description)
- Feature description in plain language
- Epic or business requirement document excerpt

---

## Analysis Process

### Step 1 — Parse and Structure

Extract:
```
Feature      : What is being built?
Actor(s)     : Who uses it? Which roles?
Goal         : What outcome is expected?
Business Rules: Constraints, limits, conditions
Data         : Input fields, output fields, data types
Risks        : What can go wrong? What is the impact?
Dependencies : Other features, services, or data required
```

Flag immediately — do not assume:
```
[MISSING]    : Information needed to test but not provided
[AMBIGUOUS]  : Requirement that is unclear or contradictory
[ASSUMPTION] : What is being assumed to proceed
```

### Step 2 — Coverage Strategy

Define which test types are needed:
```
Functional   → Core behavior: does it do what the spec says?
Boundary     → Min/max values, limits, thresholds
Negative     → Wrong input, missing data, broken flows
Integration  → Interaction with other components or services
Security     → Auth, permissions, data access
Performance  → Response time, throughput (flag if needed, mark as out of scope if not)
```

### Step 3 — Generate Test Cases

Use the structure from `../../_shared/test-case-template.md`.

Minimum per feature:
- 1 happy path (P1)
- 1 negative per business rule (P1)
- 1 boundary per numeric/date field (P2)
- 1 auth/permission check if applicable (P1 — CRITICAL)

---

## Output Format

### Test Plan Header

```
═══════════════════════════════════════════
 TEST PLAN
 Feature      : [Feature Name]
 Reference    : [US-XXX / JIRA-XXX]
 Date         : [Date]
 Total Cases  : [N]
 Coverage     : Functional ✅  Boundary ✅  Negative ✅  Security ⚠️
 Flags        : [N] MISSING  [N] AMBIGUOUS  [N] ASSUMPTION
═══════════════════════════════════════════
```

### Test Cases Table

```
| ID           | Title                                 | Category   | Priority | Expected Result                  | Risk     |
|--------------|---------------------------------------|------------|----------|----------------------------------|----------|
| TC-[MOD]-001 | [Title]                               | Happy Path | P1       | [Expected]                       | [Risk]   |
```

### Flags Section

```
[MISSING]    : ...
[AMBIGUOUS]  : ...
[ASSUMPTION] : ...
```

### Optional Gherkin Export

Add at the end:
```
→ Run gherkin-spec-writer to convert these test cases to a .feature file
```

---

## References

- `references/test-case-template.md` — Full test case format
- `references/risk-classification.md` — Risk level definitions
- `../../_shared/test-case-template.md` — Shared source
- `../../_shared/qa-risk-classification.md` — Shared source
- `examples/input-user-story.md` — Example User Story input
- `examples/output-test-plan.md` — Example generated test plan
