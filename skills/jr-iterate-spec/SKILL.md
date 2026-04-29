---
name: jr-iterate-spec
description: >
  Use this skill whenever the user runs /jr-iterate-spec or wants to iterate, extend, modify, or improve a spec that already exists (in any status: Draft, Implemented, or Verified). Triggered by phrases like "iterate the spec", "add to the spec", "modify the spec", "the spec needs a change", "new version of the spec", "extend the feature", or when /jr-iterate-spec is mentioned. Receives the existing spec as a base and the new requirement or change requested, evaluates impact on existing FRs and files, versions the spec semantically (patch for small improvements, minor for structural changes) and produces the iterated spec ready to execute with jr-exe-spec. Does NOT create a new spec — it versions the existing one.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Read PROJECT.md at the start — write all generated files in the "Docs language" defined there.
  If not set, use the user's conversation language for generated files.
  Preserve the language of the existing spec — do not change it during iteration.
---

# jr-iterate-spec

Skill to iterate on existing specs. Receives a documented base spec (in any status) and a new requirement or change, evaluates impact, versions semantically, and produces the updated spec with a clear delta of what changes from the previous version.

---

## Step 0 — Validate input

The user must provide **two things**:
1. The existing spec: `@specs/feature-name.md`
2. The new requirement or change (can be text in chat or a `.md` file)

If either is missing, request both in the user's language.

Also read `PROJECT.md` for context and Docs language.

---

## Step 1 — Read the base spec

1. Read the existing spec completely.
2. Record internally:
   - Current version (e.g.: `1.0`, `1.1`, `2.0`)
   - Current status (`Draft`, `Implemented`, `Verified`)
   - All existing FRs with their ACs
   - `Affected Files` section if it exists
   - Version history
3. If status is `Implemented` or `Verified`, note it — the delta must be careful not to break what's already implemented.

---

## Step 2 — Analyze the requested change

Read the new requirement and determine:

**Change type** (this defines versioning):

| Type | Examples | Version |
|---|---|---|
| **Patch** | Add AC to existing FR, clarify edge case, add NFR, small behavior extension | `1.0 → 1.1` |
| **Minor** | Add one or more new FRs, modify main flow, significant technical design change, new integrations, data model changes | `1.0 → 2.0` |

Announce the evaluation to the user in their language:

```
[Type: Patch / Minor]
[Current version → New version]
[FRs modified / added / removed]
[Already implemented files that would be affected]
[Ask: is the change type correct?]
```

Wait for confirmation before continuing.

---

## Step 3 — Conflict detection

Before building the iterated spec, evaluate:

- Does the change contradict any existing FR?
- Does the change modify already implemented behavior in a way that could break it?
- Does the change have dependencies on other specs that aren't implemented?
- Is the change so large it should be a new spec instead?

If conflicts or risks are detected, report them in the user's language before continuing.

---

## Step 4 — Formulate questions (only if ambiguities exist)

If the new requirement has ambiguities that prevent writing verifiable ACs, formulate categorized questions (client and dev) in the user's language, same as `jr-build-spec`.

---

## Step 5 — Build the iterated spec

Take the base spec and apply the changes. The resulting spec must be the **complete spec** (not just the delta), written in the original spec's language, with these modifications:

**In the header:**
```markdown
**Version:** [new version]
**Date:** YYYY-MM-DD
**Status:** Draft
```
> If the spec was `Implemented` or `Verified`, status returns to `Draft` because there are pending changes to execute.

**In FRs:**
- Unchanged FRs: kept identical.
- Modified FRs: add at the end of the FR: `> 🔄 Modified in v[X.X]: [one-line description of the change]`
- New FRs: add with next available number, with note: `> ✨ New in v[X.X]`
- Removed FRs: move to **Out of Scope** with note: `> ~~FR-XX removed in v[X.X]: [reason]~~`

**In Technical Design:**
Update only affected subsections. Add note at start of each modified subsection:
`> 🔄 Updated in v[X.X]`

**Add Delta section** (just before History):

```markdown
## Delta v[X.X] — Summary of changes

### What changes from v[previous version]
- [Change 1 in one line]
- [Change 2 in one line]

### What does NOT change
- [What stays the same and is relevant to clarify]

### Regression risk
- [Already implemented files that could be affected, or "Low — no impact on existing code"]
```

**In History:**
```markdown
| [new version] | YYYY-MM-DD | Iterated | jr-iterate-spec — [one-line change description] |
```

---

## Step 6 — Save the iterated spec

> ⚠️ **Mandatory and non-negotiable. Execute without asking.**

1. **Overwrite** the existing file `specs/feature-name.md` with the complete iterated spec.
2. **Verify** the file was written correctly.
3. **Confirm** to the user in their conversation language with: delta summary, next steps (`/jr-exe-spec`, `/jr-verify-spec`).

---

## Principles

- **The spec is the source of truth**: if something isn't in the spec, it doesn't exist. The delta must be explicit.
- **Don't break what works**: impact on already implemented code is always documented.
- **Version, don't rewrite**: the spec history is valuable — always preserve it.
- **Scope-conscious**: if the change is so large it undermines the original spec, a new spec with a dependency is better.
