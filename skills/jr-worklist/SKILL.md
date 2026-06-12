---
name: jr-worklist
description: Use when the user runs /jr-worklist or provides a QA document, feedback list, punch list, or any multi-item list of fixes/improvements to work through point by point. Orchestrates item-by-item execution with a strict one-at-a-time gate. Triggers: "QA document", "feedback list", "punch list", "work through these points", "lista de QA", /jr-worklist.
---

# jr-worklist

Turn a QA document (or any multi-item feedback list) into a tracked worklist and work through it **one item at a time**. No item is started until the previous one is resolved or explicitly blocked. Items are routed to the right flow (patch-style inline, fix-style diagnosis, or full spec) based on their nature.

Built for the reality of QA reports: items are heterogeneous (typos next to bugs next to hidden feature requests), often vaguely written by non-technical reporters, and the dev frequently already knows the root cause.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → Stack, Conventions, Docs language, **Mode**.
- Mode resolution: `--dev`/`--no-dev` flag > PROJECT.md `Mode:` > `default`.
- Worklists live in `specs/worklists/[slug].md`. Write in Docs language.
- **One item in progress at a time. This is the core invariant — never violate it.**
- An item is only ✅ Resolved when the user confirms verification — never when code merely changed.

## Subcommands

| Invocation | Action |
|---|---|
| `/jr-worklist @doc.pdf` (or .md, or pasted text) | Ingest: parse document → create worklist |
| `/jr-worklist next` | Start (or resume) the next item |
| `/jr-worklist status` | Show progress table |
| `/jr-worklist @specs/worklists/x.md next` | Operate on a specific worklist when several exist |

If invoked with a document while a worklist already exists for it → offer to update (merge new items) instead of duplicating.

## Steps — Ingestion

**1. Parse the document**
Extract individual actionable items. Each item gets: number, short title, the **verbatim quote** from the source document (this travels with the item forever — it's the acceptance criterion), and severity (from the doc if present, estimated otherwise: 🔴 high / 🟡 med / 🟢 low).

**2. Classify route per item**
Reuse jr-patch's risk-classification logic to suggest a route:
- `patch` — cosmetic, copy, typo, trivial config (would pass jr-patch's classifier)
- `fix` — a bug: something built that doesn't work as intended
- `spec` — a feature request disguised as a QA point ("add price filter") → flag with ⚠️, will suggest `/jr-build-spec` when its turn comes

In `Mode: dev`, classify more conservatively (more items route to fix/spec, fewer to patch).

**3. Propose attack order**
Default: by severity (high → low), preserving document order within the same severity. Offer alternatives: document order, or user reorders manually. Wait for choice.

**4. Save worklist**

> ⚠️ Mandatory. Create `specs/worklists/` if needed. Write without asking.

```markdown
# Worklist: [name]
Source: [document name] | Created: YYYY-MM-DD | Status: In progress
Progress: 0/N resolved | Mode: [default|dev]

| # | Item | Sev | Route | Status |
|---|------|-----|-------|--------|
| 1 | [title] | 🔴 | fix | ⏳ Pending |
...

## Items detail

### #1 — [title]
> [verbatim quote from source document]
Severity: high | Route: fix | Status: ⏳ Pending
```

Confirm to user: item count, route summary (X patch / Y fix / Z spec), chosen order, path. Log one entry to `docs/progress.md`:
```
## YYYY-MM-DD — jr-worklist — [slug]
Worklist created from [doc]: N items (X patch / Y fix / Z spec).
```

## Steps — Working an item (`next`)

**0. Enforce the gate**
- If an item is 🔄 In progress → REFUSE to start another:
```
⛔ El item #N sigue 🔄 In progress. Un punto a la vez.
  a) Retomarlo → te muestro dónde quedó
  b) Marcarlo 🚫 Blocked si no depende de ti → "blocked: [razón]"
  c) Si ya lo verificaste → "verificado"
```
- If resuming an in-progress item → show its saved "last progress" note and continue from there.
- Otherwise → take the next ⏳ Pending in order, mark it 🔄 In progress in the worklist file.

**1. Show the active-item header**
Always when starting or resuming an item (not on every message within it):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 WORKING ON — [worklist slug] · item N de M
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  #N · [title]                        [sev] · ruta: [route]

  📄 Del documento QA:
  "[verbatim quote]"

  [⚠️ Reporte con poco detalle — no especifica X, Y. — only if vague]

  📊 Progreso: ✅ a · 🔄 1 · ⏳ b · 🚫 c
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**2. Dev context checkpoint (ALWAYS, weight varies)**
Before any exploration or diagnosis, ask the dev for prior knowledge:

- If the report is **vague** (no page, no steps, no expected behavior) → prominent version:
```
Antes de explorar, ¿tienes contexto que acelere esto?
  a) Ya sé la causa raíz → dímela y voy directo
  b) Tengo pistas (página, componente, sospecha) → acoto la búsqueda
  c) No tengo nada → exploro desde cero
```
- If the report is **detailed** → one-liner: `¿Contexto previo sobre este punto, o exploro? (causa / pista / explorar)`

Handling the answers:
- **(a) Root cause given** → verify the hypothesis surgically (read the specific file/area — do NOT apply blindly). If confirmed: proceed directly to fix. If not confirmed: say so honestly ("Revisé X y la causa parece ser otra") and ask for another pista or fall back to exploration.
- **(b) Hints given** → restrict the search to the hinted area (specific templates, recent git history of that zone). Do not scan the whole project.
- **(c) Nothing** → explore from scratch, surgically (grep for relevant strings/components first, read files only as needed).

Record whatever the dev provided in the item's detail section as `Dev context: [...]`.

**3. Execute according to route**
- `patch` route → inline fast flow: locate → show diff → confirm → apply. Same spirit as jr-patch (no spec, no plan). jr-patch's risk classifier still applies — if the item turns out to be bigger than classified, re-route and announce.
- `fix` route → compact diagnosis + correction: identify root cause (aided by dev context), propose fix, apply on confirmation. For small fixes the worklist item IS the record — do NOT create specs/fixes/ files. Only if the bug turns out deep/structural, suggest escalating to full `/jr-fix-spec`.
- `spec` route → do not implement directly. Tell the user this item is a feature: "¿Lanzo /jr-build-spec para este punto?" If they decline, they can mark it blocked or handle it outside.

**4. Verification gate (closing an item)**
After changes are applied:
```
✔ Cambios aplicados: [file list with one-line each]

🧪 Para verificar:
  1. [concrete step]
  2. [concrete step]

⏸️  El item #N queda EN VERIFICACIÓN.
   Confirma cuando lo hayas probado: "verificado" / "falló: [qué pasó]"
```
- "verificado" → mark ✅ Resolved in worklist, record what changed in the item detail, show progress + next in queue, append one line to `docs/progress.md`:
```
## YYYY-MM-DD — jr-worklist — [slug] #N
Resolved: [title]. [one-line what changed]. (N/M done)
```
- "falló: ..." → stay 🔄 In progress, treat the failure description as new dev context, iterate.

**5. Session continuity**
If the session is ending or the user switches away with an item in progress, save a `Last progress:` line inside the item detail (what was found, what remains). On resume, surface it.

## Blocked items
`blocked: [reason]` on the active item → mark 🚫 Blocked with the reason, free the gate (next can start). Blocked items are skippable but stay visible in status. Unblock with `unblock #N` (returns to ⏳ Pending, takes priority position).

## Status output (`status`)
```
📋 [slug] — X/M resueltos
━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ #1, #3, ...
  🔄 #2  [title] — in progress desde [date]
         Último avance: [last progress note]
  🚫 #5  [title] — blocked: [reason]
  ⏳ #6–#12 pendientes
━━━━━━━━━━━━━━━━━━━━━━━━
Siguiente acción: [resume #2 | /jr-worklist next | resolver bloqueos]
```
When all items resolved → mark worklist `Status: Completed`, congratulate briefly, log completion to progress.md.

## Mode interaction (`--dev`)
- Route classification is more conservative (jr-patch's dev thresholds apply).
- The dev-context checkpoint's root-cause path still verifies before applying (this is always true, but in dev mode never offer to skip verification).
- Items routed to `spec` cannot be downgraded to inline handling.

## Special cases
- **Document parse ambiguity** (items unclear, mixed prose): show the extracted item list before saving and ask user to confirm/adjust.
- **Item turns out to be multiple issues** once explored: offer to split it into sub-items (#7a, #7b) in the worklist.
- **Duplicate items** in the doc: merge, note both quotes.
- **User wants to jump to a specific item** ("vamos al #8"): allowed ONLY if nothing is in progress. The gate is about not abandoning work, not about rigid order.
- **Multiple active worklists**: require explicit worklist reference in invocation; status without reference lists all worklists with their progress.
- **No PROJECT.md**: works, but warn mode defaults to `default` and suggest `/jr-init`.

## Principles
- The worklist IS the record for small items — no per-item file bureaucracy. That's the point.
- The verbatim QA quote is the acceptance criterion. Resolution means the reporter's words are satisfied, not the dev's interpretation.
- The dev's prior knowledge is the cheapest diagnostic tool available. Ask first, explore second. But verify — trust and check.
- One at a time is a feature, not a limitation. Half-finished items are how QA rounds drag for weeks.
