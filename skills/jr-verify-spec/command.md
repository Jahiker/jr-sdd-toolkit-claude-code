---
description: Verify acceptance criteria coverage of an implemented spec
model: sonnet
tools: Read, Write, Glob, Grep, Bash
---

# /jr-verify-spec

Verifica que la implementación de un spec cubre sus criterios de aceptación. Cierra el loop del ciclo spec-driven.

## Uso

```
/jr-verify-spec @specs/nombre-del-spec.md
```

## Descripción

1. **Lee** el spec implementado y extrae todos los criterios de aceptación (CA-XX)
2. **Recorre** el código: archivos afectados, trazabilidad `// spec:`, lógica implementada
3. **Evalúa** cada CA: ✅ Cubierto / ⚠️ Parcial / ❌ Ausente / 🔍 No verificable en código
4. **Genera** un reporte de cobertura con porcentaje, detalle por RF y gaps priorizados
5. **Actualiza** el historial del spec con el resultado de la verificación
6. Si cobertura = 100% → cambia `Status: Implemented` → `Status: Verified`

## Cuándo usarlo

Después de ejecutar `/jr-exe-spec` y antes de pasar el feature a QA o considerar el trabajo terminado.

## Notas

- No reemplaza tests automatizados — los complementa.
- Los gaps se reportan con ubicación exacta en el código y sugerencia de corrección.
- Si hay gaps críticos, el skill recomienda volver a `/jr-exe-spec` para completarlos.
- Funciona incluso si el spec no tiene `Status: Implemented` (modo de auditoría temprana).

## Modo dev (v1.11.0)

```
/jr-verify-spec @specs/x.md --dev
```

En `--dev`, leer código no basta para marcar Verified:

1. **Plan E2E por AC** — el skill genera un comando ejecutable concreto por cada AC (curl exacto, comando de test, pasos de browser) + al menos un caso negativo por FR.
2. **Signoff manual** — ejecutas las verificaciones y reportas por AC: "AC-01 pass" / "AC-02 fail: ..." / "all pass". "Lo revisé leyendo el código" NO cuenta como pass.
3. **Verification Quality score** — 50% ACs ejecutados y pasados + 30% casos negativos + 20% diff review. Se necesita ≥85 y cero ACs fallidos para Verified.
4. **Evidencia persistida** — el plan E2E + resultados se guardan en el spec (`## Verification Evidence`) para re-verificaciones futuras.

Skips honestos permitidos ("AC-07 skipped: sin acceso a staging") — se registran y bloquean Verified, pero no bloquean el reporte. Override explícito disponible (`override verification`), registrado prominentemente.
