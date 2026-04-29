---
name: jr-arch
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-arch o quiera definir la arquitectura técnica de un proyecto nuevo. Se activa con frases como "definir arquitectura", "qué stack usar", "cómo estructurar el proyecto", "diseño técnico del sistema", "arquitectura del proyecto", o cuando se mencione /jr-arch. Recibe el documento de visión (docs/vision.md) como base, hace preguntas técnicas necesarias, y produce un documento de arquitectura completo: stack recomendado con justificación, estructura de módulos, modelo de datos inicial, decisiones técnicas fundamentales, y actualiza PROJECT.md. Es el segundo paso del flujo de inicio de proyecto — después de jr-vision y antes de jr-roadmap.
---

# jr-arch

Segundo skill del flujo de inicio de proyecto. Con la visión del producto clara, define la arquitectura técnica del sistema: stack, estructura, módulos, modelo de datos inicial y decisiones fundamentales que guiarán todo el desarrollo.

**Posición en el flujo:**
```
jr-vision → [jr-arch] → jr-roadmap → jr-build-spec → jr-exe-spec → jr-verify-spec
```

---

## Paso 0 — Validar input

```
/jr-arch
```

No requiere argumentos. Busca automáticamente `docs/vision.md`.

Si no existe `docs/vision.md`:
> "No encontré el documento de visión del proyecto. Ejecuta primero `/jr-vision` para crearlo, o compártelo con `/jr-arch @docs/vision.md` si está en otra ubicación."

Si existe, léelo completo antes de continuar.

---

## Paso 1 — Analizar la visión y el contexto

Con base en `docs/vision.md`:

1. Identifica el **tipo de sistema**: web app, API, mobile, CLI, hybrid, etc.
2. Identifica **cargas y patrones de uso**: ¿muchos usuarios concurrentes? ¿operaciones pesadas? ¿tiempo real?
3. Identifica **integraciones externas** mencionadas en la visión
4. Identifica **restricciones técnicas** si las hay (presupuesto, equipo, tecnologías conocidas)
5. Escanea el proyecto actual: ¿ya hay código? ¿`package.json`? ¿algún stack iniciado?

---

## Paso 2 — Preguntas técnicas

Formula solo las preguntas necesarias para tomar decisiones de arquitectura bien fundadas:

### 🛠️ Stack y equipo
```
**T1.** [Pregunta sobre tecnologías que el equipo domina]
**T2.** [Pregunta sobre preferencias de stack si no están claras desde la visión]
```

### 🏗️ Infraestructura y escala
```
**I1.** [Pregunta sobre dónde se despliega: cloud, self-hosted, serverless]
**I2.** [Pregunta sobre escala esperada inicial]
```

### 🔗 Integraciones
```
**X1.** [Pregunta sobre integraciones externas críticas no mencionadas]
```

### 🔐 Seguridad y compliance
```
**S1.** [Pregunta sobre autenticación, roles, datos sensibles si aplica]
```

Solo pregunta lo que genuinamente necesitas para tomar decisiones. Si la visión ya lo deja claro, no preguntes.

---

## Paso 3 — Definir y justificar el stack

Para cada decisión tecnológica, justifica **por qué** — no solo enuncia qué. El razonamiento es tan importante como la elección.

Evalúa y decide sobre:
- **Frontend:** framework, lenguaje, estilos
- **Backend:** framework, lenguaje, patrón (REST, GraphQL, etc.)
- **Base de datos:** tipo (relacional, documento, etc.) y motor
- **Autenticación:** estrategia y herramienta
- **Infraestructura:** hosting, CI/CD, contenedores
- **Herramientas de build:** bundler, transpiler, etc.
- **Testing:** estrategia y frameworks

---

## Paso 4 — Construir el documento de arquitectura

```markdown
# Arquitectura del Sistema — [Nombre del Proyecto]

**Status:** Draft
**Versión:** 1.0
**Fecha:** YYYY-MM-DD
**Autor:** jr-arch
**Basado en:** docs/vision.md

---

## 1. Resumen ejecutivo
[2-3 oraciones describiendo el tipo de sistema y las decisiones arquitectónicas principales]

## 2. Tipo de sistema
**Categoría:** [Web app / API / Mobile / CLI / Hybrid / etc.]
**Patrón:** [Monolito / Monorepo / Microservicios / Serverless / etc.]
**Justificación:** [Por qué este patrón para este producto específico]

## 3. Stack tecnológico

### Frontend
| Decisión | Tecnología | Justificación |
|---|---|---|
| Framework | [React / Vue / Next.js / etc.] | [Por qué este y no otro] |
| Lenguaje | [TypeScript / JavaScript] | [Por qué] |
| Estilos | [Tailwind / Sass / etc.] | [Por qué] |
| Build tool | [Vite / Webpack / etc.] | [Por qué] |
| State management | [Zustand / Pinia / etc. o "No necesario"] | [Por qué] |

### Backend
| Decisión | Tecnología | Justificación |
|---|---|---|
| Framework | [Node/Express / Laravel / etc.] | [Por qué] |
| Lenguaje | [TypeScript / PHP / etc.] | [Por qué] |
| API style | [REST / GraphQL / tRPC] | [Por qué] |
| Auth | [JWT / Sessions / OAuth] | [Por qué] |

### Base de datos
| Decisión | Tecnología | Justificación |
|---|---|---|
| Motor | [PostgreSQL / MySQL / MongoDB / etc.] | [Por qué] |
| ORM / Query builder | [Prisma / Eloquent / etc.] | [Por qué] |
| Migraciones | [Estrategia] | [Por qué] |

### Infraestructura
| Decisión | Tecnología | Justificación |
|---|---|---|
| Hosting | [Vercel / Railway / AWS / etc.] | [Por qué] |
| Contenedores | [Docker / No aplica] | [Por qué] |
| CI/CD | [GitHub Actions / etc.] | [Por qué] |

### Testing
| Nivel | Herramienta | Alcance |
|---|---|---|
| Unit | [Jest / Vitest / PHPUnit] | [Qué se testea] |
| Integration | [Supertest / etc.] | [Qué se testea] |
| E2E | [Cypress / Playwright / "Fase 2"] | [Qué se testea] |

---

## 4. Arquitectura del sistema

### Diagrama de alto nivel
```
[Representación en texto/ASCII del sistema]

Ejemplo:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Cliente   │────▶│     API     │────▶│     BD      │
│  (Next.js)  │     │  (Node.js)  │     │ (PostgreSQL) │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                    ┌──────▼──────┐
                    │  Servicios  │
                    │  externos   │
                    └─────────────┘
```

### Módulos principales
| Módulo | Responsabilidad | Tecnología |
|---|---|---|
| [Nombre] | [Qué hace este módulo] | [Stack específico] |
| [Nombre] | [Qué hace este módulo] | [Stack específico] |

### Flujo de datos principal
[Descripción del flujo más importante del sistema: cómo entra un request, qué pasa, cómo sale la respuesta]

---

## 5. Estructura de directorios

```
proyecto/
├── [directorio]/          # [para qué]
│   ├── [subdirectorio]/   # [para qué]
│   └── [subdirectorio]/   # [para qué]
├── [directorio]/          # [para qué]
├── docs/                  # Visión, arquitectura, decisiones
├── specs/                 # Specs del toolkit
│   └── fixes/
└── [config files]
```

---

## 6. Modelo de datos inicial

> Solo las entidades principales del MVP. No modelar lo que no se va a construir.

### Entidad: [Nombre]
| Campo | Tipo | Descripción | Restricciones |
|---|---|---|---|
| id | UUID / INT | Identificador único | PK, auto |
| [campo] | [tipo] | [descripción] | [restricciones] |

### Entidad: [Nombre]
...

### Relaciones
- `[Entidad A]` tiene muchos `[Entidad B]`
- `[Entidad B]` pertenece a `[Entidad A]`

---

## 7. Decisiones técnicas fundamentales

> Decisiones que no deben revertirse sin una discusión seria. Documentar el razonamiento es tan importante como la decisión.

### DT-01: [Nombre de la decisión]
**Decisión:** [Qué se decidió]
**Contexto:** [Por qué era una decisión necesaria]
**Alternativas consideradas:** [Qué más se evaluó]
**Justificación:** [Por qué esta opción y no las otras]
**Consecuencias:** [Qué implica esta decisión a futuro]

### DT-02: [Nombre de la decisión]
...

---

## 8. Convenciones del proyecto

### Naming
- **Archivos:** [kebab-case / PascalCase según tipo]
- **Funciones/métodos:** [camelCase / snake_case]
- **Clases:** [PascalCase]
- **Variables de entorno:** [UPPER_SNAKE_CASE]
- **Ramas git:** [feature/xxx, fix/xxx, hotfix/xxx]

### Commits
[Conventional commits / Formato libre / etc.]
```
feat: nueva funcionalidad
fix: corrección de bug
docs: documentación
chore: mantenimiento
```

### Code review
[Si aplica: criterios, quién aprueba, etc.]

---

## 9. Seguridad

- **Autenticación:** [Estrategia y herramienta]
- **Autorización:** [Roles y permisos — cómo se modelan]
- **Datos sensibles:** [Cómo se manejan, dónde se almacenan]
- **Variables de entorno:** [`.env` local, secrets en producción via X]
- **Dependencias:** [Política de actualización]

---

## 10. Deuda técnica conocida desde el inicio

> Decisiones que se toman por velocidad en el MVP pero que deberán revisarse.

- **[Área]:** [Qué se está simplificando y por qué] → Revisar en Fase [X]

---

## 11. Preguntas pendientes
*(Eliminar si no hay)*
- **[Por definir]:** [Decisión técnica que aún no tiene respuesta]

---
## Historial

| Versión | Fecha | Acción |
|---|---|---|
| 1.0 | YYYY-MM-DD | Creado por jr-arch |
```

---

## Paso 5 — Actualizar PROJECT.md

> ⚠️ **Obligatorio. Ejecutar sin preguntar.**

Si existe `PROJECT.md`, actualízalo con el stack y la arquitectura definidos.
Si no existe, créalo usando la información del documento de arquitectura como base — sigue la estructura del template de `jr-init`.

---

## Paso 6 — Guardar y confirmar

> ⚠️ **Obligatorio. No preguntar — ejecutar directamente.**

1. Crea `docs/` si no existe.
2. Guarda en `docs/architecture.md`.
3. Confirma:

```
✅ Arquitectura guardada en `docs/architecture.md`
✅ PROJECT.md actualizado

**Stack definido:** [resumen en una línea]
**Módulos principales:** [lista]

**Próximo paso:**
Ejecuta `/jr-roadmap` para descomponer el producto en épicas y features ordenados.
```

---

## Principios

- **Justifica todo**: una decisión sin razonamiento es una trampa futura.
- **MVP primero**: no arquitectures para escala que no existe. La escala prematura es el enemigo.
- **Honesto sobre trade-offs**: toda decisión tiene costos. Documentarlos previene sorpresas.
- **No reinventar**: si hay una solución estándar para el problema, úsala. La originalidad técnica tiene un costo alto.
- **La deuda técnica consciente está bien**: lo que mata proyectos es la deuda inconciente.
