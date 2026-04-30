---
name: jr-build-spec
description: Use when the user runs /jr-build-spec or provides a rough requirement/user story to be refined into a professional spec. Triggers: "build spec", "refine requirement", "create spec", "analyze user story", /jr-build-spec.
---

# jr-build-spec

Transform rough requirements into professional technical specs.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → use Stack, Architecture, Conventions, Docs language.
- If no .md file provided, ask for it in user's language.
- Write spec files in Docs language.

## Steps

**0. Read input + context**
Read the requirement .md file and PROJECT.md Toolkit Context. Scan specs/ for existing specs (titles + FR sections only).

**1. Detect overlaps**
Check if existing specs cover similar functionality, are extended/modified by this requirement, could be broken by it, or must run before it. If found, report to user in their language and ask: new spec or integrate into existing? Wait for decision.

**2. Evaluate scope**
Warn if requirement touches 3+ modules, combines DB+API+UI+integrations, has implicit phases, or exceeds ~5 dev-days. Ask whether to split or continue as one spec. Respect user's decision.

**3. Ask categorized questions** (in user's language)
Only ask what's needed for verifiable acceptance criteria:
- 🙋 Client/PO: business, scope, expected behavior, users, constraints
- 🛠️ Dev/Architect: integrations, dependencies, design decisions

Accept partial answers. Unresolved items → `[PENDING]` in spec.

**4. Build spec**

> ⚠️ Mandatory. Create specs/ if needed. Write without asking. Do not request confirmation. Skill does not finish until file exists on disk. On write failure, show content in chat.

Write in Docs language. Filename: `specs/[kebab-case-slug].md`

```
# [Feature Name]
Status: Draft | Version: 1.0 | Date | Author: jr-build-spec
Related specs: [from overlap check or "None"]
Scope warning: [if applicable — remove line otherwise]

1. Executive Summary (2-3 sentences: what, why, expected outcome)
2. Context and Motivation (problem, affected users, business impact)
3. Goals (checklist)
4. Out of Scope (explicit exclusions)
5. Functional Requirements
   ### FR-01: [Name]
   Description + Acceptance Criteria checklist (AC-01, AC-02...)
   [repeat per FR]
6. Non-Functional Requirements (performance, security, scalability, compatibility)
7. Technical Design
   Architecture (how it fits the current system)
   Involved Components (table: component | role | required changes)
   Data Flow (main flow or pseudocode)
   Database Considerations ("No DB changes" if none)
   APIs / Integrations ("No API changes" if none)
8. Edge Cases and Error Handling (case → expected behavior)
9. Dependencies (specs to run first | internal | external | blockers)
10. Pending Questions (remove if none)
11. Additional Notes
History table (1.0 | date | Created | jr-build-spec)
```

Each FR needs at least one testable AC. Undefined items → `[TBD]` or `[PENDING]`.

**5. Confirm**
Respond in user's language. Next steps: `/jr-exe-spec @specs/[name].md` then `/jr-verify-spec @specs/[name].md`.
