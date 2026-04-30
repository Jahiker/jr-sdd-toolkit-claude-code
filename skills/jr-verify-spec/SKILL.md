---
name: jr-verify-spec
description: Use when the user runs /jr-verify-spec or wants to verify that a spec's implementation covers its acceptance criteria. Triggers: "verify spec", "check acceptance criteria", "validate spec", "audit implementation", /jr-verify-spec.
---

# jr-verify-spec

Verify implemented spec coverage: walk the code, evaluate each AC, generate a coverage report, close the spec-driven loop.

Does not replace automated tests — complements them.

## Rules
- Respond to user in their conversation language. Generate all output in conversation language.
- Read `## Toolkit Context` from PROJECT.md at start.
- If no spec file provided, ask in user's language.
- Traceability comments (`// spec: ...`) are searched regardless of code language.

## Steps

**0. Validate**
- No file → ask for it.
- `Status: Draft` → warn user it's not yet implemented. Ask if proceeding anyway.
- `Status: Implemented` → continue.

Extract all verifiable elements: every AC (AC-XX) from every FR, verifiable NFRs, files in Affected Files section.
Announce to user: "Auditing X acceptance criteria and Y NFRs."

**1. Walk the code**
For each file in `## Affected Files` (or infer from Technical Design > Components Involved, or search for `// spec: specs/name.md`): read file, find traceability comment, identify which ACs the logic covers.

**2. Evaluate each AC**

| Status | Meaning |
|---|---|
| ✅ COVERED | Code clearly implements this criterion |
| ⚠️ PARTIAL | Implementation exists but incomplete or missing edge cases |
| ❌ ABSENT | No evidence of implementation found |
| 🔍 NOT VERIFIABLE IN CODE | Requires runtime test (e.g. performance, UX) |

For PARTIAL/ABSENT: record exact file+line where implementation was expected, what's specifically missing, concrete suggestion to fix.

**3. Generate coverage report** (in user's conversation language)

```
🔍 Verification Report — [Feature]
Spec: specs/name.md | Date: YYYY-MM-DD

Summary: Total ACs | ✅ Covered | ⚠️ Partial | ❌ Absent | 🔍 Not verifiable
Coverage: X% (covered / verifiable in code)

Detail per FR:
  FR-01: [Name]
  | AC | Status | Evidence / Gap |
  | AC-01 | ✅ | `file.ts:45` — handleX implements full flow |
  | AC-02 | ⚠️ | `Form.tsx:12` — validates field but misses empty string case |
  | AC-03 | ❌ | No notification logic found in affected files |

NFRs:
  | NFR | Status | Notes |

Priority Gaps (ordered by impact):
  GAP-01 — [AC-03 of FR-01]
  Impact: High | Where: `src/services/notification.ts` | What: [concrete description]

Traceability:
  Files with spec: comment: [list]
  Related files without comment: [list if any]

Conclusion:
  ✅ Fully covered — ready for QA
  OR ⚠️ Partially covered — X gaps, resolve before QA
  OR ❌ Critical gaps — return to /jr-exe-spec
```

**4. Update spec**

Add History entry: `| [v] | date | Verified | jr-verify-spec — Coverage: X% · Gaps: Y |`

If coverage = 100% of verifiable ACs: `Status: Implemented` → `Status: Verified`
If gaps exist: status stays `Implemented`.
