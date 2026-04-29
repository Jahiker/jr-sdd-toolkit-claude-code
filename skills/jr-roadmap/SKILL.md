---
name: jr-roadmap
description: >
  Use this skill whenever the user runs /jr-roadmap or wants to break down a product into executable, ordered features. Triggered by phrases like "make the roadmap", "plan the project", "what to build first", "break down the product", "project backlog", "development order", or when /jr-roadmap is mentioned. Reads docs/vision.md and docs/architecture.md, breaks the product down into epics and features, orders them by technical dependencies and value, and produces an actionable roadmap with the recommended execution order. At the end, the user can run jr-build-spec on each feature in order. It is the third step of the project kickoff flow.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Read PROJECT.md at the start — write all generated files in the "Docs language" defined there.
  If not set, use the user's conversation language for generated files.
---

# jr-roadmap

Third skill in the project kickoff flow. With vision and architecture defined, breaks the product into epics and features, orders them by dependencies and value delivered, and produces the work map that guides the rest of the toolkit.

**Position in the flow:**
```
jr-vision → jr-arch → [jr-roadmap] → jr-build-spec → jr-exe-spec → jr-verify-spec
```

---

## Step 0 — Validate input

```
/jr-roadmap
```

No arguments required. Automatically looks for `docs/vision.md` and `docs/architecture.md`.

If either is missing, respond in the user's language indicating which documents are missing and which commands to run first.

Read both documents completely before continuing. Also read `PROJECT.md` for the Docs language.

---

## Step 1 — Extract features from vision and architecture

Based on both documents, list all identified features:

- From the **MVP** in the vision (section 6)
- From the **modules** in the architecture (section 4)
- From the **data model entities** (architecture section 6)
- **Implicit technical features** not in the vision but necessary (authentication, base infrastructure, etc.)

Present the list to the user in their conversation language before ordering:

```
[List of identified features grouped by: Technical (infrastructure), MVP (product), Phase 2]

[Ask if anything is missing or if they want to add/remove before ordering]
```

Wait for confirmation or adjustments before continuing.

---

## Step 2 — Order by dependencies and value

For each feature, evaluate:

**Technical dependencies:** What must exist before this can be built?
**Value delivered:** How much value does it bring to the end user? (High / Medium / Low)
**Technical complexity:** (High / Medium / Low)

Order features respecting dependencies and prioritizing value over complexity.

---

## Step 3 — Build the roadmap

Write in the **Docs language** from PROJECT.md.

```markdown
# Roadmap — [Project Name]

**Status:** Active
**Date:** YYYY-MM-DD
**Author:** jr-roadmap
**Based on:** docs/vision.md · docs/architecture.md

---

## Summary

| Total features | MVP | Phase 2 | Technical |
|---|---|---|---|
| N | N | N | N |

**Estimated execution:** N weeks/sprints for complete MVP
*(Indicative estimate — adjust based on team velocity)*

---

## Epics

> An epic is a group of related features that together deliver a complete product capability.

### Epic 1: [Name] — [Technical foundation]
*[One-line description of what capability this epic delivers]*

### Epic 2: [Name] — [Main domain]
*[Description]*

---

## Execution order

### 🏗️ PHASE 0 — Foundation (nothing works without this)

| # | Feature | Epic | Value | Complexity | Depends on | Spec |
|---|---|---|---|---|---|---|
| 01 | Project setup and CI/CD | Foundation | — | Low | — | `specs/project-setup.md` |
| 02 | Authentication system | Foundation | High | Medium | 01 | `specs/authentication.md` |

### 🚀 PHASE 1 — MVP core (the minimum product that delivers value)

| # | Feature | Epic | Value | Complexity | Depends on | Spec |
|---|---|---|---|---|---|---|
| 03 | [Feature] | [Epic] | High | Medium | 02 | `specs/[name].md` |

### ✨ PHASE 2 — Extensions (expand MVP value)

| # | Feature | Epic | Value | Complexity | Depends on | Spec |
|---|---|---|---|---|---|---|
| N | [Feature] | [Epic] | Medium | Medium | 03 | `specs/[name].md` |

---

## Dependency map

```
01 (Setup)
 └── 02 (Auth)
      ├── 03 (Feature A)
      └── 04 (Feature B)
```

---

## How to use this roadmap with the toolkit

For each feature, in order:

```bash
# 1. Build the spec
/jr-build-spec @docs/[feature-description].md

# 2. Implement
/jr-exe-spec @specs/[name].md

# 3. Verify
/jr-verify-spec @specs/[name].md

# Check overall status
/jr-status
```

---

## Prioritization decisions

> Why things were ordered this way — useful to revisit if priorities change.

- **[Feature X] before [Feature Y]:** [technical or product reason]
- **[Feature Z] in Phase 2:** [why not in MVP]

---

## What's not in this roadmap

> Features consciously discarded and why.

- **[Discarded feature]:** [reason — scope, complexity, low priority]

---
## History

| Version | Date | Action |
|---|---|---|
| 1.0 | YYYY-MM-DD | Created by jr-roadmap |
```

---

## Step 4 — Create spec structure

> ⚠️ **Mandatory. Execute without asking.**

1. Create `specs/` if it doesn't exist (and `specs/fixes/`).
2. For each feature in the roadmap, create a placeholder file:
   ```
   specs/[feature-slug].md
   ```
   With this minimal content (in Docs language):
   ```markdown
   # [Feature Name]
   
   **Status:** Pending
   **Roadmap:** #[number] — [Epic]
   **Depends on:** [previous specs or "None"]
   
   > Spec pending creation. Run `/jr-build-spec` when it's this feature's turn according to the roadmap.
   ```
3. This makes `/jr-status` show all features from the start, even before their specs are complete.

---

## Step 5 — Save and confirm

> ⚠️ **Mandatory. Do not ask — execute directly.**

1. Save to `docs/roadmap.md`.
2. Confirm to the user in their conversation language with: phase summary, total features per phase, and what the first command to run is.

---

## Special cases

**Product is very large (more than 20 MVP features):**
Recommend reducing the MVP. A real MVP should be buildable in 4-6 weeks.

**No clear dependencies between features:**
Order by descending value — most valuable to the user first.

**User wants a different order than recommended:**
Accept the decision, document the reason in "Prioritization decisions" and adjust the dependency map.

**Existing code in the project:**
Identify which features are already (partially) implemented and mark them as `Status: Partial` in the placeholders.

---

## Principles

- **Order matters more than the list**: anyone can list features — the intelligence is in the order.
- **Dependencies first**: violating dependency order always costs more than it saves.
- **MVP is truly minimum**: if the MVP has more than 8-10 product features (excluding technical foundation), it's probably not minimal.
- **The roadmap is alive**: update it with `/jr-iterate-spec @docs/roadmap.md` if priorities change.
