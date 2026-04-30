---
name: jr-vision
description: Use when the user runs /jr-vision or has a raw product idea to develop from scratch. Triggers: "I have an idea", "new project", "I want to build", "startup idea", /jr-vision.
---

# jr-vision

Transform a raw idea into a structured product vision document. First step of the project kickoff flow.

**Flow:** `[jr-vision] → jr-arch → jr-roadmap → jr-build-spec → jr-exe-spec → jr-verify-spec`

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md if it exists → write docs/ files in Docs language. If not set, use conversation language.
- Accept input as text in chat or attached .md file.
- If no input provided, ask for it in user's language.
- Don't ask about things already implicit in the idea.

## Steps

**0. Read input**
Extract from what the user shared: what they want to build, for whom, what problem it solves, mentioned scope, mentioned technologies.

**1. Ask only necessary questions** (in user's language)
Categories: 🎯 Product & problem · 👥 Users · 📐 Scope · 💼 Business (only if relevant for tech decisions). Accept partial answers. Undefined items → `[To be defined]`.

**2. Build docs/vision.md**

> ⚠️ Mandatory. Create docs/ if needed. Write without asking. Skill does not finish until file exists on disk.

Sections:
```
# Product Vision — [Name]
Status: Draft | Version: 1.0 | Date | Author: jr-vision

1. One-line summary (product / what / who / problem / differentiator)
2. The problem (current situation, why real, who experiences it)
3. The solution (what it does, what it does NOT do, why this approach)
4. Users (primary: profile, context, goal, frustrations; secondary if any)
5. Value proposition (2-3 plain sentences + key benefits)
6. Scope (MVP essentials | Phase 2 extensions | Out of scope)
7. Business context (model, monetization, known constraints)
8. Success metrics (concrete, measurable)
9. Risks and assumptions (table: assumption | risk if false | validation priority)
10. Pending questions (remove if none)
History table
```

**3. Confirm**
Respond in user's language. Indicate next step: `/jr-arch`.

## Special cases
- Too vague → build with what's available, mark liberally with `[To be defined]`.
- Too large → propose a smaller MVP explicitly. Respect user's decision.
- Already clear → skip questions, build directly.
- Internal project → adapt "users" to "teams/systems", "business model" to "organizational value".
