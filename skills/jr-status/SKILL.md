---
name: jr-status
description: Use when the user runs /jr-status or wants a dashboard of all project specs. Triggers: "spec status", "see specs", "what specs exist", "specs dashboard", "what's pending", "project summary", /jr-status. No arguments required.
---

# jr-status

Scan all specs in specs/, classify by status, generate an actionable dashboard. Read only — never modifies files.

## Rules
- Respond entirely in user's conversation language.
- Read `## Toolkit Context` from PROJECT.md for project name and context.
- If specs/ doesn't exist or is empty → tell user, suggest `/jr-build-spec` to create first spec.

## Step 1 — Read and classify specs

For each .md in specs/ (main dir + sketches/ + fixes/, each scanned separately), read: Status, Version, Date, Related specs, title, Pending Questions section ([PENDING] items?), Delta section, Affected Files count, last History entry. For sketches, also read the `Readiness Report` block if present (overall score).

**Status classification:**
| Label | Criterion |
|---|---|
| ⏳ PENDING | Status: Pending (roadmap placeholder, spec not built yet) |
| 📝 SKETCH | File in specs/sketches/ — built with --dev and scored <60 |
| 🟡 DRAFT | Status: Draft, no critical [PENDING] |
| 🟠 NEEDS WORK | Status: Draft with `Readiness: Needs work` flag (score 60–74 in --dev) |
| 🔴 BLOCKED | Status: Draft + [PENDING] in FRs or Technical Design |
| 🔵 IMPLEMENTED | Status: Implemented |
| ✅ VERIFIED | Status: Verified |
| ⚠️ ATTENTION | Any status + critical issues or unresolved verification gaps |

## Step 2 — Generate dashboard (in user's language)

```
📊 [Project name] — Spec Status
[Date] | Total specs: N | Mode: [default|dev]

Summary: ✅ N | 🔵 N | 🟡 N | 🟠 N | ⏳ N | 📝 N | 🔴 N | ⚠️ N

--- Specs by status ---

✅ VERIFIED
| Spec | Version | Last action | Files |

🔵 IMPLEMENTED
| Spec | Version | Last action | Files | → /jr-verify-spec |

🟡 DRAFT
| Spec | Version | Date | Pending | → /jr-exe-spec |

🟠 NEEDS WORK (--dev only)
| Spec | Version | Score | Top blocker | → /jr-build-spec --dev to improve |

⏳ PENDING
| Spec | Roadmap # | Depends on | → /jr-build-spec |

📝 SKETCH (--dev only, in specs/sketches/)
| Spec | Score | Top blocker | → /jr-build-spec @specs/sketches/x.md --dev to iterate |

🔴 BLOCKED
| Spec | Version | Unresolved items | → Resolve then /jr-exe-spec |

⚠️ NEEDS ATTENTION
| Spec | Version | Problem | → Suggested action |

--- Dependencies ---
[Only specs with declared dependencies]
`specs/a.md` depends on → `specs/b.md` [status]

--- Fix reports (specs/fixes/) ---
| Report | Status | Date |
(skip section if none)

--- Recommended next steps ---
1. [URGENT] ...
2. [QUICK WIN] ...
3. [DEBT] ...
4. [ITERATION] ...

--- Stats ---
Total: N (incl. M sketches) | Verified: X% | Unverified implemented: N | Blocked: N | Open fixes: N
Most recent: `specs/name.md` — N days ago
```

## Step 3 — Detect anomalies (append if found)

- **Orphan specs**: declare dependency on a spec that doesn't exist in specs/
- **Stale drafts**: Draft status with 30+ days of inactivity
- **Missing History**: specs without `## History` section (pre-v2 toolkit)
- **Pending placeholders**: placeholders without roadmap reference
