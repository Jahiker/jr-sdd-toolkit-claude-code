---
name: jr-sync
description: Use when the user runs /jr-sync or wants to verify whether PROJECT.md (especially the Toolkit Context block) is still aligned with the actual project state. Detects drift in stack, architecture, conventions, and the specs table, then reconciles surgically. Triggers: "sync project", "is PROJECT.md outdated", "update toolkit context", "reconcile project context", /jr-sync.
---

# jr-sync

Detect and reconcile drift between PROJECT.md and the actual project state. Surgical: only touches what drifted, preserves manual sections.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → use Docs language.
- If PROJECT.md doesn't exist → stop, suggest `/jr-init` first.
- Never auto-overwrite. Always present drift, ask for approval, then apply.
- Preserve all manual edits in sections not flagged as drifted.

## Steps

**0. Read state**
- Load PROJECT.md fully. Extract: Toolkit Context block, Tech Stack, Architecture, Conventions, Project specs table (if present), last updated date.
- Re-explore project (same logic as jr-init step 1): package.json / composer.json / pyproject.toml, README.md, CLAUDE.md, config files (.eslintrc, tsconfig.json, vite.config.*, tailwind.config.*, docker-compose.yml, .env.example), root structure 2 levels deep, `specs/` folder contents.
- Announce in user's language: "Reading PROJECT.md and re-scanning project..."

**1. Compute drift**
Compare documented vs detected. Classify each finding into a category:

| Category | What to detect |
|---|---|
| 🧱 Stack | New deps, removed deps, major version bumps, new dev tools |
| 🏗️ Architecture | New top-level dirs, removed dirs, build tool change, new modules |
| 🧹 Conventions | Lint config changed, formatter config changed, tsconfig strictness changed |
| 🧭 Toolkit Context | One-line summaries (Stack / Architecture / Conventions) no longer accurate |
| 📋 Specs table | New specs in specs/ not listed, listed specs that no longer exist, status mismatches |
| 🌐 Other | New env vars in .env.example, new useful commands in package.json scripts |

If zero drift → report "PROJECT.md está sincronizado" (in user's language) and exit. Skill done.

**2. Present drift report** (in user's language)

```
🔍 Drift Report — PROJECT.md vs proyecto real
Last PROJECT.md update: [date from history]
Categories with drift: [list]

🧱 Stack (N changes)
  + Added:    [package@version, ...]
  − Removed:  [package, ...]
  ↑ Bumped:   [package: oldVer → newVer (major)]

🏗️ Architecture (N changes)
  + New dirs: [paths]
  − Removed:  [paths]
  ⚠ Build:    [old → new, e.g. webpack → vite]

🧹 Conventions (N changes)
  ⚠ [config file] changed: [brief diff summary]

🧭 Toolkit Context block needs update:
  Stack line:        "[current]" → "[suggested]"
  Architecture line: "[current]" → "[suggested]"
  Conventions line:  "[current]" → "[suggested]"

📋 Specs table (N changes)
  + Untracked specs in specs/: [filenames]
  − Listed but missing:        [filenames]
  ⚠ Status changed:            [spec: oldStatus → newStatus from spec frontmatter]

🌐 Other
  + New env vars: [keys]
  + New scripts:  [npm script names]
```

**3. Ask user which to apply**
Offer three modes:
- `all` — apply every detected drift
- `selective` — go category by category (Stack? y/n. Architecture? y/n. ...)
- `cancel` — write nothing, exit

Wait for response. If `selective`, walk through each category.

**4. Apply approved updates surgically**

> ⚠️ Mandatory once user approves. Skill does not finish until PROJECT.md is updated on disk. Preserve all sections not flagged as drifted.

For each approved category:
- **Stack**: update Tech Stack section table. Append new entries, remove vanished ones, update versions.
- **Architecture**: update Architecture section (directory tree, modules table). Note major changes (e.g. build tool migration) in Additional notes.
- **Conventions**: update Conventions section.
- **Toolkit Context**: update the three one-line summaries. Preserve Docs language and dirs paths.
- **Specs table**: rebuild Project specs table from actual specs/ folder. Read each spec's frontmatter for current Status.
- **Other**: update Required env vars, Useful commands.

Add a History entry: `| [next-patch] | [date] | Synced | jr-sync — [N categories synced] |`.

**5. Confirm + log progress**
Respond in user's language with:
- Summary of what was updated
- Sections preserved untouched
- If specs table changed: count of untracked / missing / status updates
- Suggested next step:
  - If new specs detected → suggest reviewing each
  - If breaking architecture changes → suggest reviewing existing specs that depend on changed modules
  - Otherwise → "PROJECT.md está al día"

Append entry to `docs/progress.md` (create with header if missing). Use today's date:
```
## YYYY-MM-DD — jr-sync — general
Synced PROJECT.md. Categories: [list of categories updated]. [Specs table delta if any]
```

## Special cases

- **No PROJECT.md** → stop. Ask user to run `/jr-init` first.
- **Toolkit Context block missing** in PROJECT.md → flag as critical drift. Recreate the block from detected state, ask user to confirm before writing.
- **Conflicting CLAUDE.md** (different stack/conventions stated there) → flag as discrepancy in report, prioritize CLAUDE.md as source of truth, note in Additional notes.
- **Massive drift** (>10 stack changes, architecture overhauled) → suggest re-running `/jr-init` instead, since the project changed substantially.
- **Monorepo** → run drift detection per package/app if structure detected. Report per-package.
- **specs/ folder doesn't exist** → skip Specs table category, do not flag as drift.

## Principles
- Surgical, not destructive. Touch what changed; leave what didn't alone.
- User is in control — every drift requires approval before being written.
- The Toolkit Context block is the most important target: every other jr-* skill reads it. Keeping it accurate is the highest-value reconciliation.
