---
name: jr-arch
description: >
  Use this skill whenever the user runs /jr-arch or wants to define the technical architecture of a new project. Triggered by phrases like "define architecture", "what stack to use", "how to structure the project", "system technical design", "project architecture", or when /jr-arch is mentioned. Reads the vision document (docs/vision.md) as a base, asks necessary technical questions, and produces a complete architecture document: recommended stack with justification, module structure, initial data model, fundamental technical decisions, and updates PROJECT.md. It is the second step of the project kickoff flow — after jr-vision and before jr-roadmap.

language_behavior: >
  All internal instructions are in English for consistency.
  Always respond to the user in the same language they used to invoke this skill.
  Read PROJECT.md at the start — write all generated files in the "Docs language" defined there.
  If not set, use the user's conversation language for generated files.
---

# jr-arch

Second skill in the project kickoff flow. With a clear product vision, defines the technical architecture: stack, structure, modules, initial data model, and fundamental decisions that will guide all development.

**Position in the flow:**
```
jr-vision → [jr-arch] → jr-roadmap → jr-build-spec → jr-exe-spec → jr-verify-spec
```

---

## Step 0 — Validate input

```
/jr-arch
```

No arguments required. Automatically looks for `docs/vision.md`.

If `docs/vision.md` doesn't exist, respond in the user's language:
> [Tell them to run /jr-vision first, or share the file manually with /jr-arch @docs/vision.md]

Also read `PROJECT.md` if it exists to get the Docs language and any existing context.

---

## Step 1 — Analyze vision and context

Based on `docs/vision.md`:

1. Identify the **type of system**: web app, API, mobile, CLI, hybrid, etc.
2. Identify **load and usage patterns**: many concurrent users? heavy operations? real-time?
3. Identify **external integrations** mentioned in the vision
4. Identify **technical constraints** if any (budget, team, known technologies)
5. Scan the current project: is there existing code? `package.json`? any stack already started?

---

## Step 2 — Technical questions

Ask only what's needed to make well-founded architecture decisions. Communicate in the user's language:

### 🛠️ Stack and team
```
**T1.** [Question about technologies the team is proficient in]
**T2.** [Question about stack preferences if not clear from vision]
```

### 🏗️ Infrastructure and scale
```
**I1.** [Question about deployment: cloud, self-hosted, serverless]
**I2.** [Question about expected initial scale]
```

### 🔗 Integrations
```
**X1.** [Question about critical external integrations not mentioned]
```

### 🔐 Security and compliance
```
**S1.** [Question about authentication, roles, sensitive data if applicable]
```

Only ask what you genuinely need to make decisions.

---

## Step 3 — Define and justify the stack

For each technology decision, justify **why** — not just what. The reasoning is as important as the choice.

Evaluate and decide on:
- **Frontend:** framework, language, styles
- **Backend:** framework, language, pattern (REST, GraphQL, etc.)
- **Database:** type (relational, document, etc.) and engine
- **Authentication:** strategy and tool
- **Infrastructure:** hosting, CI/CD, containers
- **Build tools:** bundler, transpiler, etc.
- **Testing:** strategy and frameworks

---

## Step 4 — Build the architecture document

Write in the **Docs language** from PROJECT.md.

```markdown
# System Architecture — [Project Name]

**Status:** Draft
**Version:** 1.0
**Date:** YYYY-MM-DD
**Author:** jr-arch
**Based on:** docs/vision.md

---

## 1. Executive summary
[2-3 sentences describing the system type and main architectural decisions]

## 2. System type
**Category:** [Web app / API / Mobile / CLI / Hybrid / etc.]
**Pattern:** [Monolith / Monorepo / Microservices / Serverless / etc.]
**Justification:** [Why this pattern for this specific product]

## 3. Tech stack

### Frontend
| Decision | Technology | Justification |
|---|---|---|
| Framework | [React / Vue / Next.js / etc.] | [Why this and not another] |
| Language | [TypeScript / JavaScript] | [Why] |
| Styles | [Tailwind / Sass / etc.] | [Why] |
| Build tool | [Vite / Webpack / etc.] | [Why] |
| State management | [Zustand / Pinia / etc. or "Not needed"] | [Why] |

### Backend
| Decision | Technology | Justification |
|---|---|---|
| Framework | [Node/Express / Laravel / etc.] | [Why] |
| Language | [TypeScript / PHP / etc.] | [Why] |
| API style | [REST / GraphQL / tRPC] | [Why] |
| Auth | [JWT / Sessions / OAuth] | [Why] |

### Database
| Decision | Technology | Justification |
|---|---|---|
| Engine | [PostgreSQL / MySQL / MongoDB / etc.] | [Why] |
| ORM / Query builder | [Prisma / Eloquent / etc.] | [Why] |
| Migrations | [Strategy] | [Why] |

### Infrastructure
| Decision | Technology | Justification |
|---|---|---|
| Hosting | [Vercel / Railway / AWS / etc.] | [Why] |
| Containers | [Docker / Not applicable] | [Why] |
| CI/CD | [GitHub Actions / etc.] | [Why] |

### Testing
| Level | Tool | Scope |
|---|---|---|
| Unit | [Jest / Vitest / PHPUnit] | [What's tested] |
| Integration | [Supertest / etc.] | [What's tested] |
| E2E | [Cypress / Playwright / "Phase 2"] | [What's tested] |

---

## 4. System architecture

### High-level diagram
```
[Text/ASCII representation of the system]
```

### Main modules
| Module | Responsibility | Technology |
|---|---|---|
| [Name] | [What this module does] | [Specific stack] |

### Main data flow
[Description of the most important flow: how a request comes in, what happens, how the response goes out]

---

## 5. Directory structure

```
project/
├── [directory]/          # [purpose]
│   ├── [subdirectory]/   # [purpose]
│   └── [subdirectory]/   # [purpose]
├── docs/                 # Vision, architecture, decisions
├── specs/                # Toolkit specs
│   └── fixes/
└── [config files]
```

---

## 6. Initial data model

> Only the main MVP entities. Do not model what won't be built.

### Entity: [Name]
| Field | Type | Description | Constraints |
|---|---|---|---|
| id | UUID / INT | Unique identifier | PK, auto |
| [field] | [type] | [description] | [constraints] |

### Relationships
- `[Entity A]` has many `[Entity B]`
- `[Entity B]` belongs to `[Entity A]`

---

## 7. Fundamental technical decisions

> Decisions that should not be reversed without serious discussion.

### TD-01: [Decision name]
**Decision:** [What was decided]
**Context:** [Why it was a necessary decision]
**Alternatives considered:** [What else was evaluated]
**Justification:** [Why this option and not the others]
**Consequences:** [What this decision implies for the future]

---

## 8. Project conventions

### Naming
- **Files:** [kebab-case / PascalCase by type]
- **Functions/methods:** [camelCase / snake_case]
- **Classes:** [PascalCase]
- **Environment variables:** [UPPER_SNAKE_CASE]
- **Git branches:** [feature/xxx, fix/xxx, hotfix/xxx]

### Commits
[Conventional commits / Free format / etc.]
```
feat: new feature
fix: bug fix
docs: documentation
chore: maintenance
```

---

## 9. Security

- **Authentication:** [Strategy and tool]
- **Authorization:** [Roles and permissions — how they're modeled]
- **Sensitive data:** [How handled, where stored]
- **Environment variables:** [`.env` local, secrets in production via X]

---

## 10. Known technical debt from the start

> Decisions made for MVP speed that will need to be revisited.

- **[Area]:** [What's being simplified and why] → Revisit in Phase [X]

---

## 11. Pending questions
*(Remove if none)*
- **[To be defined]:** [Technical decision that still has no answer]

---
## History

| Version | Date | Action |
|---|---|---|
| 1.0 | YYYY-MM-DD | Created by jr-arch |
```

---

## Step 5 — Update PROJECT.md

> ⚠️ **Mandatory. Execute without asking.**

If `PROJECT.md` exists, update it with the defined stack and architecture.
If it doesn't exist, create it using the architecture document as a base — follow the `jr-init` template structure.

---

## Step 6 — Save and confirm

> ⚠️ **Mandatory. Do not ask — execute directly.**

1. Create `docs/` if it doesn't exist.
2. Save to `docs/architecture.md`.
3. Confirm to the user in their conversation language, summarizing the stack and indicating the next step: `/jr-roadmap`.

---

## Principles

- **Justify everything**: a decision without reasoning is a future trap.
- **MVP first**: don't architect for scale that doesn't exist yet. Premature scaling is the enemy.
- **Honest about trade-offs**: every decision has costs. Documenting them prevents surprises.
- **Don't reinvent**: if there's a standard solution for the problem, use it.
- **Conscious technical debt is fine**: what kills projects is unconscious debt.
