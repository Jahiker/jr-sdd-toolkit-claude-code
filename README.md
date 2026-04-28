# jr-toolkit

**Spec-Driven Development toolkit for Claude.ai**

Transform rough requirements into professional technical specs, implement them with full traceability, and verify coverage — all from Claude.ai slash commands.

---

## What is this?

`jr-toolkit` is a set of Claude.ai skills and slash commands that bring structure to AI-assisted development. Instead of chatting your way through features, you define specs first, implement second, and verify third.

```
/jr-init          →  Project context (PROJECT.md)
/jr-build-spec    →  Rough requirement → Polished spec
/jr-iterate-spec  →  Iterate an existing spec
/jr-exe-spec      →  Approved spec → Working code
/jr-verify-spec   →  Code → Acceptance criteria coverage report
/jr-status        →  Dashboard of all project specs
```

---

## Installation

### Via npm (recommended)

```bash
npx jr-toolkit install
```

### Via npm (global)

```bash
npm install -g jr-toolkit
jr-toolkit install
```

### Manual

```bash
git clone https://github.com/YOUR_USERNAME/jr-toolkit.git
cd jr-toolkit
chmod +x install-all.sh
./install-all.sh
```

After installing, **restart Claude.ai** to activate the skills.

---

## Usage

### 1. Initialize your project

Run once per project to generate `PROJECT.md` — a persistent context file all skills read at the start of each session.

```
/jr-init
```

### 2. Build a spec from a rough requirement

```
/jr-build-spec @docs/new-feature.md
```

The skill analyzes your project, detects overlaps with existing specs, asks categorized questions (client & dev), and produces a professional spec in `specs/`.

### 3. Iterate an existing spec

```
/jr-iterate-spec @specs/notifications.md

Add email channel support alongside push.
Users should choose their preferred channels from profile settings.
```

Semantic versioning: patch (`1.0→1.1`) for small changes, minor (`1.0→2.0`) for structural ones.

### 4. Execute a spec

```
/jr-exe-spec @specs/notifications.md
```

The skill generates an explicit execution plan by phase, waits for your approval, then implements all changes with full traceability (`// spec: specs/notifications.md` in every touched file).

### 5. Verify coverage

```
/jr-verify-spec @specs/notifications.md
```

Reads the spec, walks the affected files, and evaluates each acceptance criterion:
- ✅ Covered
- ⚠️ Partial
- ❌ Absent
- 🔍 Not verifiable in code (needs runtime test)

Generates a coverage report with exact gap locations and suggestions.

### 6. Check project status

```
/jr-status
```

Dashboard of all specs: status, version, pending items, dependencies, anomalies, and prioritized next steps.

---

## Spec lifecycle

```
Draft → Implemented → Verified
  ↑                      |
  └──── jr-iterate ───────┘  (new version, back to Draft)
```

---

## Skills reference

| Skill | Command | Input | Output |
|---|---|---|---|
| jr-init | `/jr-init` | — | `PROJECT.md` |
| jr-build-spec | `/jr-build-spec @req.md` | Rough requirement `.md` | `specs/feature.md` (Draft) |
| jr-iterate-spec | `/jr-iterate-spec @specs/x.md` | Existing spec + change description | Updated spec (new version) |
| jr-exe-spec | `/jr-exe-spec @specs/x.md` | Approved spec | Code changes + spec updated to Implemented |
| jr-verify-spec | `/jr-verify-spec @specs/x.md` | Implemented spec | Coverage report + spec updated to Verified |
| jr-status | `/jr-status` | — | Dashboard of all specs |

---

## Stack support

`jr-exe-spec` includes patterns and conventions for:

JavaScript · TypeScript · PHP · React · Next.js · TanStack Query · Vue 3 · Node.js · Laravel · WordPress · Shopify · CSS · Sass · Tailwind CSS · Webpack · Vite · Docker

---

## Uninstall

```bash
npx jr-toolkit uninstall
```

---

## CLI commands

```bash
npx jr-toolkit install     # Install all skills to ~/.claude/
npx jr-toolkit uninstall   # Remove all skills
npx jr-toolkit list        # List skills and their install status
npx jr-toolkit help        # Show help
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
