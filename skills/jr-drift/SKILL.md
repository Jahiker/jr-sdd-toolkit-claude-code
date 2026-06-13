---
name: jr-drift
description: Use when the user runs /jr-drift or wants to detect divergence between specs and their actual implementation — specs that are Verified but whose code changed, broken traceability, or plan-vs-reality gaps. Read-only analysis. Triggers: "check drift", "are specs in sync with code", "spec drift", "traceability check", /jr-drift.
---

# jr-drift

Detect divergence between specs and the code that implements them. **Read-only** — analyzes and reports, never modifies. Complements `/jr-sync` (which reconciles PROJECT.md ↔ codebase config) by reconciling specs ↔ implementation.

The problem it solves: a spec can be marked Verified, then its code gets changed by a patch, a fix, or by hand — and nobody updates the spec. The spec now lies about what the code does. jr-drift surfaces that silent divergence.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → Docs language, dirs.
- **NEVER modify any file.** This skill only reads and reports. If the user wants to act on findings, point them to the right skill (verify-spec, iterate-spec, sync).
- Keep it scoped — don't read full file contents, only what's needed to detect drift (existence, traceability comments, git metadata). This is metadata analysis, not code review.

## The three drift types

| Type | Definition | Severity |
|---|---|---|
| 🔴 Coverage drift | Traceability is broken: `Affected Files` lists files that no longer exist, OR code has `// spec: X` where X is not a spec in specs/ | High |
| 🟠 Spec drift | A Verified spec's code was modified after verification (by patch, fix, or hand) without the spec being re-verified | Medium |
| 🟡 Plan drift | In an `exe-spec --dev` run, declared files-to-touch differed from what was actually touched (historical, informational) | Low |

## Steps

**0. Gather sources**
- List all specs in specs/ (main + sketches/ + fixes/). For each, read only: Status, Verified date (from History), `## Affected Files` table, `## Post-verification changes` section if present.
- Grep the codebase for all `// spec:` and `// fix:` traceability comments (regardless of code language — the marker text is the same). Build a map: comment → referenced spec slug.
- Read `docs/progress.md` if present: collect patch/fix/exe-spec entries with dates and affected files.
- Detect git availability (`git rev-parse` check). If available, it's the verifier for spec drift; if not, rely on progress.md + traceability comments only and note that detection is best-effort.

**1. Detect Coverage drift (🔴)**
- For each spec's `## Affected Files`: check each listed file exists (Glob). Missing file → coverage drift entry.
- For each `// spec: X` comment found in code: check that spec `X` exists in specs/. Orphan comment (spec doesn't exist) → coverage drift entry.
- Reverse check (optional, note as info): files with no traceability comment that progress.md attributes to a spec.

**2. Detect Spec drift (🟠)**
For each spec with `Status: Verified`:
- Get its Verified date from History.
- Find modifications to its Affected Files AFTER that date, from two sources:
  - progress.md entries (jr-patch / jr-fix-spec) referencing those files, dated after Verified.
  - If git available: `git log --since=[verified-date] --name-only -- [affected files]` → real commits touching them.
- Any post-Verified modification → spec drift entry, listing what changed, when, and by which path (patch / fix / hand-edit via git).
- A spec's own `## Post-verification changes` section (written automatically by patch/fix per cross-reading) is the most reliable signal — surface it directly.

**3. Detect Plan drift (🟡)**
- From progress.md, find `exe-spec --dev` entries that recorded declared vs. actual files-to-touch with a mismatch. These are historical; report as informational only.

**4. Generate Drift Report** (in user's language)

```
🔍 Drift Report — [project]
Analyzed: specs/ + traceability comments [+ git log if available]
[⚠️ git not available — detection is best-effort from progress log + comments]

🔴 Coverage drift (broken traceability) — N
  - specs/[x].md → Affected Files lists [file] (no longer exists)
  - [file] has // spec: [slug] but that spec doesn't exist in specs/

🟠 Spec drift (Verified but code changed) — N
  - [spec].md (Verified [date]) → modified after:
      [file] ([source] [date]), ...
      → Re-verify with /jr-verify-spec, or iterate if behavior changed

🟡 Plan drift (historical, from exe-spec --dev) — N
  - [spec].md → declared X files, touched Y

✅ In sync — N specs aligned with their code

Prioritized suggestions:
  1. [🔴 URGENT] [specific action]
  2. [🟠] [specific action]
  3. [🟡] [informational]
```

If zero drift across all types → report "✅ No drift — all specs aligned with their code" and exit.

**5. Suggest, don't act**
End with prioritized, concrete next actions, each pointing to the right skill:
- Coverage drift (missing files / orphan comments) → manual cleanup or `/jr-sync`
- Spec drift → `/jr-verify-spec @spec` to re-verify, or `/jr-iterate-spec @spec` if behavior diverged
- Plan drift → informational, usually no action

Never run those skills automatically — jr-drift only reports.

## Special cases
- **No specs/ folder** → nothing to analyze; tell the user.
- **No git, no progress.md** → can only detect coverage drift (file existence + orphan comments); say so and report what's possible.
- **Spec never Verified** → not eligible for spec drift (can't drift from a state it never reached); only coverage drift applies.
- **Large codebase** → the `// spec:` grep is the only full-codebase scan; keep it to a single pass, don't read file bodies.
- **Monorepo** → group findings per package if structure detected.

## Principles
- Read-only is the whole point: drift detection you can run anytime without fear of side effects.
- Signal over noise: plan drift is informational, spec drift is actionable, coverage drift is urgent. Always rank, never dump a flat list.
- jr-drift reports; the dev decides. It never re-verifies, iterates, or edits on its own.
- Sibling to /jr-sync: sync reconciles config (PROJECT.md ↔ codebase), drift reconciles traceability (specs ↔ implementation).
