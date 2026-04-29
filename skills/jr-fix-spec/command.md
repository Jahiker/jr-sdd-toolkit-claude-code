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
