---
name: jr-iterate-spec
description: Use when the user runs /jr-iterate-spec or wants to iterate/extend/modify an existing spec. Accepts --dev / --no-dev flag for iteration justification gating. Triggers: "iterate spec", "add to spec", "modify spec", "new version of spec", "extend feature", /jr-iterate-spec. Does NOT create a new spec — versions the existing one.
---

# jr-iterate-spec

Version an existing spec with new changes. Semantic versioning: patch (1.0→1.1) for small changes, minor (1.0→2.0) for structural changes. In `--dev` mode, the iteration must be justified before it's applied — people iterate specs out of anxiety, not need.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → including **Mode**.
- Mode resolution: `--dev`/`--no-dev` flag > PROJECT.md `Mode:` > `default`.
- Requires TWO inputs: existing spec (@specs/name.md) + change description (text or .md). Ask if either missing.
- Preserve the existing spec's language — do not change it.
- Edit the existing spec file surgically — preserve all history.

## Scope discipline (cost control)
Iteration is a delta operation, not a rebuild. Keep the context footprint minimal:
- **Read the spec once** in step 0. Do not re-read it in later steps — work from what's in context.
- **Edit surgically, don't rewrite**: use targeted edits (str_replace-style) on the sections the delta touches — header fields, the specific FRs modified/added, the affected Technical Design subsections, Delta, History. Do NOT regenerate or rewrite untouched sections.
- **Do not scan the codebase** during iteration. The spec's own Affected Files section tells you what's implemented; conflict checking (step 2) works from the spec content, not from reading source files. Only read a source file if the user explicitly asks whether the change breaks something specific.
- **Multiple iterations in one session**: the spec is already in context from the first iteration — never re-read it for subsequent ones.

## Steps

**0. Read base spec**
Record: current version, status, all FRs+ACs, Affected Files section, history.

**1. Analyze change + announce evaluation** (in user's language)

Versioning rules:
- **Patch** (1.0→1.1): add AC to existing FR, clarify edge case, add NFR, small behavior extension
- **Minor** (1.0→2.0): new FRs, modify main flow, significant tech design change, new integrations, data model changes

Report to user: type detected, version change, FRs modified/added/removed, already-implemented files affected. Ask for confirmation.

**2. Check conflicts**
Does change contradict existing FRs? Break already-implemented behavior? Have unmet dependencies? Is it so large it should be a new spec? Report issues in user's language. Respect user's decision.

**2.5. Iteration justification gate (DEV MODE ONLY — skip if mode=default)**

Before applying, the dev answers 3 questions (single block, wait for response):

```
🛡️  Iteration check (mode: --dev) — [spec] v[current] → v[next]

1️⃣  Origen: ¿esta iteración nace de un requisito nuevo del negocio, o de algo
   descubierto durante la implementación? (Si es lo segundo, ¿no debería ser
   un fix en vez de una iteración?)

2️⃣  Impacto en lo implementado: [if any modified FR is already Implemented/Verified]
   FR-XX ya está implementado. ¿Qué pasa con el código existente que dependía
   del comportamiento anterior?
   [if nothing implemented is touched: auto-pass, state it]

3️⃣  ACs afectados: ¿los ACs de los FRs modificados siguen siendo válidos o
   hay que reescribirlos? Lista cuáles cambian.
```

Validation (same spirit as exe-spec gates):
- Answer 1: "porque sí" / "el cliente lo pidió" without naming the requirement → push back once for the concrete driver.
- Answer 2: vague ("no pasa nada") when implemented FRs ARE modified → push back with the specific FR and ask for the concrete compatibility story (migration, deprecation, both behaviors, etc.).
- Answer 3: must name specific ACs or explicitly state "ninguno cambia" with a reason.
- Up to 2 reformulations per question, then explicit `override iteration gate` — logged in History and progress.

Record a condensed `Justification:` line inside the Delta section (step 4) with the three answers.

**3. Ask questions if ambiguous** (in user's language)
Same categories as jr-build-spec (🙋 client, 🛠️ dev). Only if needed for verifiable ACs.

**4. Apply iteration (surgical edits)**

> ⚠️ Mandatory. Apply edits without asking. Skill does not finish until the file is updated on disk.

Edit ONLY the touched sections (per Scope discipline — do not rewrite the whole spec):
- Header: update Version, Date, set `Status: Draft` (even if was Implemented/Verified)
- Modified FRs: append `> 🔄 Modified in v[X.X]: [one-line]`
- New FRs: next available number + `> ✨ New in v[X.X]`
- Removed FRs: move to Out of Scope with `> ~~FR-XX removed in v[X.X]: [reason]~~`
- Modified Technical Design subsections: prepend `> 🔄 Updated in v[X.X]`
- Add Delta section before History:
  ```
  ## Delta v[X.X]
  ### What changes from v[previous]: [bullet list]
  ### What does NOT change: [bullet list]
  ### Regression risk: [files affected or "Low — no impact on existing code"]
  ```
- History: add `| [new version] | date | Iterated | jr-iterate-spec — [one-line] |`

**5. Confirm + log progress**
Respond in user's language: delta summary, next steps (`/jr-exe-spec`, `/jr-verify-spec`).

Append entry to `docs/progress.md` (create with header if missing). Use today's date:
```
## YYYY-MM-DD — jr-iterate-spec[--dev] — [spec slug]
Iterated to v[X.X]. Delta: [one-line summary]. Status: Draft. [Justified: origin one-line, if dev]
```
