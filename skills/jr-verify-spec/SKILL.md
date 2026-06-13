---
name: jr-verify-spec
description: Use when the user runs /jr-verify-spec or wants to verify that a spec's implementation covers its acceptance criteria. Accepts --dev / --no-dev flag for hardened E2E verification with manual signoff. Triggers: "verify spec", "check acceptance criteria", "validate spec", "audit implementation", /jr-verify-spec.
---

# jr-verify-spec

Verify implemented spec coverage: walk the code, evaluate each AC, generate a coverage report, close the spec-driven loop. In `--dev` mode, code-reading is not enough — every AC needs an executable verification command, the dev must run them and sign off per AC, and negative cases are required.

Does not replace automated tests — complements them.

## Rules
- Respond to user in their conversation language. Generate all output in conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → including **Mode**.
- Mode resolution: `--dev`/`--no-dev` flag > PROJECT.md `Mode:` > `default`.
- If no spec file provided, ask in user's language.
- Traceability comments (`// spec: ...`) are searched regardless of code language.

## Scope discipline (cost control)
verify-spec is read-heavy. Keep its context footprint minimal:
- **Source of truth for which files to read is the spec's `## Affected Files` table.** Read only those files. Do NOT scan the whole codebase.
- If `## Affected Files` is missing: tell the user, offer (a) re-run `/jr-exe-spec` to generate it, or (b) have them list the files. Only as a last resort, `grep` for `// spec: specs/[name].md` — and tell the user this is the expensive path.
- **Surgical reading**: for files larger than ~120 lines, `grep` for the traceability comment and AC-relevant symbols first, then read only relevant blocks + ~15 lines context. Read small files (≤120 lines) in full.
- Never re-read a file already in context. Never read test fixtures, lockfiles, build output, or vendored deps.

## Mode-aware flow

| Mode | What "Verified" means |
|---|---|
| `default` | Code-level coverage audit (steps 0–4). Status flips to Verified at 100% coverage of verifiable ACs. |
| `dev` | Coverage audit PLUS: executable verification command per AC, dev runs them and signs off per AC, negative cases required, diff review. Status only flips to Verified when the Verification Quality score passes. **It is unacceptable to mark a spec Verified in dev mode without the checks having been executed.** |

## Steps

**0. Validate + parse mode**
- Resolve mode, announce it.
- No file → ask for it.
- `Status: Draft` → warn user it's not yet implemented. Ask if proceeding anyway.
- `Status: Sketch` → refuse: spec was never implemented.
- `Status: Implemented` → continue.

Extract all verifiable elements: every AC (AC-XX) from every FR, verifiable NFRs, files in Affected Files.
Announce: "Auditing X acceptance criteria and Y NFRs across N files. [Mode: dev — manual signoff will be required.]"

**1. Walk the code (scoped)**
Read only the files in `## Affected Files`, applying surgical reading. For each: find the traceability comment, identify which ACs the logic covers.

**1.5. Scope check (cross-reading, v1.12.0)**
Grep the codebase for `// spec: [this-spec-slug]` comments. Compare that set of files against the spec's `## Affected Files` list:
- Files with the comment but NOT in Affected Files → potential scope creep or incomplete table. Report:
```
📐 Scope check:
  ⚠️ N file(s) carry // spec: [slug] but aren't in Affected Files:
    - [file]
  → Spec table incomplete, or scope crept during implementation. Update Affected Files or review.
```
- Files in Affected Files but missing the comment → note as info (may be config/asset files that don't take comments).
This is a lightweight metadata pass (grep only, no body reads beyond what step 1 already did). In `default` mode it's a one-line note; in `dev` mode discrepancies are surfaced prominently as part of the quality picture.

**2. Evaluate each AC (code-level)**

| Status | Meaning |
|---|---|
| ✅ COVERED | Code clearly implements this criterion |
| ⚠️ PARTIAL | Implementation exists but incomplete or missing edge cases |
| ❌ ABSENT | No evidence of implementation found |
| 🔍 NOT VERIFIABLE IN CODE | Requires runtime test (e.g. performance, UX) |

For PARTIAL/ABSENT: record exact file+line where implementation was expected, what's missing, concrete fix suggestion.

**3. Generate coverage report** (in user's conversation language)

```
🔍 Verification Report — [Feature]
Spec: specs/name.md | Date: YYYY-MM-DD | Mode: [default|dev]

Summary: Total ACs | ✅ Covered | ⚠️ Partial | ❌ Absent | 🔍 Not verifiable
Coverage: X% (covered / verifiable in code)

Detail per FR:
  FR-01: [Name]
  | AC | Status | Evidence / Gap |

NFRs: | NFR | Status | Notes |

Priority Gaps (ordered by impact):
  GAP-01 — [AC of FR] | Impact | Where | What

Traceability: files with spec: comment / related files without

Conclusion:
  ✅ Fully covered — ready for QA
  OR ⚠️ Partially covered — X gaps, resolve before QA
  OR ❌ Critical gaps — return to /jr-exe-spec
```

In `default` mode → continue to step 6 (update spec). In `dev` mode → continue to step 4.

**4. E2E verification plan (DEV MODE ONLY)**

For every AC that is ✅ COVERED or 🔍 NOT VERIFIABLE IN CODE, generate a **concrete executable verification**:
- API behavior → exact `curl` command with expected status/body
- CLI/script behavior → exact command + expected output
- UI behavior → numbered manual browser steps (or Playwright steps if the project uses it)
- Performance NFRs → measurement command (e.g. `time`, lighthouse, k6) + threshold

Plus, for each FR, at least **one negative case**: an input or action that should fail/be rejected, with the expected error behavior. If a negative case can't be conceived for an FR, state why explicitly (rare).

Present the plan grouped per AC:

```
🧪 E2E Verification Plan (mode: --dev)

AC-01 — [text]
  ▶ curl -s -X POST localhost:3000/login -d '{...}' 
    Expect: 200 + JWT in body
AC-02 — [text]
  ▶ [steps]
NEG-FR01 — login with wrong password
  ▶ curl ... -d '{"password":"wrong"}'
    Expect: 401, no token, no session created

Ejecuta las verificaciones y reporta por AC:
  "AC-01 pass" / "AC-01 fail: [qué pasó]" — o "all pass" si todas pasaron.
```

**5. Manual signoff per AC (DEV MODE ONLY)**

Wait for the dev's results. Rules:
- Each AC needs explicit pass/fail. "all pass" is accepted as signoff for everything listed.
- "Reviewed by reading the code" is NOT acceptable as a pass in dev mode — say so and ask them to actually run it.
- Failures → record them, the AC drops to ⚠️/❌, the corresponding gap is added. Offer `/jr-fix-spec` or fixing inline if trivial (jr-patch criteria).
- Honest path: if the dev cannot run something (no env access, missing data), they can mark `AC-XX skipped: [reason]` — recorded as not-verified, blocks Verified status, but doesn't block the report.

Compute **Verification Quality**:

```
📊 Verification Quality — [Feature]

🧪 ACs with executed evidence     9/10   90%
🚫 Negative cases passed           4/5    80%
👁  Diff reviewed by dev           [Yes/No]
⏭  Skipped                         1 (AC-07: no staging access)

Verification readiness: [score]/100
```

Score = 0.5·(ACs executed-and-passed %) + 0.3·(negative cases passed %) + 0.2·(diff reviewed: 100 or 0).
Diff review: before computing, show the list of files changed for this spec and ask the dev to confirm they reviewed the diff ("diff reviewed").

Threshold: score ≥ 85 AND no failed ACs → eligible for Verified. Below → stays Implemented, with the gaps and skips listed as the to-do.

**6. Update spec + log progress**

History entry:
- default: `| [v] | date | Verified | jr-verify-spec — Coverage: X% · Gaps: Y |`
- dev: `| [v] | date | Verified | jr-verify-spec --dev — Coverage: X% · E2E: N/M pass · Quality: S/100 |`

Status transition:
- default mode: coverage = 100% of verifiable ACs → `Status: Verified`; gaps → stays `Implemented`.
- dev mode: quality ≥85 AND no failed ACs → `Status: Verified` + add `Verified-by: dev signoff YYYY-MM-DD` line to header; otherwise stays `Implemented`.

In dev mode, append the E2E plan + results as a `## Verification Evidence v[X]` section before History (so re-verification after changes can rerun the same commands).

Append entry to `docs/progress.md` (create with header if missing). Use today's date:
```
## YYYY-MM-DD — jr-verify-spec[--dev] — [spec slug]
Coverage: X% · Status: [Verified|Implemented]. [E2E N/M pass · Quality S/100 if dev]. [Gaps/skips if any]
```

## Special cases
- **Spec implemented in default mode, verified in dev mode**: fine — announce that no prior evidence section exists and generate the E2E plan from scratch.
- **Re-verification** (spec already has Verification Evidence): reuse the existing commands, ask the dev to rerun only the ACs affected by changes since (use Delta section if iterated).
- **User insists on Verified without running checks (dev mode)**: hold the line once, then allow only explicit override — `override verification` — recorded prominently in History and progress as `⚠️ override: marked Verified without executed evidence`. (Respect autonomy, keep the trail.)
- **Project has automated tests covering some ACs**: running the test suite counts as executed evidence for those ACs — record which test maps to which AC.
