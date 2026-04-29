---
name: jr-build-spec
description: >
  Use this skill whenever the user runs /jr-build-spec or provides a .md file with a rough specification, user story, or unpolished requirement that needs to be analyzed, refined, and documented as a professional spec. Triggered by phrases like "build spec", "refine requirement", "analyze user story", "create technical specification", or when /jr-build-spec is mentioned. Requires a .md file as input; if not provided, must request it. The skill analyzes the project context, detects overlaps with existing specs, categorizes questions for client and dev, warns if scope is too large, accepts iterative answers, and produces a professional spec in the specs/ directory.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Read PROJECT.md at the start — write all generated files (specs) in the "Docs language" defined there.
  If not set, use the user's conversation language for generated files.
---

# jr-build-spec

Skill to transform rough requirements or unpolished user stories into professional technical specifications, ready to be worked on by a development team.

---

## Step 0 — Validate input

If the user ran `/jr-build-spec` **without attaching a `.md` file**, respond in their language:
> [Ask them to share the requirement file: `/jr-build-spec @path/to/file.md`]

Also read `PROJECT.md` at the start to understand the project context and get the Docs language.

---

## Step 1 — Read, understand, and scan context

1. Read the received `.md` file completely.
2. Read `PROJECT.md` for stack, architecture, and conventions.
3. Scan the project to understand context:
   - Does `specs/` exist?
   - Config files for stack identification
   - Existing specs for conventions
4. Formulate initial analysis: What is being asked? What is clear? What is ambiguous?

---

## Step 2 — Detect overlaps with existing specs

If `specs/` exists, read all existing specs (at least their Executive Summary and Functional Requirements sections).

Evaluate:
- Are there specs covering **the same or very similar** functionality?
- Are there specs this requirement **extends or modifies**?
- Are there specs this requirement **could break or contradict**?
- Are there specs that should run **before** this one (dependencies)?

If anything relevant is found, report it to the user in their language before proceeding:

```
[Table of related specs found with their relationship and impact]
[Ask: continue as a new spec or integrate into an existing one?]
```

Wait for user decision before continuing.

---

## Step 3 — Scope evaluation

Before formulating questions, evaluate the magnitude of the requirement:

**Signs of excessive scope:**
- Mentions more than 3 different system modules
- Involves DB changes + API + UI + external integrations simultaneously
- The requirement has multiple implicit "phases" or "stages"
- Would require more than ~5 days of work for one dev

If excessive scope is detected, warn the user in their language and ask whether to split it or continue as a single spec.

---

## Step 4 — Categorize and formulate questions

Based on the analysis, generate **two question lists**. Communicate in the user's language:

#### 🙋 Questions for the Client / Product Owner
Business doubts: scope, priorities, expected behavior, end users, commercial constraints.

```
**C1.** [Concrete business-focused question]
**C2.** [Concrete business-focused question]
```

#### 🛠️ Questions for the Dev / Architect
Technical doubts: integrations, dependencies, system limitations, design decisions.

```
**D1.** [Concrete technical question]
**D2.** [Concrete technical question]
```

Indicate that not all questions need to be answered at once.

---

## Step 5 — Iteration

- Accept partial answers.
- Mark resolved questions internally.
- If enough information exists to build the spec, ask whether to proceed with unresolved items as `[PENDING]`.

---

## Step 6 — Build the spec

Write the spec in the **Docs language** from PROJECT.md.

```markdown
# [Feature / Requirement Name]

**Status:** Draft
**Version:** 1.0
**Date:** YYYY-MM-DD
**Author:** jr-build-spec
**Related specs:** [related specs detected in Step 2, or "None"]
**Scope warning:** [if applicable, or remove this line]

---

## 1. Executive Summary
2-3 sentences: what it is, why it matters, what the expected outcome is.

## 2. Context and Motivation
- Problem it solves
- Affected user(s)
- Business impact

## 3. Goals
- [ ] Goal 1
- [ ] Goal 2

## 4. Out of Scope
- What this spec explicitly does NOT include

## 5. Functional Requirements

### FR-01: [Name]
**Description:** ...
**Acceptance Criteria:**
- [ ] AC-01: ...
- [ ] AC-02: ...

### FR-02: [Name]
...

## 6. Non-Functional Requirements
- **Performance:** ...
- **Security:** ...
- **Scalability:** ...
- **Compatibility:** ...

## 7. Technical Design

### Architecture
[How it fits into the current system]

### Involved Components
| Component | Role | Required changes |
|---|---|---|
| ... | ... | ... |

### Data Flow
[Main flow description or pseudocode if applicable]

### Database Considerations
[Schema changes, new tables, indexes. If not applicable: "No DB changes"]

### APIs / Integrations
[New or modified endpoints, contracts, payloads. If not applicable: "No API changes"]

## 8. Edge Cases and Error Handling
- **Case:** [description] → **Expected behavior:** [response]

## 9. Dependencies
- **Specs that must run first:** [list or "None"]
- **Internal:** [other modules, services]
- **External:** [libraries, third-party APIs]
- **Blockers:** [what must be ready before starting]

## 10. Pending Questions
> Must be resolved before starting development.

- **[PENDING-C1]:** [unresolved client question]
- **[PENDING-D1]:** [unresolved technical question]

*(Remove this section if no pending items)*

## 11. Additional Notes
[Extra context, references, relevant links]

---
## History

| Version | Date | Action | Notes |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | Created | Generated by jr-build-spec |
```

**Writing principles:**
- Precise technical language, no redundancies.
- Undefined items go as `[TBD]` or `[PENDING]`.
- Each FR must have at least one verifiable and testable AC.
- The spec must be readable by a new dev without prior context.

---

## Step 7 — Save the spec

> ⚠️ **Mandatory and non-negotiable. The skill does NOT finish until the file exists on disk. Execute without asking — do not request confirmation.**

1. **Create `specs/`** in the project root if it doesn't exist.
2. **Determine the filename:** `specs/[feature-slug].md`
   - kebab-case, lowercase, no accents or special characters.
3. **Write the file.** If it already exists, overwrite without asking.
4. **Verify** the file was created correctly.
5. **Confirm to the user** in their conversation language, indicating the next steps: `/jr-exe-spec` and `/jr-verify-spec`.

**If the file cannot be written** (permissions, invalid path), report the exact error and show the spec content in chat so the user can save it manually.

---

## Quality principles

- **Clarity over brevity**: better long and complete than short and ambiguous.
- **Verifiability**: every requirement must be testable.
- **Traceability**: connect decisions with their motivation, and specs with each other.
- **Honesty**: unclear items are marked as pending, never invented.
- **Scope-conscious**: a well-scoped spec is better than one that tries to do everything.
- **Context-aware**: the spec reflects the project's stack and conventions.
