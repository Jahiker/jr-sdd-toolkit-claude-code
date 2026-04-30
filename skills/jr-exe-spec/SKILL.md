---
name: jr-exe-spec
description: Use when the user runs /jr-exe-spec or provides an approved spec to implement. Triggers: "execute spec", "implement spec", "apply spec", "run spec", /jr-exe-spec. Stack: JS, TS, PHP, React, Next.js, TanStack, Vue, Node.js, Laravel, WordPress, Shopify, CSS, Sass, Tailwind, Webpack, Vite, Docker.
---

# jr-exe-spec

Implement an approved spec: build execution plan → wait for approval → execute with full traceability → update spec lifecycle.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start → Stack, Architecture, Conventions are already summarized there. Only load `references/stack-patterns.md` if you need specific code patterns for the detected stack (lazy load — not always).
- If no spec file provided, ask in user's language.
- Never execute anything before explicit user approval.

## Steps

**0. Validate spec**
- No file → ask for it.
- `Status: Implemented` → warn user, ask if re-implementing or new iteration.
- Critical `[PENDING]`/`[TBD]` in FRs or Technical Design → stop, list them, ask how to proceed.
- Dependencies not yet `Implemented` → warn user, ask to confirm proceeding.

**1. Scan project**
Using Toolkit Context from PROJECT.md as base. Verify files mentioned in spec: do they exist? What state?

**2. Build execution plan** (present in user's language)
```
📋 Execution Plan — [Feature]
Detected stack: [from Toolkit Context]
Files to create: X | Modify: Y | Dependencies: Z

PHASE 1: [name — e.g. Types & interfaces]
  - [ ] 1.1 [action] → `path/file.ext` [CREATE/MODIFY]

PHASE 2: [name — e.g. Business logic]
  - [ ] 2.1 [action] → `path/file.ext` [CREATE]

PHASE N: Dependencies (if any)
  - [ ] N.1 Install: `[cmd] [package@version]`

PHASE N+1: Manual verification
  - [ ] [what to check]

Approve? Reply "yes" to execute, or tell me what to adjust.
```

Phase order: types/interfaces → models/schemas → services → UI/controllers/routes → styles → config/env.

**3. Wait for approval.** Modify and re-present if adjustments requested.

**4. Execute phase by phase**
Per item:
1. Announce in user's language: `▶ 1.1 Creating \`path/file.ts\`...`
2. Write the code following project conventions from Toolkit Context.
3. Add traceability in created files or introduced blocks only:
   `// spec: specs/feature-name.md` (adapt comment style to language)
4. Confirm: `✓ 1.1 Done`

On unexpected conflict → pause, report options, wait for decision.

`.env`/secrets → create `.env.example` with empty keys only, never real values.

Load `references/stack-patterns.md` only if needing specific patterns not clear from Toolkit Context.

**5. Update spec + report**

Update `specs/[name].md`:
- `Status: Draft` → `Status: Implemented`
- Add `## Affected Files` table (file | action | description) before History
- Add History entry: `| [v] | date | Implemented | jr-exe-spec — [one-line] |`

Report to user in their language:
- Affected files table
- Dependencies installed
- How to verify (concrete steps)
- Decisions made during execution
- Next step: `/jr-verify-spec @specs/[name].md`
