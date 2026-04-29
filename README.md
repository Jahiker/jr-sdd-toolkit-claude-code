# jr-toolkit

**Spec-Driven Development toolkit for Claude.ai**

From raw idea to verified code — a complete structured workflow for AI-assisted development. Define specs first, implement second, verify third.

---

## What is this?

`jr-toolkit` is a set of Claude.ai skills and slash commands that bring structure to every phase of software development: from the first idea to shipping verified features and fixing bugs.

```
# Starting a new project
/jr-vision    →  Idea → Product vision document
/jr-arch      →  Vision → Technical architecture
/jr-roadmap   →  Architecture → Ordered feature backlog

# Building features (new projects or existing)
/jr-init      →  Project context (PROJECT.md)
/jr-build-spec →  Rough requirement → Polished spec
/jr-iterate-spec → Iterate an existing spec
/jr-exe-spec  →  Approved spec → Working code
/jr-verify-spec → Code → Acceptance criteria coverage report

# Maintenance
/jr-fix-spec  →  Bug report → Diagnosed, fixed, documented
/jr-status    →  Dashboard of all project specs
```

---

## Installation

### Via npm (recommended)

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
git clone https://github.com/Jahiker/jr-toolkit.git
cd jr-toolkit
chmod +x install-all.sh
./install-all.sh
```

After installing, **restart Claude.ai** to activate the skills.

---

## Two workflows

### Starting a new project from scratch

```
/jr-vision    # 1. Define product vision from a raw idea
/jr-arch      # 2. Define technical architecture and stack
/jr-roadmap   # 3. Break down into ordered features with dependencies
/jr-init      # 4. Initialize project context (PROJECT.md)

# Then for each feature in roadmap order:
/jr-build-spec @req.md
/jr-exe-spec @specs/feature.md
/jr-verify-spec @specs/feature.md
```

### Working on an existing project

```
/jr-init           # 1. Generate PROJECT.md from existing codebase
/jr-build-spec @req.md  # 2. Turn requirements into specs
/jr-exe-spec @specs/x.md    # 3. Implement
/jr-verify-spec @specs/x.md # 4. Verify
/jr-status         # 5. Track progress
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
| jr-build-spec | `/jr-build-spec @req.md` | Rough requirement `.md` | `specs/feature.md` (Draft) |
| jr-iterate-spec | `/jr-iterate-spec @specs/x.md` | Existing spec + change | Updated spec (new version) |
| jr-exe-spec | `/jr-exe-spec @specs/x.md` | Approved spec | Code + spec → Implemented |
| jr-verify-spec | `/jr-verify-spec @specs/x.md` | Implemented spec | Coverage report + spec → Verified |

### Maintenance & visibility

| Skill | Command | Input | Output |
|---|---|---|---|
| jr-fix-spec | `/jr-fix-spec @specs/fixes/bug.md` | Bug report `.md` | Fix applied + documentation updated |
| jr-status | `/jr-status` | — | Dashboard of all specs |

---

## Spec lifecycle

```
Pending → Draft → Implemented → Verified
            ↑                      |
            └──── jr-iterate ───────┘  (new version, back to Draft)

Bug lifecycle:
specs/fixes/bug.md → jr-fix-spec → Resolved (hotfix entry in original spec)
```

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

---

## Uninstall

```bash
npx @jahiker/claude-toolkit uninstall
```

---

## Requirements

- [Claude.ai](https://claude.ai) account (Pro, Team, or Enterprise)
- Claude Code or Claude.ai with skills support
- Node.js ≥ 16 (for npm installation)

---

## Contributing

Issues and PRs are welcome. If you find a skill behaving unexpectedly in a real project, open an issue with the context — real-world feedback is what makes these skills better.

---

## License

MIT
