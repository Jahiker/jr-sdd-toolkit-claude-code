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

## Scope discipline (cost control)
verify-spec is read-heavy. Keep its context footprint minimal:
- **Source of truth for which files to read is the spec's `## Affected Files` table.** Read only those files. Do NOT scan the whole codebase.
- If `## Affected Files` is missing (spec implemented before this section existed, or by hand): tell the user the table is missing, offer to either (a) re-run `/jr-exe-spec` to generate it, or (b) have them list the files to verify. Only as a last resort, `grep` for `// spec: specs/[name].md` — and tell the user this is the expensive path.
- **Surgical reading**: for files larger than ~120 lines, do NOT read the whole file. First `grep` for the traceability comment (`// spec: ...`) and the AC-relevant symbols, then read only the relevant blocks plus ~15 lines of surrounding context. Read small files (≤120 lines) in full.
- Never re-read a file already in context. Never read test fixtures, lockfiles, build output, or vendored deps.

## Steps

**0. Validate**
- No file → ask for it.
- `Status: Draft` → warn user it's not yet implemented. Ask if proceeding anyway.
- `Status: Sketch` → refuse: spec was never implemented (it's below readiness threshold).
- `Status: Implemented` → continue.

Extract all verifiable elements: every AC (AC-XX) from every FR, verifiable NFRs, files in Affected Files section.
Announce to user: "Auditing X acceptance criteria and Y NFRs across N files."

**1. Walk the code (scoped)**
Read only the files in `## Affected Files`, applying the surgical reading rule above. For each: find the traceability comment, identify which ACs the logic covers. If the table is missing, follow the fallback path in Scope discipline — don't silently grep the whole project.

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

**4. Update spec + log progress**

Add History entry: `| [v] | date | Verified | jr-verify-spec — Coverage: X% · Gaps: Y |`

If coverage = 100% of verifiable ACs: `Status: Implemented` → `Status: Verified`
If gaps exist: status stays `Implemented`.

Append entry to `docs/progress.md` (create with header if missing). Use today's date:
```
## YYYY-MM-DD — jr-verify-spec — [spec slug]
Coverage: X% · Status: [Verified|Implemented]. [N gaps if any]
```
