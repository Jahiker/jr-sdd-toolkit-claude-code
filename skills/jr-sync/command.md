# /jr-sync

Detecta y reconcilia el drift entre `PROJECT.md` y el estado real del proyecto. Quirúrgico: solo toca lo que cambió.

## Uso

```
/jr-sync
```

No requiere argumentos. Lee `PROJECT.md` y vuelve a escanear el proyecto.

## Cuándo usarlo

- Después de actualizar dependencias importantes (subir versiones mayores, agregar/quitar paquetes).
- Después de reorganizar directorios o cambiar build tools.
- Cuando otro skill se comporta raro porque `PROJECT.md` está desactualizado.
- Periódicamente (al cierre de sprint, antes de empezar nuevas features).
- Antes de `/jr-build-spec` o `/jr-exe-spec` si llevas tiempo sin abrir el proyecto.

## Qué detecta

| Categoría | Ejemplos |
|---|---|
| 🧱 Stack | Nuevas deps, deps removidas, bumps de versión mayor, nuevos dev tools |
| 🏗️ Arquitectura | Nuevos directorios top-level, build tool cambiado, módulos nuevos |
| 🧹 Convenciones | Cambios en `.eslintrc`, `tsconfig.json`, `prettier`, etc. |
| 🧭 Toolkit Context | Las líneas de resumen ya no reflejan el estado real |
| 📋 Tabla de specs | Specs en `specs/` no listados en `PROJECT.md`, o al revés |
| 🌐 Otros | Nuevas env vars, nuevos scripts npm útiles |

## Cómo funciona

1. **Lee** `PROJECT.md` y vuelve a escanear el proyecto.
2. **Compara** lo documentado vs lo detectado.
3. **Reporta** todas las desviaciones agrupadas por categoría (no escribe aún).
4. **Pregunta** qué aplicar:
   - `all` → aplica todo
   - `selective` → categoría por categoría
   - `cancel` → no escribe nada
5. **Actualiza** `PROJECT.md` quirúrgicamente, preservando todas las secciones que no cambiaron.
6. **Confirma** con un resumen y sugiere siguiente paso si hay specs huérfanos o cambios arquitectónicos importantes.

## Notas

- Nunca sobrescribe sin aprobación.
- Preserva ediciones manuales en secciones no afectadas.
- Si no existe `PROJECT.md`, el skill te sugiere correr `/jr-init` primero.
- Si el drift es masivo (>10 cambios en stack o arquitectura completamente nueva), sugiere reiniciar con `/jr-init` en vez de remendar.
- Agrega una entrada de versión patch en la tabla History de `PROJECT.md`.

## Próximo paso

Si después de syncar aparecen specs nuevos o cambios arquitectónicos importantes, considera revisar los specs afectados con `/jr-iterate-spec` o re-ejecutarlos con `/jr-exe-spec`.
