---
name: jr-progress
description: Use when the user runs /jr-progress or wants to read or append to the project's progress log. Default mode shows recent entries; --note mode appends a manual entry. Triggers: "show progress", "what happened recently", "recent activity", "log a note", "progress log", "session continuity", /jr-progress.
---

# jr-progress

Read or append to the project's progress log (`docs/progress.md`) — a chronological narrative of work done in the project, automatically updated by every modifier skill.

The log is for **session continuity**, not detailed history. Each spec already has its History table; this log is a quick "what happened across the project" view to recover context fast.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → use Docs language for any new content.
- File location: `docs/progress.md` (create if missing when writing).
- Never edit or rewrite past entries — log is append-only.
- Default mode is read; only switch to write mode if user explicitly asks (`--note`, "agrega nota", "log esto").

## Modes

### Read mode (default)

Show recent entries. Variants:

- **Default** → last 10 entries
- **`--all`** → full file
- **`--since=YYYY-MM-DD`** → entries from that date onwards
- **`--target=name`** → entries that mention a specific spec/doc target (substring match on heading)

### Note mode (write)

When user passes `--note "texto"` or asks to log a manual note (e.g. "agrega una nota: ..."):
- Append a new entry under heading `## YYYY-MM-DD — manual note`
- Body is the user's text (preserve newlines)
- Use cases: client decisions, blocking dependencies, postponed items, context that wouldn't go in a spec

## Steps

**0. Read PROJECT.md context**
Get Docs language. Check if `docs/progress.md` exists.

**1. Determine mode**
- If user passed `--note "..."`, "agrega nota", "log esto" → note mode
- Otherwise → read mode

**2A. Read mode**
- If `docs/progress.md` doesn't exist:
  - Tell user (in their language): log not created yet; will be created automatically by the next modifier skill, or run `/jr-progress --note "..."` to start it.
  - Skill done.
- Otherwise, parse entries (sections starting with `## YYYY-MM-DD`).
- Apply filter (`--since`, `--target`) or take last 10.
- Display in user's language with light formatting:

```
📜 Últimas N entradas — docs/progress.md

[date entry 1]
[date entry 2]
...

[Resumen: N entradas mostradas de M totales | última: YYYY-MM-DD]
```

- If recent entries reference `[PENDING]`, `[TBD]`, "blocked", "pendiente" or similar → highlight at the bottom: "⚠️ Hay items pendientes mencionados arriba."

**2B. Note mode**

> ⚠️ Mandatory once user asks to log. Skill does not finish until entry is written on disk.

- If `docs/progress.md` doesn't exist → create with this header (in English, structural):

```
# Project Progress Log

> Append-only narrative of work done in this project. Read with `/jr-progress` to recover context between sessions. Never edit past entries — append only.

---
```

- Append entry at the end (separator + heading + body):

```

## YYYY-MM-DD — manual note
[user's text]
```

- Confirm in user's language: entry added with date and first line preview.

## Special cases

- **Empty file (just header)** → in read mode, tell user: log exists but no entries yet.
- **File exists but malformed** (no `## YYYY-MM-DD` headings) → don't try to parse; show raw last 30 lines and warn.
- **Multiline note** → preserve newlines in the body; do not collapse.
- **User passes both `--note` and a read flag** → prioritize note mode, then show what was added.
- **No date in user input** → always use today's date (YYYY-MM-DD); never invent or accept past dates from user input.

## Format reference (used by other skills writing here)

Other jr-* skills append entries with this exact pattern:

```
## YYYY-MM-DD — jr-[skill] — [target]
[1-2 lines: what was done, files affected, pending items if any]
```

Where:
- `[skill]` is the skill name (e.g. `jr-exe-spec`, `jr-build-spec`)
- `[target]` is the spec slug, doc name, or `general` (when not tied to a single artifact)

Manual notes from `/jr-progress --note` use:

```
## YYYY-MM-DD — manual note
[user's text]
```

## Principles
- The log is for **navigation**, not detailed history. Specs already have their own History tables.
- Append-only is what makes it trustworthy as a session-continuity tool.
- Read by humans (and the next session of Claude) at the start of work to recover context faster than re-reading every spec.
