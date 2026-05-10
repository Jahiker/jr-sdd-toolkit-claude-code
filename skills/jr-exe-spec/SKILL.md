---
name: jr-exe-spec
description: Use when the user runs /jr-exe-spec or provides an approved spec to implement. Accepts --dev / --no-dev flag for strict pre-execution gates. Triggers: "execute spec", "implement spec", "apply spec", "run spec", /jr-exe-spec. Stack: JS, TS, PHP, React, Next.js, TanStack, Vue, Node.js, Laravel, WordPress, Shopify, CSS, Sass, Tailwind, Webpack, Vite, Docker.
---

# jr-exe-spec

Implement an approved spec: build execution plan → wait for approval → execute with full traceability → update spec lifecycle. In `--dev` mode, applies 3 pre-execution gates (files-to-touch, risk, rollback) before showing the plan.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → Stack, Architecture, Conventions, Docs language, **Mode**.
- Mode resolution (in order): `--dev`/`--no-dev` flag in invocation > `**Mode:**` in PROJECT.md > `default` if neither.
- Only load `references/stack-patterns.md` if needed for specific code patterns (lazy load).
- If no spec file provided, ask in user's language.
- Never execute anything before explicit user approval.

## Mode-aware flow

| Mode | What changes |
|---|---|
| `default` | Standard: validate → scan → plan → approval → execute → update spec → log. |
| `dev` | Same flow, plus: (a) refuse to execute Sketch or Needs work specs, (b) ask 3 pre-plan gate questions and validate answers against spec/plan, (c) require explicit reconciliation of any critical discrepancy before showing the plan. |

## Steps

**0. Validate spec + parse mode**
- Parse `--dev`/`--no-dev` flag from invocation. Resolve effective mode.
- Announce mode to user.
- Spec validation:
  - No file → ask for it.
  - Spec is in `specs/sketches/` (Status: Sketch):
    - In `default` mode → warn user this is a Sketch, ask explicit confirmation before proceeding.
    - In `dev` mode → **refuse** with message: "Spec is a Sketch (score below 60). Iterate with `/jr-build-spec @specs/sketches/[slug].md --dev` first."
  - Spec has `Readiness: Needs work` flag (score 60–74):
    - In `default` mode → warn but allow.
    - In `dev` mode → **refuse**: "Spec has Needs work flag. Re-run `/jr-build-spec --dev` to improve score to ≥75 first, or invoke `/jr-exe-spec --no-dev` to bypass."
  - `Status: Implemented` → warn, ask if re-implementing or new iteration.
  - Critical `[PENDING]`/`[TBD]` in FRs or Technical Design → stop, list them, ask how to proceed.
  - Dependencies not yet `Implemented` → warn, ask to confirm proceeding.

**1. Scan project**
Using Toolkit Context as base. Verify files mentioned in spec exist and their state.

**2. Build internal execution plan** (in memory, not yet shown to user in `dev` mode)

Phase order: types/interfaces → models/schemas → services → UI/controllers/routes → styles → config/env.

The plan format (presented in step 4):
```
📋 Execution Plan — [Feature]
Detected stack: [from Toolkit Context]
Files to create: X | Modify: Y | Dependencies: Z

PHASE 1: [name]
  - [ ] 1.1 [action] → `path/file.ext` [CREATE/MODIFY]

PHASE 2: [name]
  - [ ] 2.1 [action] → `path/file.ext` [CREATE]

PHASE N: Dependencies (if any)
  - [ ] N.1 Install: `[cmd] [package@version]`

PHASE N+1: Manual verification
  - [ ] [what to check]
```

**3. Pre-execution gates (DEV MODE ONLY — skip if mode=default)**

Before showing the execution plan, ask the dev 3 questions in their language. Present them as a single block and wait for response. The dev's answers are compared against the spec content and the internal plan from step 2.

```
🛡️  Pre-execution check (mode: --dev)

Antes de mostrarte el plan de ejecución, necesito 3 cosas. 
Esto no es burocracia — es para asegurar que entendiste el spec antes de aprobarlo.

1️⃣  Files-to-touch check
   ¿Qué archivos esperas que se creen o modifiquen al implementar este spec?
   (Lista los que creas que se tocarán. Después comparo con mi plan.)

2️⃣  Risk check
   ¿Cuál crees que es la parte más riesgosa de esta implementación?
   (1–2 líneas concretas. Mínimo 10 palabras. "bugs", "errores", "complejo" 
   por sí solos no cuentan — necesito un riesgo específico.)

3️⃣  Rollback check
   Si esto falla en producción, ¿cómo lo revertirías?
   (Pasos concretos. "git revert" cuenta como respuesta solo si el spec no 
   toca DB / sesiones activas / datos persistentes.)

Responde las 3 cuando estés listo.
```

#### Validation of answers

After dev responds, evaluate each answer:

##### Gate 1 — Files-to-touch

Compare the dev's expected files against the internal plan. Categorize:
- **Match**: file appears in both lists.
- **Plan has, dev didn't list**: dev underestimated scope. Show as discrepancy.
- **Dev listed, plan doesn't**: dev expected work that the spec doesn't actually require. Either the spec is incomplete or the dev misread it. Show as discrepancy.

Critical discrepancy = ≥30% of files in plan not in dev's list, OR dev lists a file with major architectural impact (e.g. middleware, auth, db migrations) that's not in plan.

##### Gate 2 — Risk check

Reject if ANY of these:
- Less than 10 words.
- Contains only generic terms (`bugs`, `errores`, `errors`, `problemas`, `complejo`, `complex`, `difícil`, `hard`, `tricky`) without a concrete noun (specific component, file, behavior, race condition, data type, edge case).
- Tautological ("the risky part is the risky part").

If rejected, push back with example:
```
⚠️ Tu respuesta es muy general. Ejemplos de risk checks aceptables:
   - "Race condition entre token refresh y peticiones concurrentes a /api/me"
   - "Migración del schema de users romperá sesiones activas si no la corro en horario bajo"
   - "El cliente OAuth puede recibir el callback antes de que el state guarde en cookie"

Reformula tu respuesta con un riesgo específico.
```

Wait for new answer. Re-evaluate. Allow up to 2 reformulations before allowing user to override with explicit "ignore risk gate".

##### Gate 3 — Rollback check

Reject if ANY of these:
- Less than 5 words.
- Says only "git revert" / "rollback the commit" while the spec mentions: database migrations, schema changes, session/auth changes, persistent data, external service mutations, env var changes, deployments.
- Says "no se puede revertir" or equivalent (acceptable answer is honest, but should explain why and what compensating action exists).

If rejected with the "git revert insufficient" pattern, push back:
```
⚠️ Tu respuesta es insuficiente para este spec. Este spec toca [DB schema | sesiones | 
   datos persistentes | servicios externos]. "git revert" no es suficiente porque 
   [explicación específica].
   
   Necesito que pienses en:
   - ¿Cómo manejas los datos que ya migraron / se crearon con el schema nuevo?
   - ¿Qué pasa con las sesiones activas?
   - ¿Hay una migración inversa, un script de cleanup, un compensating event?
```

Wait for reformulation. Same up-to-2 reformulations + override pattern as gate 2.

#### Reconcile critical discrepancies

If any gate produces a critical discrepancy:
```
🚨 Discrepancia crítica detectada en Gate [N]

[descripción específica del gap]

Antes de continuar al plan de ejecución, necesito que reconcilies:
- ¿Es un gap en tu comprensión? → relee el spec, vuelve a responder.
- ¿Es un gap en el spec? → cancela esta ejecución, itera el spec con /jr-iterate-spec.
- ¿Es intencional y consciente? → di "intencional, continúa" y queda registrado.
```

Wait for explicit reconciliation. Log the resolution path in step 5's progress entry.

**4. Show execution plan + wait for approval**

Show the plan from step 2. In `dev` mode, prepend a summary of what was reconciled in step 3:

```
✅ Pre-execution gates passed (mode: --dev)
   Files-to-touch: aligned with plan
   Risk identified: [dev's risk verbatim, truncated to 1 line]
   Rollback strategy: [dev's rollback verbatim, truncated to 1 line]

📋 Execution Plan — [Feature]
[plan content]

Approve? Reply "yes" to execute, or tell me what to adjust.
```

In `default` mode, just show the plan as-is (no preamble).

**5. Wait for approval.** Modify and re-present if adjustments requested.

**6. Execute phase by phase**
Per item:
1. Announce in user's language: `▶ 1.1 Creating \`path/file.ts\`...`
2. Write code following project conventions from Toolkit Context.
3. Add traceability in created files / introduced blocks: `// spec: specs/feature-name.md` (adapt comment style).
4. Confirm: `✓ 1.1 Done`

On unexpected conflict → pause, report options, wait for decision.

`.env`/secrets → create `.env.example` with empty keys only, never real values.

Load `references/stack-patterns.md` only if specific patterns aren't clear from Toolkit Context.

**7. Update spec + log progress**

Update `specs/[name].md`:
- `Status: Draft` → `Status: Implemented`
- Add `## Affected Files` table (file | action | description) before History.
- Add History entry. In `dev` mode, include the gates summary:
  - default: `| [v] | date | Implemented | jr-exe-spec — [one-line] |`
  - dev: `| [v] | date | Implemented | jr-exe-spec --dev — Gates: ✓ files ✓ risk ✓ rollback. [one-line] |`

Report to user in their language:
- Affected files table
- Dependencies installed
- How to verify (concrete steps)
- Decisions made during execution
- Next step: `/jr-verify-spec @specs/[name].md`

Append entry to `docs/progress.md` (create with header if missing). Use today's date:

For default mode:
```
## YYYY-MM-DD — jr-exe-spec — [spec slug]
Implemented [main feature]. Files: [N created, M modified]. [Pending items if any]
```

For dev mode (include gates outcome + risk identified):
```
## YYYY-MM-DD — jr-exe-spec --dev — [spec slug]
Implemented [main feature]. Files: [N created, M modified]. Risk noted by dev: "[risk truncated]". Rollback: "[rollback truncated]". [Pending items if any]
```

## Special cases

- **Mode is `dev` but spec was built in `default` mode (no Readiness Report)**: don't refuse. Acknowledge: "Spec doesn't have a readiness report — it was built in default mode. Proceeding with --dev gates anyway. Consider /jr-build-spec --dev for new specs."
- **Dev hits the gates 2 times and still gives vague answers**: offer the override path: "You can bypass this gate with 'override risk gate' / 'override rollback gate'. The override + your last answer will be logged in the spec History and progress log."
- **Mode is `dev`, gates pass, but during execution something feels off (a file the dev didn't list now needs touching)**: pause and announce: "Gate 1 said files A, B, C. Now I need to also touch D because of [reason]. Confirm or abort?" — this is the "execution-time gate" for emergent changes.
- **User passes `--no-dev` to skip a Needs work spec**: allow but log the bypass clearly in History and progress: `bypass: --no-dev override on spec with score 67`.
