---
name: jr-patch
description: Use when the user runs /jr-patch or wants to make a trivial, low-risk change quickly without the full spec flow — colors, copy, spacing, typos, non-critical config values. NOT for logic, auth, DB, or anything that could break a critical flow. Triggers: "quick change", "small fix", "just change", "patch", /jr-patch.
---

# jr-patch

Fast path for atomic, low-risk changes that don't justify the full spec lifecycle. No spec created, no execution plan, no lifecycle — just: locate → classify risk → show diff → confirm → apply → log.

This skill exists to remove friction for trivial changes. Its safety comes entirely from the risk classifier: if a change isn't genuinely trivial, the skill refuses the fast path and redirects to `/jr-fix-spec` or `/jr-iterate-spec`.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → Stack, Conventions, Docs language, **Mode**.
- Mode resolution: `--dev`/`--no-dev` flag > PROJECT.md `Mode:` > `default`.
- Never create a spec. Never run the multi-phase execution plan. This is the lightweight path by definition.
- The risk classifier is mandatory and runs BEFORE any change is shown or applied. No exceptions.

## Steps

**0. Parse request + context**
- Read the change request (chat text or file reference).
- Read PROJECT.md Toolkit Context. Resolve mode.
- If request is empty → ask what to change.

**1. Locate the change**
Find the target file(s) and exact location. Use Grep/Glob. Do not read entire large files — locate surgically. If the target is ambiguous (multiple matches, unclear which), ask the user to disambiguate before proceeding.

**2. Risk classification (MANDATORY — this is the safety layer)**

Classify the change into one of three outcomes by checking against the criteria below, in order. Hard-block wins over soft-warn wins over allow.

### 🔴 Hard block — refuse fast path, redirect to full flow

The change touches ANY of:
- **Control flow logic**: conditions, loops, early returns, switch/match, ternaries that alter behavior
- **Auth / security**: authentication, authorization, permissions, validation, sanitization, tokens, sessions
- **Data layer**: DB queries, migrations, schema, ORM models, data transformations
- **Money / time / math**: currency, pricing, dates, timezones, calculations, rounding
- **External effects**: API calls, network requests, file system writes beyond the edit, env vars
- **Dependencies**: requires installing/removing/upgrading any package
- **Scope**: more than 2 files, OR more than ~15 changed lines

When hard-blocked, refuse clearly and redirect (in user's language):
```
⚠️ Este cambio no califica para /jr-patch porque [razón específica: e.g. "modifica lógica de validación en Login.tsx línea 40"].

Un cambio así merece trazabilidad completa. Te sugiero:
- Si es un bug → /jr-fix-spec
- Si es un cambio a una feature existente → /jr-iterate-spec @specs/[spec].md

¿Lanzo uno de esos en su lugar?
```
Do not apply the change. Stop here.

### 🟡 Soft warning — show risk, let user decide

The change (while not hard-blocked) does ANY of:
- Touches 2 files (at the edge of the limit)
- Approaches ~15 lines
- Modifies a file or block that carries a `// spec:` traceability comment (i.e. code born from a spec — changing it risks drifting the spec from its implementation)

When soft-warned, surface it (in user's language) and ask:
```
🟡 Heads up: [specific reason, e.g. "Header.tsx tiene un comentario // spec: specs/header-redesign.md — este código nació de un spec. Cambiarlo aquí dejará el spec desincronizado de la implementación."]

Opciones:
- Continuar con /jr-patch (rápido, dejaré rastro del cambio fuera de spec)
- Saltar a /jr-iterate-spec para mantener el spec sincronizado

¿Cómo seguimos?
```
Wait for explicit choice. If user chooses to continue, proceed to step 3 and remember to log the spec-drift note (see step 5).

### 🟢 Allow — proceed to fast path

The change is genuinely trivial and isolated. Examples that qualify:
- Aesthetic values: colors, spacing, sizes, fonts, border radius, shadows
- UI strings / copy / labels / placeholder text
- Non-critical config constants (feature flags off by default, display limits, etc.)
- Typos in code comments, docs, or user-facing text
- Import reordering, formatting, whitespace
- Comment additions or edits

**3. Show the diff** (not a plan — just the change)

Present a focused before/after diff (in user's language for surrounding explanation, code as-is):
```
📝 Cambio propuesto — `path/file.ext`

- [old line]
+ [new line]

[one-line description of what this does]

¿Aplico? (sí / ajustar)
```

**4. Apply on confirmation**

> ⚠️ Mandatory once user confirms. Apply the edit directly. Do not add `// spec:` comments — there is no spec for a patch. Skill does not finish until the change is on disk.

If the user requested adjustments, revise the diff and re-present.

**5. Log progress**

Append to `docs/progress.md` (create with header if missing). Use today's date:
```
## YYYY-MM-DD — jr-patch — [file or area]
[one-line: what changed]. No spec (trivial: [category, e.g. cosmetic / copy / config]).
```

If this was a soft-warned change on `// spec:` code (spec drift), the log entry MUST flag it so it's traceable later:
```
## YYYY-MM-DD — jr-patch — [file]
[what changed]. ⚠️ Out-of-spec change to code from specs/[spec].md — spec NOT updated. Consider /jr-iterate-spec if behavior diverges.
```

**6. Confirm** (in user's language)
Brief: what changed, where, and the progress entry added. No next-step ceremony — it's a patch, it's done.

## Mode interaction (`--dev`)

In `Mode: dev`, the safety layer is stricter:
- **Soft-warn thresholds drop**: more than 1 file OR more than ~8 lines triggers a soft warning (vs 2 files / 15 lines in default).
- **`// spec:` code is HARD-BLOCKED, not soft-warned**: in a serious project, you don't patch spec-born code without iterating. Redirect to `/jr-iterate-spec`.
- Everything else behaves the same. The fast path still exists for genuinely trivial cosmetic/copy changes, just with a tighter definition of "trivial".

In `Mode: default`, thresholds are as described in step 2.

## Special cases
- **User insists on patching something hard-blocked** ("just do it, it's fine"): hold the line once, re-explain the specific risk, and offer the override only with explicit acknowledgment: "I can apply it, but this bypasses the safety check on [risk]. Confirm you want to patch logic/auth/etc. directly?" If confirmed, apply and log with a prominent `⚠️ override: hard-block bypassed on [risk]` note. This respects user autonomy while keeping the trail. (In `Mode: dev`, do not offer this override for auth/security/DB changes — those always go to the full flow.)
- **Change turns out bigger once located** (user said "fix the typo" but it's actually 5 files): re-classify based on reality, not the request's framing. Announce the reclassification.
- **No PROJECT.md**: jr-patch can still work (it doesn't strictly need Toolkit Context), but warn that mode defaults to `default` and conventions may not be applied. Suggest `/jr-init` for better results.
- **Multiple unrelated changes in one request**: jr-patch handles one atomic change. If the request bundles several, suggest splitting or handling the largest via the full flow.

## Principles
- The fast path is a privilege earned by the change being trivial — not a right of the user to skip process.
- The classifier protects the user from themselves on a bad day. "It's just one line" is exactly when the check matters most.
- Every patch leaves a trail in progress.md, even though it skips the spec. Nothing happens invisibly.
- When in doubt, the skill redirects to the full flow. A false redirect costs a few minutes; a false fast-path can cost a production incident.
