---
name: jr-verify-spec
description: >
  Use this skill whenever the user runs /jr-verify-spec or wants to verify that a spec's implementation covers its acceptance criteria. Triggered by phrases like "verify the spec", "check acceptance criteria", "see what was implemented", "validate the spec", "audit implementation", or when /jr-verify-spec is mentioned. Receives an implemented spec .md file, walks the affected files, evaluates coverage of each acceptance criterion, detects gaps, generates a coverage report, and updates the spec history. Acts as QA of the spec-driven cycle: closes the loop between what was requested and what was delivered.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Read PROJECT.md at the start for context.
  Generate all reports and output in the user's conversation language.
  Traceability markers in code (// spec: ...) are language-agnostic — search for them regardless of language.
---

# jr-verify-spec

Post-implementation verification skill. Closes the spec-driven cycle loop: reads the implemented spec, walks the produced code, evaluates criterion by criterion, detects gaps, and generates a traceable coverage report.

Does not replace automated tests — it complements them. Its role is to give explicit visibility between what the spec promised and what the code actually delivers.

---

## Step 0 — Validate input

If the user ran `/jr-verify-spec` **without attaching a `.md` file**, respond in their language:
> [Ask them to share the spec: `/jr-verify-spec @specs/feature-name.md`]

Also read `PROJECT.md` for context.

---

## Step 1 — Read the spec and prepare the audit

1. Read the complete spec `.md`.
2. Verify the status:
   - If `Status: Draft` → warn in user's language: "This spec hasn't been implemented yet (Status: Draft). Do you want to verify anyway whatever exists in the code?"
   - If `Status: Implemented` → continue normally.
3. Extract and list internally all verifiable elements:
   - Each **Acceptance Criterion** (AC-XX) from each Functional Requirement
   - Each **Non-Functional Requirement** that's verifiable in code
   - Each item in the **Affected Files** section (if it exists)
4. Confirm to the user in their conversation language:
   > [Tell them: auditing X acceptance criteria and Y non-functional requirements from the spec]

---

## Step 2 — Walk the code

For each file listed in `## Affected Files` of the spec (or mentioned in Technical Design if the section doesn't exist):

1. Open and read the file.
2. Look for the traceability comment: `// spec: specs/name.md` (or equivalent in the language).
3. Identify what logic implements and which ACs it could cover.

If there's no `## Affected Files` section, infer files from Technical Design (Components Involved section) and by searching the project for files containing `// spec: specs/name.md`.

---

## Step 3 — Evaluate coverage per criterion

For each AC, determine one of these statuses:

| Status | Description |
|---|---|
| ✅ **COVERED** | There is code that clearly implements this criterion |
| ⚠️ **PARTIAL** | There is implementation but incomplete or with unhandled conditions |
| ❌ **ABSENT** | No evidence of implementation found in the code |
| 🔍 **NOT VERIFIABLE IN CODE** | The criterion requires runtime testing (e.g.: "responds in < 200ms") |

For items marked PARTIAL or ABSENT, record:
- Which file was expected to have the implementation
- What specific part is missing
- Concrete suggestion of what to add or fix

---

## Step 4 — Generate the coverage report

Present the report in the user's conversation language:

```
[Verification Report — Feature Name]

[Spec file]
[Verification date]

[Summary table: Total ACs | ✅ Covered | ⚠️ Partial | ❌ Absent | 🔍 Not verifiable in code]
[Coverage percentage: covered / verifiable in code]

[Detail per Functional Requirement]
  [FR-01: Name]
  | AC | Status | Evidence / Gap |
  | AC-01 | ✅ COVERED | `src/services/feature.ts:45` — function `handleX` implements the full flow |
  | AC-02 | ⚠️ PARTIAL | `src/components/Form.tsx:12` — validates field but doesn't handle empty value case |
  | AC-03 | ❌ ABSENT | No notification logic found in any affected file |

[Non-Functional Requirements]
  | NFR | Status | Notes |

[Priority Gaps — ordered by impact]
  [GAP-01 — AC-03 of FR-01: Missing notification logic]
  - Impact: High — criterion is part of the main flow
  - Where to add: `src/services/notification.ts`
  - What to implement: [concrete description of what's missing]

[Traceability]
  - Files with `spec:` comment found: [list]
  - Related files without `spec:` comment: [list if applicable]

[Conclusion — one of:]
  ✅ Spec fully covered — ready for QA/testing
  ⚠️ Spec partially covered — X gaps found, recommend resolving priority gaps before QA
  ❌ Spec with critical gaps — main flow criteria not implemented, recommend returning to /jr-exe-spec
```

---

## Step 5 — Update the spec

Open `specs/feature-name.md` and add entry in `## History`:

```markdown
| [version] | YYYY-MM-DD | Verified | jr-verify-spec — Coverage: X% · Gaps: Y |
```

If coverage is 100% (all verifiable ACs are covered), change:
`**Status:** Implemented` → `**Status:** Verified`

If there are gaps, status remains `Implemented` until they're fixed and re-verified.

---

## Behavior for special cases

**Spec without `Affected Files` section:**
Infer files from Technical Design > Components Involved. If it doesn't exist either, search the project for files containing `// spec: specs/name.md`. Inform the user which files were reviewed.

**File listed in spec that doesn't exist in the project:**
Mark as `❌ ABSENT` and record as a critical gap.

**Spec with many ACs (more than 20):**
Group by FR and present the report in sections. Don't omit any AC.

**User only wants to verify a specific FR:**
Accept it, run the same flow scoped to the requested FR. Note in the report that verification was partial.

---

## Principles

- **Don't assume, verify**: a criterion is covered only if there's code that implements it, not if it "seems like it should be there".
- **Be specific about gaps**: "validation is missing" is not useful. "Missing validation of `email !== ''` in `Form.tsx:23` before calling `submitForm()`" is.
- **Don't block the flow**: the report is informative. The user decides whether to fix before continuing or document the technical debt.
- **Close the loop**: the value of this skill is making explicit what the spec promised vs what the code delivers. That gap, visible and documented, is more valuable than ignoring it.
