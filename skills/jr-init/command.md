# /jr-init

Inicializa un proyecto para trabajar con el toolkit spec-driven. Explora el proyecto en profundidad y crea `PROJECT.md` con stack, arquitectura y convenciones — contexto permanente que todos los skills del toolkit usan en cada sesión.

## Uso

```
/jr-init
```

No requiere argumentos. Se ejecuta en la raíz del proyecto.

## Descripción

1. **Verifica** si existen `CLAUDE.md`, `PROJECT.md` y `specs/`
2. **Explora** el proyecto: estructura, stack, frameworks, convenciones, decisiones técnicas, variables de entorno, comandos
3. **Lee `CLAUDE.md`** si existe — extrae contexto sin modificarlo
4. **Crea `PROJECT.md`** con toda la información relevante del proyecto
5. **Si `PROJECT.md` ya existe** — lo actualiza preservando ediciones manuales
6. **Orienta** sobre el siguiente paso según el estado actual del proyecto

## Por qué existe

Claude no recuerda entre sesiones. Sin `PROJECT.md`, cada skill tiene que re-inferir el stack y las convenciones del proyecto en cada conversación, con riesgo de inconsistencias. `PROJECT.md` es la memoria persistente del proyecto — se crea una vez y se actualiza cuando cambia algo importante.

## Cuándo volver a ejecutarlo

- Al agregar una dependencia o framework importante al proyecto
- Al cambiar convenciones de naming o estructura
- Al incorporar un dev nuevo al equipo
- Al cambiar de arquitectura

## Notas

- No modifica `CLAUDE.md` — solo lo lee.
- Si `PROJECT.md` ya existe, actualiza solo lo que cambió y preserva ediciones manuales.
- El toolkit completo estará disponible al finalizar: `jr-build-spec`, `jr-exe-spec`, `jr-verify-spec`, `jr-iterate-spec`, `jr-status`.
