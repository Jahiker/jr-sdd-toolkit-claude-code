---
name: jr-roadmap
description: Use when the user runs /jr-roadmap or wants to break a product into ordered executable features. Triggers: "make roadmap", "plan project", "what to build first", "feature backlog", "development order", /jr-roadmap.
---

# jr-roadmap

Break the product into epics and features, order by technical dependencies and value, produce an actionable roadmap. Third step of the project kickoff flow.

**Flow:** `jr-vision → jr-arch → [jr-roadmap] → jr-build-spec → jr-exe-spec → jr-verify-spec`

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md. Read docs/vision.md and docs/architecture.md fully.
- If either doc is missing, report which and which commands to run first.
- Write docs/roadmap.md in Docs language.

## Steps

**0. Extract all features**
From vision MVP section, architecture modules, data model entities, and implicit technical features (setup, auth, infra). Present list to user in their language grouped as: Technical (infra) | MVP (product) | Phase 2. Ask for confirmation or additions before ordering.

**1. Order by dependencies and value**
For each feature evaluate: technical dependencies (what must exist first), value to end user (High/Medium/Low), complexity (High/Medium/Low). Order respecting dependencies, prioritizing value.

**2. Build docs/roadmap.md**

> ⚠️ Mandatory. Create docs/ if needed. Write without asking. Skill does not finish until file exists on disk.

```
# Roadmap — [Name]
Status: Active | Date | Author: jr-roadmap | Based on: docs/vision.md · docs/architecture.md

Summary table: Total | MVP | Phase 2 | Technical | Estimated weeks for MVP

Epics section (one-liner per epic)

Execution order — 3 tables:
  🏗️ PHASE 0 — Foundation
  columns: # | Feature | Epic | Value | Complexity | Depends on | Spec file

  🚀 PHASE 1 — MVP core
  (same columns)

  ✨ PHASE 2 — Extensions
  (same columns)

Dependency map (ASCII tree)

How to use with toolkit:
  /jr-build-spec → /jr-exe-spec → /jr-verify-spec → /jr-status

Prioritization decisions (why ordered this way)
What's NOT in this roadmap (consciously discarded + reason)
History table
```

**3. Create spec placeholders**

> ⚠️ Mandatory. Execute without asking.

Create specs/ and specs/fixes/ if they don't exist. For each roadmap feature create `specs/[slug].md`:
```markdown
# [Feature Name]
**Status:** Pending
**Roadmap:** #[N] — [Epic]
**Depends on:** [specs or "None"]
> Pending spec. Run `/jr-build-spec` when it's this feature's turn.
```

**4. Confirm**
Respond in user's language: phase summary, total per phase, first command to run.

## Special cases
- MVP > 20 features → recommend reducing. Real MVP = 4-6 weeks of work.
- No clear dependencies → order by descending value.
- User wants different order → accept, document in prioritization decisions.
- Existing code → mark already-implemented features as `Status: Partial`.
