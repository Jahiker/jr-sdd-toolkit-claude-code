# /jr-exe-spec

Ejecuta un spec técnico aprobado: genera un plan de implementación, espera aprobación y aplica todos los cambios en el código con trazabilidad completa.

## Uso

```
/jr-exe-spec @specs/nombre-del-spec.md
```

## Descripción

1. **Valida** el spec (estructura completa, sin `[PENDING]` críticos, dependencias implementadas)
2. **Verifica el status** del spec — advierte si ya fue implementado
3. **Escanea** el proyecto para entender el estado real del código
4. **Genera** un plan de ejecución por fases con cada cambio explícito
5. **Espera** tu aprobación antes de tocar cualquier archivo
6. **Ejecuta** fase por fase, anunciando y confirmando cada acción
7. **Agrega trazabilidad**: `// spec: specs/nombre.md` en cada archivo creado o bloque introducido
8. **Reporta** el resumen final con archivos afectados y cómo verificar
9. **Actualiza** el spec: `Status: Implemented` + sección `Archivos Afectados` + entrada en Historial

## Stack soportado

JavaScript · TypeScript · PHP · React · Next.js · TanStack · Vue · Node.js · Laravel · WordPress · Shopify · CSS · Sass · Tailwind CSS · Webpack · Vite · Docker

## Notas

- No ejecuta nada hasta que apruebes el plan.
- `[PENDING]` críticos bloquean la ejecución.
- Verifica que specs dependientes estén implementados antes de continuar.
- `.env` / secrets nunca se escriben con valores reales → genera `.env.example`.
- Al finalizar sugiere ejecutar `/jr-verify-spec` para verificar criterios de aceptación.
