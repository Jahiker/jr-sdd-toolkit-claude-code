# jr-toolkit

**Spec-Driven Development toolkit for Claude Code**

From raw idea to verified code — a complete structured workflow for AI-assisted development. Define specs first, implement second, verify third. With session continuity built-in and **optional dev mode for senior-level rigor**.

[![npm version](https://img.shields.io/npm/v/@jahiker/claude-toolkit.svg)](https://www.npmjs.com/package/@jahiker/claude-toolkit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## What is this?

`jr-toolkit` is a set of Claude Code skills and slash commands that bring structure to every phase of software development: from the first idea to shipping verified features, fixing bugs, and keeping continuity across sessions.

```
# Starting a new project
/jr-vision         →  Idea → Product vision document
/jr-arch           →  Vision → Technical architecture
/jr-roadmap        →  Architecture → Ordered feature backlog

# Building features (new projects or existing)
/jr-init           →  Project context (PROJECT.md). Accepts --dev / --no-dev.
/jr-build-spec     →  Rough requirement → Polished spec. Accepts --dev.
/jr-iterate-spec   →  Iterate an existing spec
/jr-exe-spec       →  Approved spec → Working code. Accepts --dev.
/jr-verify-spec    →  Code → Acceptance criteria coverage report

# Maintenance & continuity
/jr-fix-spec       →  Bug report → Diagnosed, fixed, documented
/jr-status         →  Dashboard of all project specs
/jr-sync           →  Detect and reconcile drift in PROJECT.md
/jr-progress       →  Read or append narrative progress log
```

---

## Modes (new in 1.8.0)

The toolkit now has two operating modes:

| Mode | Behavior | Best for |
|---|---|---|
| **`default`** | Fluid flow. Skills do their work without additional gates. | Prototypes, exploration, personal projects, quick experiments. |
| **`dev`** | Critical modifier skills (`jr-build-spec`, `jr-exe-spec`) apply additional validations like a "code review by a second senior". | Serious projects where the cost of errors is high. |

### Setting the mode

The mode lives in `PROJECT.md` and applies project-wide:

```bash
/jr-init --dev      # set Mode: dev
/jr-init --no-dev   # set Mode: default (also the default if no flag)
/jr-init            # preserves existing Mode if PROJECT.md exists, else default
```

You can also override per-invocation:

```bash
/jr-build-spec @req.md --dev      # one-shot dev mode
/jr-exe-spec @specs/x.md --no-dev # bypass dev mode for this run
```

### What `--dev` adds (Phase 1 — v1.8.0)

**`jr-build-spec --dev`** runs a 6-dimension readiness rubric after building the spec:

- 🎯 Clarity of intent (15%)
- 🧪 Testability of ACs (25%)
- 🚧 Boundary definition (10%)
- 🔗 Dependency awareness (15%)
- ⚠️ Risk identification (15%)
- 🏗️ Architectural fit (20%)

| Score | Outcome |
|---|---|
| <60 | ❌ Saved as `specs/sketches/[slug].md`. Blocks `/jr-exe-spec --dev`. |
| 60–74 | ⚠️ Saved as Draft + `Needs work` flag. Blocks `/jr-exe-spec --dev`. |
| 75–89 | ✅ Saved as normal Draft. |
| ≥90 | 🌟 Saved as Draft with Excellent badge. |

**`jr-exe-spec --dev`** asks 3 questions before showing the execution plan:

1. **Files-to-touch:** which files do you expect to create/modify?
2. **Risk check:** what's the riskiest part of this implementation? (concrete, ≥10 words)
3. **Rollback check:** how would you revert if this fails in production?

Vague answers (generic terms, less than X words, "git revert" when the spec touches DB) are rejected with concrete examples. Up to 2 reformulations, then explicit override (logged to History + progress).

> Future phases: 1.9.0 will add `--dev` to `/jr-verify-spec` (E2E enforcement). 1.10.0 will extend it to `/jr-fix-spec` and `/jr-iterate-spec`.

---

## Installation

### Via npx (recommended — no install)

```bash
npx @jahiker/claude-toolkit install
```

### Via npm (global)

```bash
npm install -g @jahiker/claude-toolkit
claude-toolkit install
```

### Manual

```bash
git clone https://github.com/Jahiker/jr-sdd-toolkit-claude-code.git
cd jr-sdd-toolkit-claude-code
chmod +x install-all.sh
./install-all.sh
```

After installing, **restart Claude Code** to activate the skills.

---

## Two workflows

### Starting a new project from scratch

```
/jr-vision    # 1. Define product vision from a raw idea
/jr-arch      # 2. Define technical architecture and stack
/jr-roadmap   # 3. Break down into ordered features with dependencies
/jr-init      # 4. Initialize project context (add --dev for strict mode)

# Then for each feature in roadmap order:
/jr-build-spec       # Direct chat input or @req.md
/jr-exe-spec @specs/feature.md
/jr-verify-spec @specs/feature.md
```

### Working on an existing project

```
/jr-progress                   # 0. Recover context from previous sessions
/jr-init                       # 1. Generate PROJECT.md (--dev for strict mode)
/jr-build-spec                 # 2. Turn requirement into spec
/jr-exe-spec @specs/x.md       # 3. Implement
/jr-verify-spec @specs/x.md    # 4. Verify
/jr-status                     # 5. Track progress
/jr-sync                       # 6. Reconcile drift in PROJECT.md when needed
```

---

## Skills reference

### Project kickoff

| Skill | Command | Input | Output |
|---|---|---|---|
| jr-vision | `/jr-vision` | Raw idea (text or `.md`) | `docs/vision.md` |
| jr-arch | `/jr-arch` | `docs/vision.md` | `docs/architecture.md` + `PROJECT.md` |
| jr-roadmap | `/jr-roadmap` | Vision + Architecture | `docs/roadmap.md` + spec placeholders |
| jr-init | `/jr-init [--dev|--no-dev]` | Existing project | `PROJECT.md` with mode set |

### Feature development

| Skill | Command | Input | Output |
|---|---|---|---|
| jr-build-spec | `/jr-build-spec [--dev|--no-dev]` | Chat text **or** `@req.md` | `specs/feature.md` (Draft) or `specs/sketches/feature.md` (Sketch) |
| jr-iterate-spec | `/jr-iterate-spec @specs/x.md` | Existing spec + change | Updated spec (new version) |
| jr-exe-spec | `/jr-exe-spec @specs/x.md [--dev|--no-dev]` | Approved spec | Code + spec → Implemented |
| jr-verify-spec | `/jr-verify-spec @specs/x.md` | Implemented spec | Coverage report + spec → Verified |

### Maintenance, visibility & continuity

| Skill | Command | Input | Output |
|---|---|---|---|
| jr-fix-spec | `/jr-fix-spec @specs/fixes/bug.md` | Bug report | Fix applied + docs updated |
| jr-status | `/jr-status` | — | Dashboard of all specs |
| jr-sync | `/jr-sync` | Project + PROJECT.md | Drift report + updated PROJECT.md |
| jr-progress | `/jr-progress [--note "..."]` | — | Recent log entries / appended note |

---

## Per-command model assignment (v1.8.1+)

Each slash command declares its preferred model via frontmatter to keep costs in check:

| Skills | Model | Why |
|---|---|---|
| `/jr-status` · `/jr-progress` · `/jr-sync` · `/jr-init` | `haiku` | Mechanical / read-only — no creative reasoning needed |
| `/jr-vision` · `/jr-arch` · `/jr-roadmap` · `/jr-build-spec` · `/jr-iterate-spec` · `/jr-verify-spec` · `/jr-fix-spec` | `sonnet` | Reasoning-heavy but bounded |
| `/jr-exe-spec` | `opus` | Code-writing with cascading technical decisions — don't skimp |

Override per-invocation with `/model <name>` if needed. Each command also declares `tools:` (e.g. `/jr-status` only has `Read, Glob, Grep`) as defense-in-depth — preventing accidental writes or shell execution from skills that don't need them.

---

## Spec lifecycle

```
                              ┌── (--dev only) ──┐
                              ↓                   ↑
Pending → Sketch → Draft → Implemented → Verified
                    ↑                       |
                    └──── jr-iterate ───────┘  (new version, back to Draft)

Bug lifecycle:    specs/fixes/bug.md → jr-fix-spec → Resolved
Drift lifecycle:  jr-sync detects PROJECT.md ↔ codebase divergence
Continuity:       all modifier skills append to docs/progress.md
```

A `Sketch` is a spec that didn't pass the readiness rubric (score <60 in `--dev` mode). It lives in `specs/sketches/` and must be iterated until it passes.

---

## Session continuity

Every modifier skill automatically appends an entry to `docs/progress.md` — a chronological narrative log of what's been done in the project. When you return after time away, run `/jr-progress` to recover context fast.

```bash
/jr-progress                                  # last 10 entries
/jr-progress --all                            # full log
/jr-progress --since=2026-04-01               # filter by date
/jr-progress --target=auth-oauth              # filter by spec/doc
/jr-progress --note "Stripe key arrives Friday — payment-flow blocked"
```

`/jr-progress` answers **what happened recently and why**; `/jr-status` answers **what's the state of each spec right now**. Complementary, not redundant.

---

## Stack support

`jr-exe-spec` includes patterns and conventions for:

JavaScript · TypeScript · PHP · React · Next.js · TanStack Query · Vue 3 · Node.js · Laravel · WordPress · Shopify · CSS · Sass · Tailwind CSS · Webpack · Vite · Docker

---

## CLI commands

```bash
npx @jahiker/claude-toolkit install     # Install all skills to ~/.claude/
npx @jahiker/claude-toolkit uninstall   # Remove all skills
npx @jahiker/claude-toolkit list        # List skills and their install status
npx @jahiker/claude-toolkit version     # Show package version + install status
npx @jahiker/claude-toolkit help        # Show help
```

If you installed globally, replace `npx @jahiker/claude-toolkit` with `claude-toolkit`.

---

## Uninstall

```bash
npx @jahiker/claude-toolkit uninstall
```

---

## Requirements

- [Claude Code](https://docs.claude.com/en/docs/claude-code) installed and configured
- Node.js ≥ 16 (for npm installation)

---

## Contributing

Issues and PRs welcome at [github.com/Jahiker/jr-sdd-toolkit-claude-code](https://github.com/Jahiker/jr-sdd-toolkit-claude-code). Real-world feedback on the dev mode rubric calibration is especially welcome — if scores feel too lenient or too strict in your projects, open an issue with examples.

---

## License

MIT — see [LICENSE](./LICENSE)
