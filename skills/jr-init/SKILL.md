---
name: jr-init
description: Use when the user runs /jr-init or wants to initialize a project for the spec-driven toolkit. Triggers: "initialize project", "setup project", "init project", /jr-init.
---

# jr-init

Initialize a project for the jr-toolkit. Creates or updates PROJECT.md with stack, architecture, conventions and the `## Toolkit Context (jr-toolkit)` block that all other skills read.

## Rules
- Respond to user in their conversation language.
- Write PROJECT.md in the Docs language chosen by the user.
- If PROJECT.md exists → update only changed sections, preserve manual edits.
- If PROJECT.md does not exist → ask user for preferred Docs language first, then create.

## Steps

**0. Check state**
Verify existence of: CLAUDE.md (read, don't modify), PROJECT.md (update vs create), specs/ (count specs). Announce findings in user's language.

**1. Explore project**
Read: package.json / composer.json / pyproject.toml, README.md, CLAUDE.md, config files (.eslintrc, tsconfig.json, vite.config.*, tailwind.config.*, docker-compose.yml, .env.example). Scan root structure 2 levels deep.

Identify: languages + versions, frameworks, build tools, styles, testing, DB/ORM, infrastructure, naming conventions, import style, export patterns, error handling, state management.

**2. Create or update PROJECT.md**

> ⚠️ Mandatory. Write file without asking. Skill does not finish until PROJECT.md exists on disk.

Include these sections (written in Docs language):
- Project name, description, Docs language, last updated date
- Tech Stack (languages, frameworks, build, styles, testing, DB, infra)
- Architecture (type, pattern, directory structure, where things live, data flow)
- Conventions (naming, imports, exports, error handling, state)
- Technical decisions (already-made decisions not to reverse)
- Required environment variables (from .env.example)
- Useful commands (dev, build, test, lint)
- Project specs (table from specs/ or "No specs yet")
- Additional notes

**Critical — always include this block** (in English regardless of Docs language):
```
## Toolkit Context (jr-toolkit)

> This section is read by all jr-* skills at session start. Keep it accurate.

**Docs language:** [chosen language]
**Stack:** [one-line summary]
**Architecture:** [one-line summary]
**Conventions:** [one-line summary]
**Specs dir:** specs/
**Fixes dir:** specs/fixes/
**Docs dir:** docs/
```

**3. Confirm**
Respond in user's language with: files created/updated, stack detected, architecture summary, list of available toolkit commands, suggested next step based on project state.

## Special cases
- Large project (50+ root files): focus on config files and first-level dirs only.
- No config files found: document what's inferable, mark unknowns as `[To be defined]`.
- Monorepo: document packages/apps separately, identify shared vs specific.
- CLAUDE.md contradicts detected info: prioritize CLAUDE.md, note discrepancy in Additional notes.
