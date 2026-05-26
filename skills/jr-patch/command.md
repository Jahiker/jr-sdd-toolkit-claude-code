---
description: Fast path for trivial low-risk changes (colors, copy, typos) without the full spec flow
model: sonnet
tools: Read, Write, Edit, Glob, Grep
---

# /jr-patch

Flujo ágil para cambios atómicos de bajo riesgo que no justifican el ciclo completo de spec. Sin spec, sin plan de ejecución, sin lifecycle — solo: localizar → clasificar riesgo → mostrar diff → confirmar → aplicar → log.

## Uso

```
/jr-patch cambiar el color del título del header de #333 a #1a1a1a en Header.tsx

/jr-patch corregir el typo "recieve" → "receive" en validation messages

/jr-patch cambiar el placeholder del input de búsqueda a "Buscar productos..."
```

## Para qué SÍ es

- Valores estéticos: colores, spacing, tamaños, fuentes, bordes, sombras
- Strings de UI / copy / labels / placeholders
- Constantes de config no críticas
- Typos en comentarios, docs, o texto visible
- Reordenar imports, formato, whitespace
- Comentarios

## Para qué NO es (la capa de seguridad)

`/jr-patch` clasifica el riesgo **antes** de tocar nada. Si detecta que el cambio no es trivial, **se rehúsa** y te redirige al flujo completo.

### 🔴 Rechazo duro (te manda a /jr-fix-spec o /jr-iterate-spec)

El cambio toca:
- Lógica de control de flujo (condiciones, loops, returns)
- Auth, permisos, validación, seguridad, tokens, sesiones
- DB: queries, migraciones, schema, modelos
- Dinero, fechas, cálculos
- APIs externas / red / env vars
- Requiere instalar una dependencia
- Más de 2 archivos o más de ~15 líneas

### 🟡 Advertencia blanda (te avisa, tú decides)

- Toca 2 archivos (al límite)
- Se acerca a ~15 líneas
- Modifica código con comentario `// spec:` (nació de un spec — cambiarlo lo desincroniza)

En advertencia blanda puedes elegir: continuar con patch (deja rastro del cambio fuera de spec) o saltar a `/jr-iterate-spec`.

## Ejemplo de rechazo

```
$ /jr-patch cambiar la condición de login para que acepte emails sin verificar

⚠️ Este cambio no califica para /jr-patch porque modifica lógica de 
validación de auth en Login.tsx.

Un cambio así merece trazabilidad completa. Te sugiero:
- Si es un bug → /jr-fix-spec
- Si es un cambio a una feature existente → /jr-iterate-spec @specs/auth.md

¿Lanzo uno de esos en su lugar?
```

## Ejemplo de flujo exitoso

```
$ /jr-patch cambiar color del título de #333 a #1a1a1a en Header.tsx

📝 Cambio propuesto — Header.tsx

- color: #333;
+ color: #1a1a1a;

Oscurece el título del header.

¿Aplico? (sí / ajustar)

> sí

✓ Aplicado en Header.tsx
✓ Registrado en docs/progress.md
```

## Interacción con el modo dev

En proyectos con `Mode: dev` la capa de seguridad es más estricta:

| | default | dev |
|---|---|---|
| Umbral advertencia blanda | >2 archivos / >15 líneas | >1 archivo / >8 líneas |
| Código con `// spec:` | advertencia blanda | **rechazo duro** |
| Override de auth/DB/seguridad | permitido con confirmación | **no permitido** |

La idea: el flujo rápido sigue existiendo para cambios genuinamente triviales, pero en proyecto serio la definición de "trivial" se aprieta.

## Trazabilidad

Aunque salta el spec, `/jr-patch` **siempre** deja una línea en `docs/progress.md`:

```markdown
## 2026-05-22 — jr-patch — Header.tsx
Changed header title color #333 → #1a1a1a. No spec (cosmetic).
```

Si fue un cambio sobre código de spec (drift), el log lo marca explícitamente para que `/jr-status` o `/jr-sync` puedan detectarlo después.

## Notas

- El flujo rápido es un privilegio que se gana por ser el cambio trivial — no un derecho a saltarte el proceso.
- "Es solo una línea" es justo cuando el check importa más.
- Si dudas, el skill redirige al flujo completo. Un redirect falso cuesta minutos; un fast-path falso puede costar un incidente.
