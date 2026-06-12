---
description: Diagnose and fix bugs with full documentation
model: sonnet
tools: Read, Write, Edit, Glob, Grep, Bash
---

# /jr-fix-spec

Diagnostica, documenta y corrige bugs de forma estructurada y quirúrgica. Toca lo mínimo necesario, deja trazabilidad completa y verifica regresión.

## Uso

```
/jr-fix-spec @specs/fixes/nombre-del-bug.md
```

Primero crea un archivo `.md` breve en `specs/fixes/` describiendo el bug:
```markdown
# Bug: email vacío pasa validación en checkout

El campo email no valida cuando está vacío.
Pasa directo al siguiente paso sin mostrar error.

Archivo donde ocurre: src/components/CheckoutForm.tsx
```

Luego ejecuta el comando.

## Descripción

1. **Lee** el reporte del bug
2. **Busca** el spec relacionado si existe — identifica qué CA viola
3. **Diagnostica** el root cause con ubicación exacta en el código
4. **Presenta** el diagnóstico y espera confirmación
5. **Genera** un fix plan quirúrgico (mínimo cambio posible)
6. **Espera** aprobación antes de tocar cualquier archivo
7. **Ejecuta** el fix con trazabilidad: `// fix: specs/fixes/nombre.md`
8. **Verifica** regresión en flujos adyacentes
9. **Actualiza** el spec original (nuevo CA) o el fix report (si no hay spec)
10. **Reporta** el resumen con cómo confirmar el fix

## Funciona en ambos casos

| Caso | Comportamiento |
|---|---|
| Con spec relacionado | Identifica el CA violado, agrega caso borde al spec como CA nuevo, registra en Historial como Hotfix |
| Sin spec (código legacy) | Documenta diagnóstico y solución en el fix report dentro de `specs/fixes/` |

## Notas

- No ejecuta nada hasta que apruebes el diagnóstico y el fix plan.
- Si el fix requiere más de 5 archivos, sugiere hacer un `/jr-iterate-spec` en su lugar.
- No mezcla el fix con mejoras — la deuda técnica se documenta, no se resuelve en el mismo fix.
- No cambia el Status ni la versión del spec original — un hotfix no es una iteración.

## Modo dev (v1.11.0)

```
/jr-fix-spec @specs/fixes/bug.md --dev
```

En `--dev`, el bug report se puntúa ANTES de diagnosticar (los reportes vagos son la causa #1 de fixes que rompen otra cosa):

| Dimensión | Peso |
|---|---|
| 🔬 Reproducibilidad | 25% |
| 📍 Localización | 20% |
| 🎯 Expected vs actual | 25% |
| 📊 Frecuencia / severidad | 10% |
| 🔗 Contexto de cambios recientes | 20% |

Score <70 → el skill hace preguntas dirigidas SOLO sobre las dimensiones débiles. Puedes responder "no sé" — los desconocidos honestos se registran y el gate libera. El objetivo es extraer lo que sabes, no bloquearte. Las respuestas se anexan al bug report.

Además: los checks de regresión marcados ⚠️ requieren tu confirmación explícita ("regression checked") antes de cerrar la documentación.
