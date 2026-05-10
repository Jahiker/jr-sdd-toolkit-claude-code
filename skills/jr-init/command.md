# /jr-init

Inicializa un proyecto para el toolkit. Crea o actualiza `PROJECT.md` con stack, arquitectura, convenciones y el bloque `Toolkit Context` que todas las demás skills leen.

## Uso

```
# Modo default (sin gates de validación extra)
/jr-init

# Modo dev (activa validaciones estrictas en build-spec y exe-spec)
/jr-init --dev

# Forzar modo default sobre un proyecto que ya está en dev
/jr-init --no-dev
```

## Sobre el `Mode`

A partir de v1.8.0 el toolkit tiene dos modos de operación, definidos en el bloque `Toolkit Context` de `PROJECT.md`:

| Mode | Comportamiento |
|---|---|
| `default` | Flujo fluido. Las skills hacen su trabajo sin gates adicionales. Ideal para prototipos, exploraciones, proyectos personales pequeños. |
| `dev` | Las skills modificadoras críticas (`jr-build-spec`, `jr-exe-spec`) aplican validaciones adicionales tipo "code review por un segundo senior". Diseñado para proyectos serios donde el costo de errores es alto. |

El modo se persiste en `PROJECT.md` y aplica a todo el proyecto. Para invocaciones puntuales puedes hacer override:

```
/jr-build-spec @req.md --dev      # forzar dev en una invocación
/jr-build-spec @req.md --no-dev   # forzar default en una invocación
```

## Cómo funciona

1. **Detecta** el estado del proyecto: PROJECT.md existente, CLAUDE.md, specs/.
2. **Parsea** el flag `--dev` / `--no-dev` (si se proporciona).
3. **Explora** stack, arquitectura, convenciones desde los archivos de configuración.
4. **Crea o actualiza** PROJECT.md preservando ediciones manuales.
5. **Escribe** el bloque `Toolkit Context` con el campo `Mode:` correctamente.
6. **Confirma** mostrando qué se creó/actualizó, el modo activo, y el siguiente paso sugerido.

## Resolución de modo (resumen)

| Flag pasado | PROJECT.md existía con Mode | Resultado |
|---|---|---|
| `--dev` | (cualquiera) | `Mode: dev` |
| `--no-dev` | (cualquiera) | `Mode: default` |
| (ninguno) | tenía `Mode:` | preserva el valor existente |
| (ninguno) | sin `Mode:` o sin PROJECT.md | `Mode: default` |

## Notas

- Modo `default` es el comportamiento clásico — sin cambios respecto a v1.7.0 y anteriores.
- Modo `dev` se diseñó pensando en devs senior que quieren forzar rigor en cada etapa.
- Cambiar el modo después: vuelve a correr `/jr-init --dev` o `/jr-init --no-dev`.
- `PROJECT.md` viejo sin campo `Mode:` se actualiza automáticamente la próxima vez que corras `/jr-init` (con valor `default` por compatibilidad).
