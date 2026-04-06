# QIOS — Architecture

> **Navigation:** [← README](../README.md) · [Usage Guide →](usage.md) · [Examples →](examples.md)

---

## Table of Contents

- [Overview](#overview)
- [Loading Mechanism](#loading-mechanism)
- [Skill Selection Flow](#skill-selection-flow)
- [Directory Structure](#directory-structure)
- [Skill Anatomy](#skill-anatomy)
- [_shared vs references](#shared-vs-references)
- [QA Workflow Integration](#qa-workflow-integration)

---

## Overview

QIOS operates as a three-layer memory system for AI agents:

```mermaid
graph TD
    subgraph Layer1["Layer 1 — Always loaded"]
        A[AGENTS.md\nGlobal rules · Output standards · Skill priority]
    end

    subgraph Layer2["Layer 2 — Skill index"]
        B[Skill metadata\nname + description only ~100 words each]
    end

    subgraph Layer3["Layer 3 — On demand"]
        C[Full SKILL.md body]
        D[references/ files]
        E[examples/ files]
    end

    Layer1 --> Layer2 --> Layer3

    style Layer1 fill:#2D6BE4,color:#fff
    style Layer2 fill:#F0F4FF,color:#1A1A2E
    style Layer3 fill:#F8F9FB,color:#1A1A2E
```

---

## Loading Mechanism

| Level | Content | When loaded | Size |
|---|---|---|---|
| **1** | `AGENTS.md` | Every session — always | ~500 words |
| **2** | Skill `name` + `description` (all skills) | Every session — always | ~100 words/skill |
| **3** | Full `SKILL.md` body + `references/` | Only when skill is triggered | Variable |

**Key principle:** The AI never loads everything at once.
It selects the right skill, then reads only what it needs for the task.

---

## Skill Selection Flow

```mermaid
flowchart TD
    A([User request]) --> B[AI reads all skill metadata
name + description]
    B --> C{Which skill matches?}

    C -->|analyze this API| D[api-deep-analyzer]
    C -->|generate Postman collection| E[api-spec-generator]
    C -->|test cases for this US| F[qa-test-designer]
    C -->|write Gherkin scenarios| G[gherkin-spec-writer]
    C -->|scaffold Cypress project| H[cypress-test-bootstrap]
    C -->|scaffold Playwright project| I[playwright-test-bootstrap]
    C -->|no match| J[Answer directly
no skill loaded]

    D & E & F & G & H & I --> K[Load full SKILL.md]
    K --> L[Load referenced files
if needed]
    L --> M([Structured QA output])

    style A fill:#2D6BE4,color:#fff
    style M fill:#2D6BE4,color:#fff
    style J fill:#F8F9FB,color:#1A1A2E
```

---

## Directory Structure

```mermaid
graph TD
    ROOT["QIOS/"] --> AGENTS["AGENTS.md\nGlobal AI contract"]
    ROOT --> SKILLS["skills/"]
    ROOT --> DOCS["docs/"]
    ROOT --> TEMPLATES["templates/"]
    ROOT --> EXAMPLES["examples/"]

    SKILLS --> SHARED["_shared/\nShared references\nacross all skills"]
    SKILLS --> S1["api-deep-analyzer/"]
    SKILLS --> S2["api-spec-generator/"]
    SKILLS --> S3["qa-test-designer/"]
    SKILLS --> S4["gherkin-spec-writer/"]
    SKILLS --> S5["cypress-test-bootstrap/"]
    SKILLS --> S6["playwright-test-bootstrap/"]

    S1 --> SM["SKILL.md ✅ required"]
    S1 --> SRM["README.md"]
    S1 --> SEX["examples/"]
    S1 --> SREF["references/"]
    S1 --> SSCR["scripts/"]

    SHARED --> SH1["api-testing-checklist.md"]
    SHARED --> SH2["qa-risk-classification.md"]
    SHARED --> SH3["test-case-template.md"]
    SHARED --> SH4["gherkin-style-guide.md"]

    style ROOT fill:#2D6BE4,color:#fff
    style SHARED fill:#E8F0FE,color:#1A1A2E
    style SM fill:#2D6BE4,color:#fff
```

---

## Skill Anatomy

Every skill follows the same structure:

```mermaid
graph LR
    subgraph Skill["skill-name/"]
        direction TB
        A["SKILL.md\n─────────\nfrontmatter: name, description\nbody: process, output format,\nreferences list\n✅ Required"]
        B["README.md\n─────────\nHuman documentation\nWhen to use · How to trigger\nWhat you get · Related skills"]
        C["examples/\n─────────\ninput-*.md — example input\noutput-*.md — example output\n*.json / *.feature / *.cy.js / *.spec.ts"]
        D["references/\n─────────\nChecklist, standards,\nconventions, style guides\nLoaded only when needed"]
        E["scripts/\n─────────\nBash scripts\nScaffold, validate,\ngenerate files"]
    end

    style A fill:#2D6BE4,color:#fff
    style Skill fill:#F0F4FF
```

### SKILL.md frontmatter

```yaml
---
name: skill-identifier          # Short name — used for skill selection
description: >                  # PRIMARY triggering mechanism
  What this skill does.         # Be specific — include real trigger phrases
  When to use it.               # The AI matches user requests against this
  Triggers on: "phrase 1",
  "phrase 2", "phrase 3".
---
```

---

## _shared vs references

```mermaid
graph TD
    SHARED["skills/_shared/\nSource of truth\nUsed by multiple skills"]
    S1REF["api-deep-analyzer/references/\nLocal copy or pointer\nCan add skill-specific content"]
    S2REF["qa-test-designer/references/\nLocal copy or pointer"]
    S3REF["gherkin-spec-writer/references/\nLocal copy or pointer"]

    SHARED -->|referenced via\n../../_shared/| S1REF
    SHARED -->|referenced via\n../../_shared/| S2REF
    SHARED -->|referenced via\n../../_shared/| S3REF

    style SHARED fill:#2D6BE4,color:#fff
```

| Location | Purpose | Update strategy |
|---|---|---|
| `skills/_shared/` | Master reference — single source of truth | Edit here only |
| `skills/[name]/references/` | Local pointer + skill-specific additions | Point to `_shared/`, extend if needed |

---

## QA Workflow Integration

QIOS skills map directly to a complete QA workflow:

```mermaid
flowchart LR
    US["User Story
or Jira Ticket"] --> QTD["qa-test-designer
─────────────
Test plan
+ risk tagging
+ flags"]

    QTD --> GSW["gherkin-spec-writer
─────────────
.feature file
BDD scenarios
tagged + structured"]

    EP["API Endpoint
or Swagger"] --> ADA["api-deep-analyzer
─────────────
Full test cases
happy/neg/edge/security"]

    EP --> ASG["api-spec-generator
─────────────
Postman collection
or Bruno .bru files"]

    QTD & GSW & ADA --> CTB["cypress-test-bootstrap
─────────────
E2E spec files
project scaffold"]
    QTD & GSW & ADA --> PTB["playwright-test-bootstrap
─────────────
E2E spec files
project scaffold"]

    style US fill:#F0F4FF
    style EP fill:#F0F4FF
    style QTD fill:#E8F0FE
    style GSW fill:#E8F0FE
    style ADA fill:#E8F0FE
    style ASG fill:#E8F0FE
    style CTB fill:#2D6BE4,color:#fff
    style PTB fill:#0E6FFF,color:#fff
```

Each skill output feeds naturally into the next.
A single feature can flow through all 6 skills in sequence.

---

> **Navigation:** [← README](../README.md) · [Usage Guide →](usage.md) · [Examples →](examples.md)
