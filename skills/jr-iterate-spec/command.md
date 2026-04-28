# /jr-iterate-spec

Itera sobre un spec existente incorporando nuevos cambios o requerimientos. Versiona semánticamente y produce el spec actualizado listo para ejecutar con jr-exe-spec.

## Uso

```
/jr-iterate-spec @specs/nombre-del-spec.md
```

Luego describe el cambio en el chat, o adjunta un archivo `.md` con el nuevo requerimiento.

## Descripción

1. **Lee** el spec existente como base (cualquier status: Draft, Implemented, Verified)
2. **Analiza** el cambio solicitado y clasifica su tipo:
   - **Patch** `1.0 → 1.1`: mejoras pequeñas, CAs adicionales, edge cases, RNFs
   - **Minor** `1.0 → 2.0`: RFs nuevos, cambios en flujo principal, diseño técnico significativo
3. **Detecta conflictos** con RFs existentes o código ya implementado
4. **Formula preguntas** solo si hay ambigüedades que impiden escribir CAs verificables
5. **Construye el spec iterado** completo: RFs marcados con cambios, sección Delta, Historial actualizado
6. **Guarda** sobreescribiendo el spec existente (el historial se preserva siempre)

## Diferencia con jr-build-spec

| | jr-build-spec | jr-iterate-spec |
|---|---|---|
| Input | Requerimiento crudo | Spec existente + cambio |
| Output | Spec nuevo | Spec versionado |
| Status resultante | Draft | Draft (listo para re-ejecutar) |
| Historial | Crea | Preserva y extiende |

## Notas

- No ejecuta código — solo construye el spec iterado. Usa `/jr-exe-spec` para el delta.
- Si el cambio es tan grande que desvirtúa el spec original, el skill sugiere crear un spec nuevo.
- El status vuelve a `Draft` aunque el spec estuviera `Implemented` o `Verified`.
- Después de ejecutar el delta: `/jr-verify-spec @specs/nombre.md`
