---
name: jr-build-spec
description: Use when the user runs /jr-build-spec or provides a rough requirement / user story to be refined into a professional spec. Input can be a .md file, direct chat description, or both. Accepts --dev / --no-dev flag for strict readiness evaluation. Triggers: "build spec", "refine requirement", "create spec", "analyze user story", /jr-build-spec.
---

# jr-build-spec

Transform rough requirements into professional technical specs. In `--dev` mode, evaluates spec readiness with a 6-dimension rubric and blocks weak specs from progressing.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → use Stack, Architecture, Conventions, Docs language, **Mode**.
- Mode resolution (in order): explicit `--dev`/`--no-dev` flag in invocation > `**Mode:**` value in PROJECT.md > `default` if neither set.
- Accept input from any of: `.md` file, direct chat text, or both combined. Only ask if zero input.
- Write spec files in Docs language.

## Mode-aware flow

| Mode | What changes |
|---|---|
| `default` | Standard flow: build spec → save as Draft → confirm. |
| `dev` | After building, apply 6-dimension rubric. Score determines outcome: <60 saved as Sketch (blocks exe-spec), 60–74 saved as Draft + warn flag, 75–89 Ready, 90+ Excellent. |

## Steps

**0. Read input + context + parse mode**
- Determine input source (file / chat / both / neither — ask if neither).
- Read PROJECT.md `## Toolkit Context`. Extract Mode.
- Parse flag override from invocation.
- Announce mode to user (`"Building spec in DEV mode — readiness rubric will apply"` or `"Building spec in default mode"`).
- Scan `specs/` for existing specs (titles + FR sections only). Also scan `specs/sketches/` if it exists — sketches are also considered for overlap detection.

**1. Detect overlaps**
Check if existing specs (or sketches) cover similar functionality, are extended/modified by this requirement, could be broken by it, or must run before it. If found, report and ask: new spec or integrate? Wait for decision.

**2. Evaluate scope**
Warn if requirement touches 3+ modules, combines DB+API+UI+integrations, has implicit phases, or exceeds ~5 dev-days. Ask whether to split or continue.

**3. Ask categorized questions** (in user's language)
Only what's needed for verifiable acceptance criteria:
- 🙋 Client/PO: business, scope, expected behavior, users, constraints
- 🛠️ Dev/Architect: integrations, dependencies, design decisions

Accept partial answers. Unresolved → `[PENDING]`.

**4. Build spec content** (in memory, not yet on disk)

Write in Docs language. Structure:

```
# [Feature Name]
Status: [Draft|Sketch — assigned in step 5]
Version: 1.0
Date: YYYY-MM-DD
Author: jr-build-spec
Related specs: [from overlap check or "None"]
Scope warning: [if applicable — remove line otherwise]
Input source: [file: req.md | chat | file + chat]
Build mode: [default | dev]

[Readiness Report block — only in dev mode, see step 4.5]

1. Executive Summary (2-3 sentences: what, why, expected outcome)
2. Context and Motivation (problem, affected users, business impact)
3. Goals (checklist)
4. Out of Scope (explicit exclusions)
5. Functional Requirements
   ### FR-01: [Name]
   Description + Acceptance Criteria checklist (AC-01, AC-02...)
   [repeat per FR]
6. Non-Functional Requirements (performance, security, scalability, compatibility)
7. Technical Design
   Architecture (how it fits the current system)
   Involved Components (table: component | role | required changes)
   Data Flow (main flow or pseudocode)
   Database Considerations ("No DB changes" if none)
   APIs / Integrations ("No API changes" if none)
8. Edge Cases and Error Handling (case → expected behavior)
9. Dependencies (specs to run first | internal | external | blockers)
10. Pending Questions (remove if none)
11. Additional Notes
History table (1.0 | date | Created | jr-build-spec [— mode if dev])
```

Each FR needs at least one testable AC. Undefined → `[TBD]` or `[PENDING]`.

**4.5. Readiness rubric (DEV MODE ONLY — skip if mode=default)**

Evaluate the spec content against 6 dimensions. Score each 0–100 based on the criteria below. The dimension definitions are deliberately strict — this is a code-review pass, not a participation trophy.

#### Dimension definitions

| Dimension | Weight | What scores HIGH | What scores LOW |
|---|---|---|---|
| **🎯 Clarity of intent** | 15% | Executive summary explains what+why+who in 2-3 sentences. Goals are concrete and measurable. | Vague phrasing ("improve UX", "modernize"). Goals can't be measured. |
| **🧪 Testability of ACs** | 25% | Every AC is a single observable behavior with explicit success condition (status code, exact text, count, time, etc.). | ACs say "works correctly", "responds well", "is fast". |
| **🚧 Boundary definition** | 10% | "Out of Scope" lists ≥3 explicit exclusions. Clearly differentiated from in-scope. | Out of Scope absent, generic ("nothing else"), or contradicts in-scope. |
| **🔗 Dependency awareness** | 15% | Lists internal deps (other specs, modules), external deps (libs, APIs), and ordering constraints. | Section absent, says "none" without analysis, ignores known interactions with current codebase. |
| **⚠️ Risk identification** | 15% | Edge cases section lists ≥3 concrete failure scenarios. Non-functional requirements address realistic threats. | Edge cases empty, generic ("error handling"), or handwaves with "TBD". |
| **🏗️ Architectural fit** | 20% | Technical Design respects existing Stack/Architecture/Conventions from PROJECT.md. Justifies any deviation. | Proposes patterns/libs that conflict with PROJECT.md without justification. Ignores existing modules. |

#### Scoring

For each dimension: assign integer 0–100. Be strict — most well-written specs score 70–85. Scores >90 are rare.

Compute weighted score:
```
overall = 0.15 * clarity + 0.25 * testability + 0.10 * boundaries + 0.15 * deps + 0.15 * risks + 0.20 * fit
```

#### Thresholds + outcomes

| Range | Label | Outcome |
|---|---|---|
| <60 | ❌ **Not ready** | Save as `specs/sketches/[slug].md` with `Status: Sketch`. Block subsequent `jr-exe-spec --dev` until iterated. |
| 60–74 | ⚠️ **Needs work** | Save as `specs/[slug].md` with `Status: Draft` + `Readiness: Needs work` flag. `jr-exe-spec --dev` will refuse to execute until score reaches ≥75. |
| 75–89 | ✅ **Ready** | Save as `specs/[slug].md` with `Status: Draft`. Proceed normally. |
| ≥90 | 🌟 **Excellent** | Save as `specs/[slug].md` with `Status: Draft` + `Readiness: Excellent` badge. |

#### Readiness Report block

Insert this block at the top of the spec (right after the header, before section 1):

```
## Readiness Report (jr-build-spec --dev)

🎯 Clarity of intent          [bar]  [score]   [✓|⚠|❌]
🧪 Testability of ACs         [bar]  [score]   [✓|⚠|❌]
🚧 Boundary definition        [bar]  [score]   [✓|⚠|❌]
🔗 Dependency awareness       [bar]  [score]   [✓|⚠|❌]
⚠️  Risk identification        [bar]  [score]   [✓|⚠|❌]
🏗️  Architectural fit          [bar]  [score]   [✓|⚠|❌]

**Overall readiness: [overall_score] / 100  [label]**

Top 3 blockers to address:
1. [concrete blocker tied to lowest dimension — name the section/AC, suggest fix]
2. [concrete blocker]
3. [concrete blocker]
```

Bar format: 10 chars wide, filled to score/10. E.g. score 73 → `███████░░░`. Per-dimension marker: ✓ if ≥75, ⚠ if 60–74, ❌ if <60.

Top 3 blockers must be **concrete and actionable** — not "improve testability" but "AC-02 ('login works') has no observable criterion. Reformulate as 'POST /login with valid credentials returns 200 + JWT in body'."

**5. Save spec**

> ⚠️ Mandatory. Create target dir if needed. Write without asking. Skill does not finish until file exists on disk.

Path depends on mode + score:

| Mode | Score | Path | Status |
|---|---|---|---|
| default | (rubric not applied) | `specs/[slug].md` | `Draft` |
| dev | <60 | `specs/sketches/[slug].md` | `Sketch` |
| dev | 60–74 | `specs/[slug].md` | `Draft` + `Readiness: Needs work` |
| dev | 75–89 | `specs/[slug].md` | `Draft` + `Readiness: Ready` |
| dev | ≥90 | `specs/[slug].md` | `Draft` + `Readiness: Excellent` |

In `--dev` mode, also update PROJECT.md `Toolkit Context` block to ensure `Sketches dir: specs/sketches/` is listed (add if missing).

**6. Confirm + log progress**
Respond in user's language. 

For `default` mode: show path, next step `/jr-exe-spec @specs/[name].md`.

For `dev` mode: show readiness report inline, path of saved file, and **mode-appropriate next step**:
- Sketch (<60) → "Iterate the spec to address blockers, then re-run `/jr-build-spec @specs/sketches/[slug].md --dev` to re-evaluate."
- Needs work (60–74) → "Address the blockers and re-run `/jr-build-spec` to bump score, OR proceed knowing `/jr-exe-spec --dev` will refuse to run."
- Ready (≥75) → "Proceed with `/jr-exe-spec @specs/[name].md`."

Append entry to `docs/progress.md` (create with header if missing). Use today's date:
```
## YYYY-MM-DD — jr-build-spec — [spec slug]
Spec [created|sketched] (Draft v1.0, mode: [default|dev]). Source: [file|chat|file+chat]. [Score: N/100 if dev mode]. [Pending if any]
```

## Special cases
- **User explicitly disagrees with the score**: respect autonomy. Allow override with explicit confirmation: "Override score and save as Draft anyway? This bypasses --dev gates." If user confirms, save with `Readiness: Override` flag + log the override reason if provided.
- **Re-running `/jr-build-spec` on an existing Sketch**: detect the sketch, read it, apply user's new input on top, re-build, re-score. If score ≥60, **move** file from `specs/sketches/` to `specs/`. If still <60, overwrite the sketch with new content + new report.
- **Spec already exists in `specs/` with `Status: Draft`**: this is iteration territory. Suggest `/jr-iterate-spec` instead.
- **Mode is `dev` but rubric scoring would be subjective on a particular dimension**: be honest in the report. Note "Insufficient information to evaluate" with score 50 (neutral) and flag as a question for the dev.
