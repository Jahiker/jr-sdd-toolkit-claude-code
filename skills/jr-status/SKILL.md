---
name: jr-status
description: >
  Use this skill whenever the user runs /jr-status or wants to see the overall state of the project's specs. Triggered by phrases like "spec status", "see specs", "what specs are there", "specs dashboard", "which are pending", "what's left to implement", "project summary", or when /jr-status is mentioned. Requires no arguments — scans the specs/ directory of the current project, reads all specs, and generates a visual dashboard with status, version, pending items, and actionable next steps for each spec.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Generate the entire dashboard output in the user's conversation language.
  Read project name and context from PROJECT.md if available.
---

# jr-status

Project visibility skill. Scans all specs in the `specs/` directory, classifies them by status, and generates an actionable dashboard that shows at a glance what's done, what's in progress, and what has pending debt.

---

## Step 0 — Verify specs exist

1. Look for the `specs/` directory in the project root.
2. If it doesn't exist or is empty, respond in the user's language:
   > [Tell them no specs found yet, and suggest /jr-build-spec to create the first one]
   Stop here.
3. List all `.md` files inside `specs/` (excluding `specs/fixes/` from the main count — handle separately).

---

## Step 1 — Read and classify each spec

For each `.md` file in `specs/`, read:
- `**Status:**` — Draft / Implemented / Verified / Pending
- `**Version:**`
- `**Date:**`
- `**Related specs:**`
- Title (first line `# Title`)
- `## 10. Pending Questions` section — any `[PENDING]` items?
- `## Delta` section — does it exist? How many changes?
- `## Affected Files` section — how many files does it touch?
- Last entry of `## History` — last action and date

Classify each spec in one of these statuses:

| Status | Criterion |
|---|---|
| ⏳ **PENDING** | Status: Pending (placeholder created by jr-roadmap, spec not built yet) |
| 🟡 **DRAFT** | Status: Draft, no critical [PENDING] items |
| 🔴 **DRAFT — BLOCKED** | Status: Draft, has [PENDING] items in FRs or Technical Design |
| 🔵 **IMPLEMENTED** | Status: Implemented |
| ✅ **VERIFIED** | Status: Verified |
| ⚠️ **NEEDS ATTENTION** | Any status with critical [PENDING] items or gaps reported by jr-verify-spec |

Also scan `specs/fixes/` and classify fix reports by their status (Resolved / Open).

---

## Step 2 — Generate the dashboard

Present entirely in the user's conversation language:

```
[Dashboard title — Project name or root directory]
[Date | Total specs: N]

[Summary table: ✅ Verified | 🔵 Implemented | 🟡 Draft | ⏳ Pending | 🔴 Blocked | ⚠️ Attention]

[Specs by status — tables per group:]

  ✅ Verified
  | Spec | Version | Last action | Files |

  🔵 Implemented
  | Spec | Version | Last action | Files | Suggested action |
  (suggest /jr-verify-spec for each)

  🟡 Draft
  | Spec | Version | Date | Pending items | Suggested action |
  (suggest /jr-exe-spec for each)

  ⏳ Pending
  | Spec | Roadmap # | Depends on | Suggested action |
  (suggest /jr-build-spec for each)

  🔴 Draft — Blocked
  | Spec | Version | Unresolved pending | Suggested action |

  ⚠️ Needs Attention
  | Spec | Version | Detected problem | Suggested action |

[Dependencies between specs — only specs with declared dependencies]

[Fix reports (specs/fixes/) — if any exist]
  | Fix report | Status | Date |

[Recommended next steps — ordered by priority and unblockability]
  1. [URGENT] ...
  2. [QUICK WIN] ...
  3. [DEBT] ...

[Project statistics]
  - Total specs: N
  - Verified coverage: X% (verified / total)
  - Technical debt: X implemented specs not yet verified
  - Blocked specs: X
  - Most recent feature: `specs/name.md` — X days ago
  - Open fix reports: X
```

---

## Step 3 — Detect anomalies

Report if detected, in the user's language:

**Orphan specs:** specs that declare a dependency on another spec that doesn't exist in `specs/`.

**Very old drafts:** specs in Draft status with more than 30 days of inactivity.

**Specs without History:** specs that don't have the `## History` section (generated before toolkit v2).

**Pending specs with no roadmap reference:** placeholder specs that don't mention which roadmap number they belong to.

---

## Principles

- **Read only, never modify**: this skill is for observability — it doesn't touch any file.
- **Actionable over informative**: every dashboard item has a concrete suggested action.
- **Honest about debt**: don't hide specs with problems — visibility is the goal.
- **Speaks the user's language**: the entire output is in the conversation language, regardless of the language specs were written in.
