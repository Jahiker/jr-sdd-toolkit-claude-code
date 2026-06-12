---
name: jr-fix-spec
description: Use when the user runs /jr-fix-spec or reports a bug to diagnose and fix. Accepts --dev / --no-dev flag for bug report quality gating. Triggers: "there's a bug", "this is failing", "fix this error", "wrong behavior", /jr-fix-spec. Works with or without a related spec (legacy code supported).
---

# jr-fix-spec

Diagnose, document, and fix bugs surgically. Minimum change for maximum impact. In `--dev` mode, the bug report is scored for quality first — underspecified reports are the #1 cause of fixes that break something else.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → including **Mode**.
- Mode resolution: `--dev`/`--no-dev` flag > PROJECT.md `Mode:` > `default`.
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

**0. Read bug report + parse mode**
Resolve mode, announce it. Extract: actual behavior, expected behavior, location, reproduction conditions.

**0.5. Bug report quality gate (DEV MODE ONLY — skip if mode=default)**

Score the report on 5 dimensions (0–100 each). Be strict — vague reports cause fixes that break other things.

| Dimension | Weight | HIGH | LOW |
|---|---|---|---|
| 🔬 Reproducibility | 25% | Clear steps or conditions to trigger it | "Sometimes it fails" with no trigger |
| 📍 Localization | 20% | Points to file/component/page (even a hunch) | No idea where it happens |
| 🎯 Expected vs actual | 25% | Both behaviors explicit | Only "it doesn't work" |
| 📊 Frequency / severity | 10% | Always/sometimes + impact stated | Absent |
| 🔗 Recent-changes context | 20% | Mentions recent merges/deploys near the area, or states none known | Absent |

Weighted score → thresholds:
- **≥70 — proceed** to step 1, show the mini-scorecard.
- **<70 — pause** and ask targeted questions ONLY for the dimensions that scored low (e.g. "¿Pasa siempre o a veces? Si a veces, ¿qué condición lo dispara?" / "¿Hubo merges recientes que tocaran esta zona?"). The user can answer or explicitly say "no sé / no tengo más" — honest unknowns are recorded as such and the gate releases. The goal is extracting what the dev knows, not blocking work.

Append the answers to the bug report file so the record is complete. In default mode this entire step is skipped.

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

In `dev` mode, regression items marked ⚠️ require the dev's explicit "regression checked" confirmation before step 6 — code-reading by the skill alone doesn't close them.

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

**7. Final report + log progress** (in user's language)
Root cause resolved | Files modified | AC fixed | Changes table | Regression table | How to confirm fix | Documentation updated.

Append entry to `docs/progress.md` (create with header if missing). Use today's date:
```
## YYYY-MM-DD — jr-fix-spec[--dev] — [bug slug or related spec]
Fixed [one-line root cause]. Files: [N modified]. [Report quality: S/100 if dev]. [Hotfix in spec X.Y if applicable]
```

## Special cases
- Can't reproduce from code → ask for more context (runtime state, specific data, race condition?)
- Multiple bugs in report → separate them, ask: one fix or separate reports?
- Fix exposes design problem → document as tech debt, don't fix in same PR.
