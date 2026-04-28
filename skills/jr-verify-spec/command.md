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
