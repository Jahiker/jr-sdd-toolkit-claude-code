# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## What This Project Is

**jr-toolkit** is a Spec-Driven Development (SDD) toolkit that installs Claude Code skills via `npx`. It covers the full development lifecycle: from raw idea → vision → architecture → roadmap → spec → implementation → verification → bug fixing, plus drift reconciliation, session continuity, and an opt-in dev mode for senior-level rigor.

## CLI Commands

```bash
# Install/manage skills locally
npx @jahiker/claude-toolkit install
npx @jahiker/claude-toolkit uninstall
npx @jahiker/claude-toolkit list
npx @jahiker/claude-toolkit help

# Manual installation (bash)
./install-all.sh
```

There is no build step, no transpilation, and no test suite yet (`npm test` is a placeholder).

## Architecture

### Entry Point

`bin/jr-toolkit.js` — Node.js CLI that copies skill files from the package into `~/.claude/skills/` and `~/.claude/commands/`.

### Skills (in `skills/`)

Each skill directory contains:
- `SKILL.md` — actual Claude Code skill instructions (compact English; source of truth for behavior)
- `command.md` — user-facing slash command help, with YAML frontmatter (`description`, `model`, `tools`) since v1.8.1
- `install.sh` — copies files to `~/.claude/`

#### Model assignment per command (v1.8.1+)

Commands declare their preferred model in `command.md` frontmatter. Claude Code respects this when the slash command runs. Cost-conscious assignment:

| Tier | Model | Skills |
|---|---|---|
| Mechanical / read-only | `haiku` | jr-status, jr-progress, jr-sync, jr-init |
| Reasoning | `sonnet` | jr-vision, jr-arch, jr-roadmap, jr-build-spec, jr-iterate-spec, jr-patch, jr-worklist, jr-verify-spec, jr-fix-spec |
| Code-writing critical | `opus` | jr-exe-spec |

Users can override per-invocation with `/model <name>` if needed. Tool restrictions (`tools:` frontmatter) provide defense-in-depth — e.g. jr-status only has `Read, Glob, Grep`, so it cannot write or execute even if Claude tried.

**Project kickoff:**

| Skill | Slash Command | Input → Output |
|---|---|---|
| `jr-vision` | `/jr-vision` | Raw idea → `docs/vision.md` |
| `jr-arch` | `/jr-arch` | `docs/vision.md` → `docs/architecture.md` + `PROJECT.md` |
| `jr-roadmap` | `/jr-roadmap` | Vision + Architecture → `docs/roadmap.md` + spec placeholders |
| `jr-init` | `/jr-init [--dev\|--no-dev]` | Existing project → `PROJECT.md` with `Mode:` set |

**Feature development:**

| Skill | Slash Command | Input → Output |
|---|---|---|
| `jr-build-spec` | `/jr-build-spec [--dev\|--no-dev]` | Chat text or `@req.md` → `specs/feature.md` (Draft) or `specs/sketches/feature.md` (Sketch in dev mode) |
| `jr-iterate-spec` | `/jr-iterate-spec` | Existing spec + change → new version (Draft) |
| `jr-patch` | `/jr-patch [--dev\|--no-dev]` | Trivial low-risk change → direct edit + progress log, no spec (risk classifier redirects non-trivial changes to fix-spec/iterate-spec) |
| `jr-worklist` | `/jr-worklist @doc \| next \| status` | QA document → tracked worklist in specs/worklists/, one-item-at-a-time gate, dev-context checkpoint, per-item routing (patch/fix/spec) |
| `jr-exe-spec` | `/jr-exe-spec [--dev\|--no-dev]` | Approved spec → code (Implemented) |
| `jr-verify-spec` | `/jr-verify-spec` | Implemented spec → coverage report (Verified) |

**Maintenance, visibility & continuity:**

| Skill | Slash Command | Input → Output |
|---|---|---|
| `jr-fix-spec` | `/jr-fix-spec` | Bug report `.md` → fix applied + hotfix in original spec |
| `jr-status` | `/jr-status` | — → dashboard of all specs |
| `jr-sync` | `/jr-sync` | Existing project + `PROJECT.md` → drift report + updated `PROJECT.md` |
| `jr-progress` | `/jr-progress` | — (or `--note "..."`) → recent log entries / appended note |

### Spec Lifecycle

```
                                  ┌── (only via --dev) ──┐
                                  ↓                       ↑
Pending → Sketch → Draft → Implemented → Verified
                    ↑                       |
                    └──── jr-iterate ───────┘

Bug lifecycle:    specs/fixes/bug.md → jr-fix-spec → Resolved
Drift lifecycle:  jr-sync detects PROJECT.md ↔ codebase divergence
Continuity:       all modifier skills append to docs/progress.md
```

A `Sketch` is created when `jr-build-spec --dev` produces a spec that scores below 60 on the readiness rubric. Lives in `specs/sketches/` and is invalid input for `jr-exe-spec --dev`.

### Stack Patterns

`skills/jr-exe-spec/references/stack-patterns.md` — coding conventions for 20+ stacks, lazy-loaded only when needed.

## Operating Modes (v1.8.0+)

Two modes, persisted in `PROJECT.md` as `**Mode:** default` or `**Mode:** dev` inside the `Toolkit Context` block.

### Mode resolution (in order)

1. Explicit `--dev` or `--no-dev` flag in invocation
2. `**Mode:**` value in PROJECT.md Toolkit Context
3. Default to `default` if neither is set

### What dev mode adds (Phase 1, v1.8.0)

- **`jr-build-spec --dev`**: 6-dimension weighted readiness rubric (Clarity 15%, Testability 25%, Boundaries 10%, Deps 15%, Risks 15%, Architecture 20%). Score <60 → Sketch (blocks exe-spec --dev). 60–74 → Draft + Needs work flag (blocks exe-spec --dev). 75–89 → Draft. ≥90 → Excellent badge.
- **`jr-exe-spec --dev`**: refuses Sketches and Needs work specs by default. Asks 3 pre-plan gates (files-to-touch / risk / rollback) and validates answers against the internal plan. Vague answers rejected (less than 10 words for risk, generic terms only, "git revert" insufficient when DB is touched). Up to 2 reformulations + explicit override (logged to History + progress.md).

### Dev mode coverage (complete as of v1.11.0)

- **`jr-build-spec --dev`** (v1.8.0): 6-dimension readiness rubric, sketches dir.
- **`jr-exe-spec --dev`** (v1.8.0): 3 pre-execution gates (files-to-touch / risk / rollback).
- **`jr-verify-spec --dev`** (v1.11.0): executable E2E command per AC + negative cases per FR, manual per-AC signoff ("reviewed by reading" not accepted), Verification Quality score (0.5·executed-pass + 0.3·negative-pass + 0.2·diff-review; ≥85 and zero fails → Verified), evidence persisted in spec as `## Verification Evidence`.
- **`jr-fix-spec --dev`** (v1.11.0): bug report quality score (reproducibility 25%, localization 20%, expected-vs-actual 25%, frequency 10%, recent-changes 20%); <70 triggers targeted questions, honest unknowns release the gate; ⚠️ regression items need explicit dev confirmation.
- **`jr-iterate-spec --dev`** (v1.11.0): 3-question iteration justification (origin, impact on implemented FRs, affected ACs) with push-back on vague answers and logged override.

## Design Principles for Skills

- **i18n separation**: SKILL.md instructions in English (internal); responses to user in their conversation language; generated files in the `Docs language` recorded in PROJECT.md Toolkit Context.
- **Token optimization**: SKILL.md files are compact (no explanatory prose); the Toolkit Context block in PROJECT.md is read once per session and centralizes Stack/Architecture/Conventions/Mode; references are lazy-loaded.
- **Mandatory writes**: skills that create files write them without asking confirmation; skill does not finish until file exists on disk.
- **Traceability**: code created by `jr-exe-spec` is tagged with `// spec: specs/[name].md`; blocks fixed by `jr-fix-spec` with `// fix: specs/fixes/[bug].md — [one-line]`.
- **Session continuity**: every modifier skill appends a one-block entry to `docs/progress.md` at the end of its run. Append-only, read on-demand via `/jr-progress`.
- **Read on demand, not eagerly**: skills don't read `docs/progress.md` automatically.
- **Mode is opt-in rigor, not enforcement**: `--dev` is a tool for developers who want stricter checkpoints. Skipping is always available via `--no-dev` or `override` paths. The toolkit logs but doesn't block irreversibly.

## Project files vs Skill artifacts

When the toolkit is used in a real project, the user's project ends up with:

```
[user-project]/
├── PROJECT.md              ← jr-init / jr-arch / jr-sync (includes Mode field)
├── docs/
│   ├── vision.md           ← jr-vision
│   ├── architecture.md     ← jr-arch
│   ├── roadmap.md          ← jr-roadmap
│   └── progress.md         ← all modifier skills (append) + /jr-progress --note
├── specs/
│   ├── [feature].md        ← jr-build-spec (default or score≥60) / jr-iterate-spec / jr-exe-spec / jr-verify-spec
│   ├── sketches/
│   │   └── [feature].md    ← jr-build-spec --dev (score<60)
│   └── fixes/
│       └── [bug].md        ← jr-fix-spec
└── [project's actual code, modified by jr-exe-spec / jr-fix-spec]
```

## Publishing

See `PUBLISH.md` for the full release checklist. Key steps: update version in `package.json`, commit + tag, push, then `npm publish --access public`.
