---
name: jr-fix-spec
description: >
  Use this skill whenever the user runs /jr-fix-spec or reports a bug that needs to be diagnosed, documented, and fixed. Triggered by phrases like "there's a bug in", "this is failing", "fix this error", "fix behavior", "the feature isn't working as expected", or when /jr-fix-spec is mentioned. Receives a .md file with a brief bug description (located in specs/fixes/), diagnoses the root cause, builds a surgical fix plan, executes only the necessary changes with traceability, verifies regression on adjacent files, and updates the original spec if one exists. Works both when a related feature spec exists and when the bug is in legacy code without a spec.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Read PROJECT.md at the start for context.
  Generate all output (diagnosis, plan, report) in the user's conversation language.
  Fix report files are written in the Docs language from PROJECT.md.
  Code traceability comments follow the code language convention (// fix: ... or # fix: ... etc).
---

# jr-fix-spec

Skill to diagnose, document, and fix bugs in a structured and surgical way. Receives a brief bug description, builds a complete diagnosis, executes the minimum necessary fix, and leaves full traceability of the problem and its solution.

The core principle: **touch as little as possible to fix as much as possible.**

---

## Step 0 — Validate input

The user must provide a `.md` file with the bug description:

```
/jr-fix-spec @specs/fixes/bug-name.md
```

If the file doesn't exist or wasn't attached, respond in the user's language:
> [Ask them to create a brief .md file in `specs/fixes/bug-name.md` describing what's failing and where, then run the command]

If `specs/fixes/` doesn't exist, create it without asking.

Also read `PROJECT.md` for context and Docs language.

---

## Step 1 — Read the bug report

Read the `.md` file and extract:
- **Actual behavior:** what is happening
- **Expected behavior:** what should happen
- **Where it occurs:** mentioned file(s), component(s), route(s)
- **Reproduction conditions:** if mentioned

---

## Step 2 — Find related spec

Search `specs/` for a spec that covers the affected area:

**If a related spec exists:**
- Read it completely
- Identify which AC (acceptance criterion) this bug violates
- Record: `Violates AC-XX of FR-XX: [description]`

**If NO related spec exists (legacy or pre-existing code):**
- Document it: `Bug in code without associated spec`
- Scan the files mentioned in the report to understand expected behavior from the code itself
- Infer correct behavior from existing logic, function names, comments, or project context

Announce which case applies to the user in their conversation language before continuing.

---

## Step 3 — Diagnosis

Analyze the code in the reported files (and related ones) to:

1. **Confirm** the bug exists where reported
2. **Identify the root cause** — the real cause, not just the symptom
3. **Map the impact** — what other files or flows could be affected by the fix

Present the diagnosis to the user in their conversation language:

```
[Bug confirmed: Yes / No]
[Root cause: precise technical description of why it fails]
[Exact location: `file.ts:line` — what's there]
[Violated AC: AC-XX of FR-XX — description / Not applicable (no spec)]
[Potential fix impact: files that could be affected when correcting]

[Ask for confirmation before proceeding to fix plan]
```

Wait for confirmation before continuing.

---

## Step 4 — Fix Plan

Generate a surgical plan — **only the strictly necessary changes**:

```
[Fix Plan — Bug Name]

[Files to modify: X]
[Files to verify (regression): Y]
[Strategy: one-line description of how to fix it]

[Changes]
  - [ ] 1. [Concrete action] → `path/file.ext:line` [WHAT TO CHANGE]
  - [ ] 2. [Concrete action if applicable]

[Regression verification]
  - [ ] R1. Verify `[adjacent flow]` still works in `file.ext`
  - [ ] R2. Verify `[other flow]` is not affected

[Ask for approval before executing]
```

**Fix plan rules:**
- Maximum impact with minimum number of files changed.
- If the fix requires touching more than 5 files, pause and ask: is this really a fix or a feature iteration?
- Do not refactor adjacent code even if it "looks ugly" — that goes in a separate iteration.
- Do not add new functionality — only fix the broken behavior.

---

## Step 5 — Wait for approval

Do not execute anything until receiving explicit confirmation from the user. If they request adjustments, modify and re-present.

---

## Step 6 — Execute the fix

For each item in the plan:

1. **Announce** in user's language: `▶ 1. Fixing \`src/components/Form.tsx:47\`...`
2. **Execute** the minimum necessary change.
3. **Add traceability** in the corrected block:
   ```
   // fix: specs/fixes/bug-name.md — [one-line description]
   ```
4. **Confirm** in user's language: `✓ 1. Done`

**If something unexpected is found during execution**, pause in user's language before continuing.

---

## Step 7 — Regression verification

For each verification item in the plan:

1. Read the adjacent files mentioned.
2. Evaluate if the fix could have affected them.
3. Report in user's language:
   - ✅ `[flow]` — no impact detected
   - ⚠️ `[flow]` — verify manually: [what to check and where]

---

## Step 8 — Update documentation

### If a related spec exists:

Open `specs/[spec-name].md` and apply:

1. In the affected FR, add the edge case as a new AC:
   ```markdown
   - [ ] AC-XX: [description of the edge case the bug exposed] *(added in hotfix YYYY-MM-DD)*
   ```

2. Add entry in `## History`:
   ```markdown
   | [version] | YYYY-MM-DD | Hotfix | jr-fix-spec — [one-line bug description] |
   ```

3. **Do not change the spec Status or version** — a hotfix is not an iteration.

### If NO related spec exists:

Update the bug report file `specs/fixes/bug-name.md` with the diagnosis and applied solution. Write in **Docs language** from PROJECT.md:

```markdown
# Fix: [Bug Name]

**Status:** Resolved
**Date:** YYYY-MM-DD
**Affected files:** [list]

## Original description
[what the user reported]

## Root cause
[diagnosis found]

## Applied solution
[description of what was changed and why]

## Modified files
| File | Change |
|---|---|
| `path/file.ext` | [change description] |

## Regression verification
[verification result]
```

---

## Step 9 — Final report

Present in the user's conversation language:

```
[Fix Completed — Bug Name]

[Root cause resolved: one-line description]
[Files modified: X]
[Violated AC fixed: AC-XX of FR-XX / Not applicable]

[Changes applied table: file, line(s), change]
[Regression table: flow, status]
[How to confirm the fix: concrete steps]
[Documentation updated: spec with new AC / fix report saved]
```

---

## Special cases

**Bug cannot be reproduced from code:**
Report in user's language: possibly a runtime state issue, specific data, or race condition. Ask for more context.

**Fix requires a larger change (more than 5 files):**
Report in user's language: the root cause is deeper and requires an `/jr-iterate-spec` rather than a hotfix. Let the user decide.

**Multiple bugs in the report:**
Separate them explicitly and ask in user's language: resolve in a single fix or separate reports for each?

**Fix exposes a larger design problem:**
Document without resolving it. Note it in the fix report as technical debt to address.

---

## Principles

- **Minimum change, maximum impact**: a fix that touches 1 line is better than one that touches 10 if it solves the problem.
- **Don't mix fix with improvements**: if you see something to improve during the fix, document it as technical debt — don't fix it in the same PR.
- **Traceability always**: every corrected line must know why it was corrected.
- **Regression is not optional**: a fix that breaks something else is not a fix.
- **Honest about root cause**: if it can't be determined with certainty, document the hypothesis as a hypothesis.
