---
name: jr-vision
description: >
  Use this skill whenever the user runs /jr-vision or has a product idea they want to develop from scratch. Triggered by phrases like "I have an idea", "I want to build a product", "new project", "I want to create an app", "business idea", "startup idea", or when /jr-vision is mentioned. Receives a free-form description of the idea (can be a paragraph, unordered notes, or a .md file), asks clarifying questions about vision, users, real problem and scope, and produces a professionally structured product vision document. It is the mandatory first step for new projects — without a clear vision, architecture and roadmap cannot be defined.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Read PROJECT.md at the start — if "Docs language" is set, write all generated files in that language.
  If PROJECT.md does not exist or has no Docs language set, use the user's conversation language for generated files.
---

# jr-vision

First skill in the project kickoff flow. Transforms a raw idea into a clear, honest, and actionable vision document that serves as the foundation for all subsequent technical and product decisions.

**Position in the flow:**
```
idea → [jr-vision] → jr-arch → jr-roadmap → jr-build-spec → jr-exe-spec → jr-verify-spec
```

---

## Step 0 — Validate input

The user can invoke this skill in two ways:

**With a file:**
```
/jr-vision @docs/my-idea.md
```

**With a direct description in chat:**
```
/jr-vision
I want to build an app that helps freelancers manage their clients and invoices
```

If there is no input at all, ask in the user's language:
> [Ask them to share their idea — it can be a paragraph, unorganized notes, or a .md file. It doesn't need to be polished.]

---

## Step 1 — Read and analyze the initial idea

Read what the user shared and extract:
- **What they want to build** (the product)
- **For whom** (explicitly or implicitly mentioned users)
- **What problem it solves** (or if it's still unclear)
- **What they mentioned about scope** (big, small, MVP, etc.)
- **What technologies they mentioned** (if any)

Do an internal analysis before asking — don't ask about things already implicit in the idea.

---

## Step 2 — Clarifying questions

Ask **only the questions needed** to complete the vision. Categorize them and communicate in the user's language:

### 🎯 Product and problem
```
**P1.** [Question about the real problem it solves]
**P2.** [Question about what makes it different from existing solutions]
```

### 👥 Users
```
**U1.** [Question about who the primary user is]
**U2.** [Question about usage context if unclear]
```

### 📐 Scope
```
**S1.** [Question about MVP vs full vision]
**S2.** [Question about constraints: time, budget, team]
```

### 💼 Business (only if relevant for technical decisions)
```
**N1.** [Question about business model if it affects architecture]
```

Indicate that not everything needs to be answered at once.

---

## Step 3 — Iteration

- Accept partial answers.
- If questions remain unanswered but there's enough clarity to build the vision, ask whether to proceed.
- Undefined items get marked as `[To be defined]` in the document.

---

## Step 4 — Build the vision document

Write the document in the **Docs language** (from PROJECT.md, or the user's conversation language if not set).

```markdown
# Product Vision — [Project Name]

**Status:** Draft
**Date:** YYYY-MM-DD
**Author:** jr-vision

---

## 1. One-line summary
> [The product] is [what it does] for [who] that [problem it solves].
> Unlike [current alternative], [key differentiator].

## 2. The problem
**Current situation:** [How users solve this today — without the product]
**Why it's a real problem:** [Concrete impact of the problem]
**Who experiences it:** [Affected user profile]

## 3. The solution
**What the product does:** [Clear functional description, no jargon]
**What it does NOT do:** [Explicit scope limits]
**Why this solution:** [Why this approach and not another]

## 4. Users

### Primary user
**Profile:** [Description]
**Usage context:** [When, where, how frequently they use it]
**Primary goal:** [What they want to achieve]
**Current frustrations:** [With existing alternatives]

### Secondary user(s) (if applicable)
**Profile:** [Description]
**Relationship with the product:** [How they use it differently from the primary]

## 5. Value proposition
> [2-3 sentences anyone would understand, no technical jargon]

**Key benefits:**
- [Benefit 1 — measurable or perceptible]
- [Benefit 2]
- [Benefit 3]

## 6. Scope

### MVP — The minimum that delivers real value
- [Essential feature 1]
- [Essential feature 2]
- [Essential feature 3]

### Phase 2 — Natural extensions
- [Feature that expands MVP value]

### Out of scope (for now)
- [What is not built in any of these phases]
- [What is consciously discarded]

## 7. Business context

**Model:** [Freemium / SaaS / One-time / Open source / Internal / etc.]
**Monetization:** [How it generates economic value, or "Not applicable" if internal]
**Known constraints:** [Time, budget, team, regulations]

## 8. Success metrics
> How will we know the product works?

- [Metric 1: concrete and measurable]
- [Metric 2]

## 9. Risks and assumptions

| Assumption | Risk if false | Validation priority |
|---|---|---|
| [Users will do X] | [Consequence if they don't] | High / Medium / Low |
| [Technology Y allows Z] | [Technical consequence] | High / Medium / Low |

## 10. Pending questions
*(Remove if none)*
- **[To be defined]:** [Unresolved question that affects future decisions]

---
## History

| Version | Date | Action |
|---|---|---|
| 1.0 | YYYY-MM-DD | Created by jr-vision |
```

**Writing principles:**
- Clear language, no technical or startup jargon.
- Honest about what's undefined — `[To be defined]` is better than making things up.
- The MVP must be brutally minimal — if it seems small, it's probably the right size.
- The "Out of scope" section is as important as the scope itself — it prevents scope creep from day 1.

---

## Step 5 — Save the document

> ⚠️ **Mandatory. Do not ask — execute directly.**

1. Create `docs/` in the project root if it doesn't exist.
2. Save to `docs/vision.md`.
3. Confirm to the user in their conversation language, indicating the next step: `/jr-arch`.

---

## Special cases

**The idea is too vague to build anything:**
Don't block. Build the vision with what's available, mark abundantly with `[To be defined]`, and in pending questions explicitly list what must be resolved before moving to architecture.

**The idea is too large (full product vs MVP):**
Signal it clearly in the Scope section and be direct about what the proposed MVP is.

**The user already has full clarity and just wants the document:**
Skip the questions and build directly from the information provided.

**Internal project (not a user-facing product):**
Adapt sections: "users" becomes "teams or systems that use it", "business model" becomes "value for the organization".
