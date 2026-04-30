---
name: jr-fix-spec
description: Use when the user runs /jr-fix-spec or reports a bug to diagnose and fix. Triggers: "there's a bug", "this is failing", "fix this error", "wrong behavior", /jr-fix-spec. Works with or without a related spec (legacy code supported).
---

# jr-fix-spec

Diagnose, document, and fix bugs surgically. Minimum change for maximum impact.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start.
- Requires a .md bug report file in specs/fixes/. If missing, ask user to create it (brief: what's broken, where) then run the command.
- Create specs/fixes/ if it doesn't exist.
- Write fix reports in Docs language from Toolkit Context.

## Bug report format (user creates this)
```markdown
# Bug: [short name]
[What's happening vs what should happen]
[File/component where it occurs]
[Reproduction conditions if known]
```

## Steps

**0. Read bug report**
Extract: actual behavior, expected behavior, location, reproduction conditions.

**1. Find related spec**
Search specs/ for a spec covering the affected area.
- Found → read it, identify which AC it violates. Record: `Violates AC-XX of FR-XX`
- Not found → note "Bug in code without associated spec". Infer expected behavior from code logic, function names, comments.

Announce which case applies in user's language.

**2. Diagnose** (report in user's language, wait for confirmation before proceeding)
```
Bug confirmed: Yes/No
Root cause: [precise technical description — cause, not symptom]
Exact location: `file.ts:line`
Violated AC: [AC-XX of FR-XX] or "Not applicable"
Fix impact: [files that could be affected]
```

**3. Fix plan** (present in user's language, wait for approval)
```
🔧 Fix Plan — [Bug Name]
Files to modify: X | Files to verify (regression): Y
Strategy: [one-line]

Changes:
  - [ ] 1. [action] → `path/file.ext:line`
  - [ ] 2. [action if needed]

Regression checks:
  - [ ] R1. Verify [adjacent flow] still works in [file]
  - [ ] R2. Verify [other flow] not affected
```

If fix touches 5+ files → pause: "This looks more like an iteration than a hotfix. Proceed or use `/jr-iterate-spec`?"

**4. Execute fix**
Per item:
1. Announce in user's language
2. Apply minimum change
3. Add traceability in corrected block: `// fix: specs/fixes/bug-name.md — [one-line]`
4. Confirm in user's language

On unexpected conflict → pause, offer options, wait for decision.

**5. Regression check**
For each R item: read adjacent file, evaluate impact.
Report: ✅ no impact detected | ⚠️ verify manually: [what + where]

**6. Update documentation**

**If related spec exists:**
- Add edge case as new AC in affected FR: `- [ ] AC-XX: [description] *(added in hotfix YYYY-MM-DD)*`
- Add History entry: `| [v] | date | Hotfix | jr-fix-spec — [one-line] |`
- Do NOT change spec Status or version.

**If no related spec:**
Update specs/fixes/bug-name.md (in Docs language):
```
# Fix: [Bug Name]
Status: Resolved | Date | Affected files: [list]

## Original description / Root cause / Applied solution
## Modified files (table: file | change)
## Regression verification result
```

**7. Final report** (in user's language)
Root cause resolved | Files modified | AC fixed | Changes table | Regression table | How to confirm fix | Documentation updated.

## Special cases
- Can't reproduce from code → ask for more context (runtime state, specific data, race condition?)
- Multiple bugs in report → separate them, ask: one fix or separate reports?
- Fix exposes design problem → document as tech debt, don't fix in same PR.
