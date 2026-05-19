---
description: Transform a rough requirement into a professional spec
model: sonnet
tools: Read, Write, Glob, Grep
---

# /jr-build-spec

Transforma un requerimiento o historia de usuario en un spec técnico profesional. En modo `--dev`, evalúa la calidad del spec con una rúbrica de 6 dimensiones y bloquea specs débiles.

## Uso

### Modo default (clásico)

```
# Con archivo .md
/jr-build-spec @ruta/al/requerimiento.md

# Directo en el chat (sin archivo)
/jr-build-spec
quiero agregar autenticación con OAuth de Google al login...

# Combinado (archivo + contexto adicional)
/jr-build-spec @req.md
y además tener en cuenta que ya tenemos un session manager existente
```

### Modo dev (rigor extra)

```
# Activa rúbrica de readiness aunque PROJECT.md esté en modo default
/jr-build-spec @req.md --dev

# Si PROJECT.md ya está en Mode: dev, esto es lo mismo que /jr-build-spec @req.md
/jr-build-spec @req.md

# Forzar modo default sobre un proyecto que está en dev
/jr-build-spec @req.md --no-dev
```

## Diferencia entre modos

| | default | --dev |
|---|---|---|
| Construye el spec | ✓ | ✓ |
| Detecta solapamientos | ✓ | ✓ (incluye sketches) |
| Categoriza preguntas | ✓ | ✓ |
| Aplica rúbrica de 6 dimensiones | — | ✓ |
| Bloquea specs débiles | — | ✓ |
| Genera Readiness Report inline | — | ✓ |

## La rúbrica (modo `--dev`)

Cuando corres `/jr-build-spec --dev`, después de construir el spec se evalúan 6 dimensiones:

| Dimensión | Peso | Qué se evalúa |
|---|---|---|
| 🎯 Clarity of intent | 15% | El "qué" y "por qué" están claros y medibles |
| 🧪 Testability of ACs | 25% | Cada AC es observable con criterio explícito |
| 🚧 Boundary definition | 10% | Out of Scope explícito y contundente |
| 🔗 Dependency awareness | 15% | Deps internas, externas, ordenamiento |
| ⚠️ Risk identification | 15% | Edge cases concretos, NFRs realistas |
| 🏗️ Architectural fit | 20% | Respeta el stack/arquitectura existentes |

Score ponderado:

| Score | Etiqueta | Resultado |
|---|---|---|
| **<60** | ❌ Not ready | Se guarda como `specs/sketches/[slug].md` con `Status: Sketch`. `/jr-exe-spec --dev` no lo ejecuta. |
| **60–74** | ⚠️ Needs work | Se guarda como `Draft` con flag `Readiness: Needs work`. `/jr-exe-spec --dev` lo rechaza hasta llegar a ≥75. |
| **75–89** | ✅ Ready | Se guarda como `Draft` normal. Listo para implementar. |
| **≥90** | 🌟 Excellent | Se guarda como `Draft` con badge de excelencia. Raro. |

## Ejemplo de output `--dev`

```
📋 Spec construido: specs/auth-oauth-google.md

## Readiness Report (jr-build-spec --dev)

🎯 Clarity of intent          ████████░░  80   ✓
🧪 Testability of ACs         ██████░░░░  60   ⚠ 3 ACs sin criterio observable
🚧 Boundary definition        █████████░  90   ✓
🔗 Dependency awareness       ████░░░░░░  40   ❌ no menciona session middleware existente
⚠️  Risk identification        ███████░░░  70   ✓
🏗️  Architectural fit          ████░░░░░░  40   ❌ propone Passport, codebase usa flow directo

**Overall readiness: 63 / 100  ⚠️ Needs work**

Top 3 blockers:
1. AC-02 "el login funciona bien" no es testable. Reformula con criterio observable 
   (status code, payload exacto, etc.).
2. Spec no analiza interacción con SessionMiddleware (src/middleware/session.ts). 
   Documenta el impacto en sección 9 (Dependencies).
3. Sección 7 propone Passport.js pero PROJECT.md/ADR-002 establece flow directo. 
   Justifica desviación o alinea.

📁 Guardado en: specs/auth-oauth-google.md (Draft + Needs work)

❗ /jr-exe-spec --dev no ejecutará este spec hasta llegar a ≥75. 
   Itera con /jr-build-spec para mejorar el score, o ejecuta sin --dev si lo prefieres.
```

## Re-evaluar un sketch o un Needs work

```
# Si el spec está en specs/sketches/ y ya lo iteraste
/jr-build-spec @specs/sketches/auth-oauth.md --dev

# Si el score sube a ≥60, el archivo se MUEVE de specs/sketches/ a specs/
# Si sigue debajo, se sobrescribe el sketch con el nuevo contenido + nuevo report
```

## Override manual

Si crees que el score está mal calibrado para tu caso, puedes pedir override explícito:

```
/jr-build-spec @req.md --dev
# después del report:
"override y guarda como Draft de todos modos"
```

El spec se guarda con flag `Readiness: Override`. La responsabilidad es tuya — el toolkit solo registra que pasaste sobre la advertencia.

## Notas

- En modo `default` el comportamiento es idéntico al de v1.7.0 — sin gates, sin score, sin sketches.
- La rúbrica es **estricta a propósito**. Specs bien escritos suelen puntuar 70–85. Los >90 son raros.
- El score se calcula sobre el contenido del spec, no sobre el input del dev. Un input vago + skill que pregunta bien puede producir un spec de 80+.
- Sketches se consideran en detección de solapamientos pero no son válidos para `/jr-exe-spec --dev`.
