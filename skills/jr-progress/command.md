# /jr-progress

Lee o agrega al log de progreso del proyecto (`docs/progress.md`) — la narrativa cronológica de qué se ha hecho, actualizada automáticamente por todas las skills modificadoras.

## Uso

### Modo lectura (default)

```
# Últimas 10 entradas
/jr-progress

# Todo el log
/jr-progress --all

# Desde una fecha específica
/jr-progress --since=2026-04-01

# Filtrar por spec o doc
/jr-progress --target=auth-oauth
```

### Modo nota (append manual)

```
# Agrega una nota al log
/jr-progress --note "Cliente confirmó scope de Drive read-only para OAuth"

# También funciona en lenguaje natural
/jr-progress agrega nota: postponer payment hasta tener Stripe key
```

## Cuándo usarlo

- **Al empezar una sesión** después de tiempo sin tocar el proyecto → recupera contexto narrativo rápido.
- **Antes de tomar decisiones** sobre qué spec atacar → ves qué quedó a medias y por qué.
- **Para anotar contexto extra-skill** → conversaciones con cliente, dependencias bloqueadas, decisiones que no caben en un spec.
- **Auditoría** → ver todo lo que pasó en el último mes/sprint.

## Diferencia con `/jr-status`

| | `/jr-status` | `/jr-progress` |
|---|---|---|
| Pregunta que responde | ¿En qué estado están los specs? | ¿Qué pasó recientemente? |
| Tipo de info | Estructurada (tabla por status) | Narrativa (cronológica) |
| Fuente | Frontmatter de cada spec en `specs/` | `docs/progress.md` |
| Cuándo usar | Decidir qué hacer ahora | Recuperar contexto de sesiones pasadas |

Las dos se complementan: `/jr-progress` para entender el "por qué", `/jr-status` para ver el "qué" actual.

## Cómo se llena el log

**Automático:** todas las skills que modifican el proyecto agregan una entrada al terminar:
- `jr-vision`, `jr-arch`, `jr-roadmap`, `jr-init`
- `jr-build-spec`, `jr-iterate-spec`, `jr-exe-spec`, `jr-verify-spec`, `jr-fix-spec`
- `jr-sync`

**Manual:** con `/jr-progress --note "..."` para anotar cosas que ninguna skill capturó.

## Formato del log

Cada entrada tiene esta estructura:

```markdown
## 2026-05-10 — jr-exe-spec — auth-oauth-google
Implementadas FR-01..FR-04. AC-05 quedó [PENDING] (espera scope del cliente).
Archivos: src/auth/google.ts (creado), src/auth/session.ts (modificado).

## 2026-05-09 — manual note
Cliente confirmó OAuth scope: Drive read-only. Aplicar antes de /jr-verify-spec.
```

## Notas

- El log es **append-only**. Nunca se editan entradas pasadas.
- Si `docs/progress.md` no existe, se crea automáticamente la primera vez que una skill modifica el proyecto, o cuando agregas la primera nota manual.
- No reemplaza la tabla `History` de cada spec — esa sigue siendo la historia detallada por feature. El progress log es para navegación rápida.
