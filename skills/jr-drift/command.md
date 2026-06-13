---
description: Detect divergence between specs and their actual implementation (read-only)
model: sonnet
tools: Read, Glob, Grep, Bash
---

# /jr-drift

Detecta divergencia entre los specs y el código que los implementa. **Read-only** — analiza y reporta, nunca modifica. Hermano de `/jr-sync`: sync reconcilia config (PROJECT.md ↔ codebase), drift reconcilia trazabilidad (specs ↔ implementación).

## Uso

```
/jr-drift
```

Sin argumentos. Analiza todos los specs contra el código.

## El problema que resuelve

Un spec puede quedar marcado como Verified, y después su código cambia — por un `/jr-patch`, un `/jr-fix-spec`, o a mano — sin que nadie actualice el spec. El spec ahora miente sobre lo que el código hace. `/jr-drift` saca a la luz esa divergencia silenciosa.

## Los tres tipos de drift

| Tipo | Qué es | Severidad |
|---|---|---|
| 🔴 Coverage drift | Trazabilidad rota: `Affected Files` lista archivos que ya no existen, o código con `// spec: X` donde X no existe en specs/ | Alta |
| 🟠 Spec drift | Un spec Verified cuyo código se modificó después de verificarse, sin re-verificar | Media |
| 🟡 Plan drift | En un `exe-spec --dev`, los archivos declarados difirieron de los realmente tocados (histórico, informativo) | Baja |

## Ejemplo de output

```
🔍 Drift Report — mi-proyecto
Analizado: specs/ + traceability comments + git log

🔴 Coverage drift — 2
  - specs/auth.md → Affected Files lista src/legacy/login.ts (ya no existe)
  - src/payments/stripe.ts tiene // spec: payment-flow pero ese spec no existe

🟠 Spec drift — 3
  - checkout-flow.md (Verified 2026-05-20) → modificado después:
      src/cart.ts (jr-patch 2026-06-01), src/checkout.ts (mano/git 2026-06-08)
      → Re-verificar con /jr-verify-spec, o iterar si el comportamiento cambió

🟡 Plan drift — 1
  - email-notifications.md → declaró 4 archivos, tocó 6

✅ En sync — 8 specs alineados con su código

Sugerencias priorizadas:
  1. [🔴 URGENTE] comment huérfano payment-flow → identifica el spec o límpialo
  2. [🟠] Re-verificar checkout-flow — 2 cambios post-Verified
  3. [🟡] email-notifications: informativo, sin acción
```

## Cómo lo detecta

- **Coverage**: verifica que los archivos del Affected Files existan; grep de `// spec:` huérfanos.
- **Spec**: para specs Verified, cruza la fecha de Verified contra entradas posteriores de patch/fix en progress.md y, si hay git, `git log` de los archivos del spec.
- **Plan**: lee entradas históricas de `exe-spec --dev` con mismatch declarado vs. real.

La señal más confiable de spec drift es la sección `## Post-verification changes` que `/jr-patch` y `/jr-fix-spec` escriben automáticamente en el spec cuando tocan código ya verificado (cross-reading, v1.12.0).

## Qué NO hace

- No modifica ningún archivo. Cero side effects.
- No re-verifica, no itera, no limpia. Solo reporta y sugiere a qué skill ir.
- Si no hay git ni progress.md, solo detecta coverage drift (existencia de archivos + comments huérfanos) y te lo dice.

## Relación con otras skills

| | `/jr-status` | `/jr-sync` | `/jr-drift` |
|---|---|---|---|
| Pregunta | ¿Estado de cada spec? | ¿PROJECT.md refleja el proyecto? | ¿Los specs reflejan su código? |
| Modifica | No | Sí (con aprobación) | **No (nunca)** |

`/jr-status` ahora muestra un resumen de drift en su dashboard; corre `/jr-drift` para el detalle completo.
