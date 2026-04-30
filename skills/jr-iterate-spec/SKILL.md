---
name: jr-iterate-spec
description: Use when the user runs /jr-iterate-spec or wants to iterate/extend/modify an existing spec. Triggers: "iterate spec", "add to spec", "modify spec", "new version of spec", "extend feature", /jr-iterate-spec. Does NOT create a new spec — versions the existing one.
---

# jr-iterate-spec

Version an existing spec with new changes. Semantic versioning: patch (1.0→1.1) for small changes, minor (1.0→2.0) for structural changes.

## Rules
- Respond to user in their conversation language.
- Read `## Toolkit Context` from PROJECT.md at start.
- Requires TWO inputs: existing spec (@specs/name.md) + change description (text or .md). Ask if either missing.
- Preserve the existing spec's language — do not change it.
- Overwrite the existing spec file — preserve all history.

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

**3. Ask questions if ambiguous** (in user's language)
Same categories as jr-build-spec (🙋 client, 🛠️ dev). Only if needed for verifiable ACs.

**4. Build iterated spec**

> ⚠️ Mandatory. Overwrite existing file without asking. Skill does not finish until file is written.

Apply to the complete spec:
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

**5. Confirm**
Respond in user's language: delta summary, next steps (`/jr-exe-spec`, `/jr-verify-spec`).
