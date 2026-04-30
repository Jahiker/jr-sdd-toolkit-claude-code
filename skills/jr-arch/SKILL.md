---
name: jr-arch
description: Use when the user runs /jr-arch or wants to define the technical architecture of a new project. Triggers: "define architecture", "what stack", "how to structure", "system design", /jr-arch.
---

# jr-arch

Define technical architecture based on the product vision. Second step of the project kickoff flow.

**Flow:** `jr-vision → [jr-arch] → jr-roadmap → jr-build-spec → jr-exe-spec → jr-verify-spec`

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md if it exists.
- Read docs/vision.md — if missing, ask user to run /jr-vision first (or share file manually).
- Write docs/architecture.md in Docs language. Update PROJECT.md (especially Toolkit Context block).
- Justify every tech decision — reasoning matters as much as the choice.

## Steps

**0. Read context**
Read docs/vision.md fully. Check for existing code (package.json, composer.json, etc.). Identify: system type, usage patterns, external integrations mentioned, technical constraints.

**1. Ask only necessary questions** (in user's language)
- 🛠️ Stack & team: technologies the team knows, stack preferences
- 🏗️ Infra & scale: deployment target, expected initial scale
- 🔗 Integrations: critical external integrations not in vision
- 🔐 Security: auth, roles, sensitive data (only if not clear)

**2. Build docs/architecture.md**

> ⚠️ Mandatory. Create docs/ if needed. Write without asking. Skill does not finish until file exists on disk.

Sections:
```
# System Architecture — [Name]
Status: Draft | Version: 1.0 | Date | Author: jr-arch | Based on: docs/vision.md

1. Executive summary (2-3 sentences: system type + main decisions)
2. System type (category, pattern, justification)
3. Tech stack — tables with columns: Decision | Technology | Justification
   Frontend (framework, language, styles, build tool, state mgmt)
   Backend (framework, language, API style, auth)
   Database (engine, ORM, migrations)
   Infrastructure (hosting, containers, CI/CD)
   Testing (unit, integration, E2E — tool + scope per level)
4. System architecture
   High-level diagram (ASCII)
   Main modules (table: module | responsibility | technology)
   Main data flow (how a request travels through the system)
5. Directory structure (annotated tree 2-3 levels)
6. Initial data model — MVP entities only
   Per entity: field | type | description | constraints
   Relationships list
7. Fundamental technical decisions
   Per decision: Decision | Context | Alternatives considered | Justification | Consequences
8. Project conventions (naming, imports, exports, commits, git branches)
9. Security (auth, authorization, sensitive data, env vars policy)
10. Known technical debt from start (what's simplified for MVP + when to revisit)
11. Pending questions (remove if none)
History table
```

**3. Update PROJECT.md**
Update Toolkit Context block with: Docs language, Stack (one-line), Architecture (one-line), Conventions (one-line). If PROJECT.md doesn't exist, create it using jr-init template.

**4. Confirm**
Respond in user's language with stack summary and next step: `/jr-roadmap`.

## Principles
- Justify everything. No decision without reasoning.
- MVP first — don't architect for non-existent scale.
- Conscious technical debt is fine; unconscious debt kills projects.
