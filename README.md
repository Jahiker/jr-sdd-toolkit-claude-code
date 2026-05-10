# jr-toolkit

**Spec-Driven Development toolkit for Claude Code**

From raw idea to verified code — a complete structured workflow for AI-assisted development. Define specs first, implement second, verify third. With session continuity built-in.

[![npm version](https://img.shields.io/npm/v/@jahiker/claude-toolkit.svg)](https://www.npmjs.com/package/@jahiker/claude-toolkit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## What is this?

`jr-toolkit` is a set of Claude Code skills and slash commands that bring structure to every phase of software development: from the first idea to shipping verified features, fixing bugs, and keeping continuity across sessions.

```
# Starting a new project
/jr-vision         →  Idea → Product vision document
/jr-arch           →  Vision → Technical architecture
/jr-roadmap       →  Architecture → Ordered feature backlog

# Building features (new projects or existing)
/jr-init           →  Project context (PROJECT.md)
/jr-build-spec     →  Rough requirement → Polished spec
/jr-iterate-spec   →  Iterate an existing spec
/jr-exe-spec       →  Approved spec → Working code
/jr-verify-spec    →  Code → Acceptance criteria coverage report

# Maintenance & continuity
/jr-fix-spec       →  Bug report → Diagnosed, fixed, documented
/jr-status         →  Dashboard of all project specs
/jr-sync           →  Detect and reconcile drift in PROJECT.md
/jr-progress       →  Read or append narrative progress log
```

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
/jr-init      # 4. Initialize project context (PROJECT.md)

# Then for each feature in roadmap order:
/jr-build-spec       # Direct chat input or @req.md
/jr-exe-spec @specs/feature.md
/jr-verify-spec @specs/feature.md
```

### Working on an existing project

```
/jr-progress                   # 0. Recover context from previous sessions
/jr-init                       # 1. Generate PROJECT.md from existing codebase
/jr-build-spec                 # 2. Turn requirement (chat or @req.md) into spec
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
| jr-roadmap | `/jr-roadmap` | `docs/vision.md` + `docs/architecture.md` | `docs/roadmap.md` + `specs/` placeholders |
| jr-init | `/jr-init` | Existing project | `PROJECT.md` |

### Feature development

| Skill | Command | Input | Output |
|---|---|---|---|
| jr-build-spec | `/jr-build-spec` | Direct chat text **or** `@req.md` | `specs/feature.md` (Draft) |
| jr-iterate-spec | `/jr-iterate-spec @specs/x.md` | Existing spec + change | Updated spec (new version) |
| jr-exe-spec | `/jr-exe-spec @specs/x.md` | Approved spec | Code + spec → Implemented |
| jr-verify-spec | `/jr-verify-spec @specs/x.md` | Implemented spec | Coverage report + spec → Verified |

### Maintenance, visibility & continuity

| Skill | Command | Input | Output |
|---|---|---|---|
| jr-fix-spec | `/jr-fix-spec @specs/fixes/bug.md` | Bug report `.md` | Fix applied + documentation updated |
| jr-status | `/jr-status` | — | Dashboard of all specs |
| jr-sync | `/jr-sync` | Existing project + PROJECT.md | Drift report + updated PROJECT.md |
| jr-progress | `/jr-progress` | — (or `--note "..."`) | Recent log entries / appended note |

---

## Spec lifecycle

```
Pending → Draft → Implemented → Verified
            ↑                      |
            └──── jr-iterate ──────┘  (new version, back to Draft)

Bug lifecycle:
specs/fixes/bug.md → jr-fix-spec → Resolved (hotfix entry in original spec)
```

---

## Session continuity (new in 1.7.0)

Every modifier skill automatically appends an entry to `docs/progress.md` — a chronological narrative log of what's been done in the project. When you return to a project after time away, run `/jr-progress` to recover context fast without reading every spec.

```bash
# Read recent activity
/jr-progress

# Show full log
/jr-progress --all

# Filter by date or target
/jr-progress --since=2026-04-01
/jr-progress --target=auth-oauth

# Add a manual note (client decisions, blockers, etc.)
/jr-progress --note "Stripe key arrives Friday; payment-flow blocked until then"
```

The log is append-only and complements `/jr-status`:
- `/jr-status` answers **what's the state of each spec right now?**
- `/jr-progress` answers **what happened recently and why?**

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

Issues and PRs welcome at [github.com/Jahiker/jr-sdd-toolkit-claude-code](https://github.com/Jahiker/jr-sdd-toolkit-claude-code). If you find a skill behaving unexpectedly in a real project, open an issue with the context — real-world feedback is what makes these skills better.

---

## License

MIT — see [LICENSE](./LICENSE)
