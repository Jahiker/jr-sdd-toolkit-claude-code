# jr-toolkit (@jahiker/claude-toolkit)

Spec-Driven Development toolkit for Claude Code — specs, implementation, verification, session continuity, full dev mode, fast path for trivial changes, QA worklist orchestration, and spec-to-code drift detection. Installed via `npx`.

**Docs language:** English
**Last updated:** 2026-07-04

## Tech Stack

- **Language:** JavaScript (vanilla, CommonJS), Node.js >= 16 — no TypeScript, no transpilation
- **Runtime deliverable:** npm package `@jahiker/claude-toolkit` v1.12.0, binary `claude-toolkit` → `bin/jr-toolkit.js`
- **Scripting:** Bash (`install-all.sh`, per-skill `install.sh`)
- **Content format:** Markdown — skill behavior is defined in `SKILL.md` files, not code
- **Build:** none (no build step by design)
- **Testing:** none yet (`npm test` is a placeholder)
- **Linting/formatting:** none configured
- **Infrastructure:** npm registry (public), GitHub (Jahiker/jr-sdd-toolkit-claude-code)

## Architecture

- **Type:** npx-installable CLI that distributes Claude Code skills
- **Entry point:** `bin/jr-toolkit.js` — copies skill files from the package into `~/.claude/skills/` and `~/.claude/commands/`
- **Skill anatomy** (each directory under `skills/`):
  - `SKILL.md` — actual skill instructions (compact English; source of truth for behavior)
  - `command.md` — user-facing slash command help with YAML frontmatter (`description`, `model`, `tools`)
  - `install.sh` — copies files to `~/.claude/`
- **Skills (15):** jr-vision, jr-arch, jr-roadmap, jr-init, jr-build-spec, jr-iterate-spec, jr-patch, jr-worklist, jr-exe-spec, jr-verify-spec, jr-fix-spec, jr-status, jr-sync, jr-drift, jr-progress
- **Lazy-loaded references:** e.g. `skills/jr-exe-spec/references/stack-patterns.md` (conventions for 20+ stacks), read only when needed
- **Data flow:** user runs `npx @jahiker/claude-toolkit install` → CLI copies `skills/*/SKILL.md` + `command.md` into `~/.claude/` → Claude Code picks them up as `/jr-*` slash commands

## Conventions

- **SKILL.md style:** compact English, no explanatory prose (token optimization)
- **i18n separation:** skill instructions in English; responses to user in their conversation language; generated files in the project's Docs language
- **Model assignment per command** (frontmatter in `command.md`): haiku for mechanical/read-only (jr-status, jr-progress, jr-sync, jr-init), sonnet for analysis/reasoning, opus for code-writing critical (jr-exe-spec)
- **Tool restrictions:** `tools:` frontmatter as defense-in-depth (e.g. jr-status only has Read, Glob, Grep)
- **Traceability:** generated code tagged `// spec: specs/[name].md`; fixes tagged `// fix: specs/fixes/[bug].md — [one-line]`
- **Session continuity:** every modifier skill appends one block to `docs/progress.md` (append-only, read on demand)
- **Mandatory writes:** skills that create files write them without asking confirmation

## Technical Decisions

- No build step and no external npm dependencies — the CLI is a single plain-JS file
- Skill behavior lives in Markdown (`SKILL.md`), not in JavaScript; the CLI only installs files
- Two operating modes persisted in the target project's PROJECT.md: `default` and `dev` (opt-in rigor, never irreversible blocking)
- Per-command model tiers are cost-conscious and declared in `command.md` frontmatter (v1.8.1+)

## Environment Variables

None required (no `.env.example`).

## Useful Commands

```bash
npx @jahiker/claude-toolkit install     # install skills to ~/.claude/
npx @jahiker/claude-toolkit uninstall
npx @jahiker/claude-toolkit list
npx @jahiker/claude-toolkit help
./install-all.sh                        # manual local install
npm test                                # placeholder, no tests yet
```

Publishing: see `PUBLISH.md` (bump version in `package.json` → commit + tag → push → `npm publish --access public`).

## Project Specs

No specs yet.

## Additional Notes

- This is the toolkit's own repository; the skills it ships operate on *other* projects. The `specs/`, `docs/`, and PROJECT.md structure described in CLAUDE.md's "Project files vs Skill artifacts" section refers to consumer projects — this repo now also uses that structure for its own feature development.
- CLAUDE.md is the authoritative reference for skill design principles and the spec lifecycle.

## Toolkit Context (jr-toolkit)

> This section is read by all jr-* skills at session start. Keep it accurate.

**Docs language:** English
**Mode:** default
**Stack:** Node.js >= 16 vanilla-JS CLI (no build, no deps) + Bash installers + Markdown skill definitions, published to npm as @jahiker/claude-toolkit
**Architecture:** npx-installable skills toolkit — bin/jr-toolkit.js copies skills/*/SKILL.md + command.md into ~/.claude/; each skill = SKILL.md + command.md + install.sh
**Conventions:** compact-English SKILL.md, i18n separation, per-command model tiers in command.md frontmatter, tool restrictions, traceability comments, append-only progress log
**Specs dir:** specs/
**Sketches dir:** specs/sketches/
**Fixes dir:** specs/fixes/
**Docs dir:** docs/
