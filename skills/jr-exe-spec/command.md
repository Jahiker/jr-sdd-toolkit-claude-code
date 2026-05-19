---
description: Implement an approved spec in code with full traceability
model: opus
tools: Read, Write, Edit, Glob, Grep, Bash
---

# /jr-exe-spec

Implementa un spec aprobado en código real. En modo `--dev`, aplica 3 gates de pre-ejecución antes de mostrar el plan: comprensión del scope, riesgo identificado, y estrategia de rollback.

## Uso

### Modo default (clásico)

```
/jr-exe-spec @specs/feature.md
```

Ejecuta el flujo de v1.7.0: validar spec → escanear proyecto → mostrar plan → aprobar → ejecutar → actualizar spec → log de progreso.

### Modo dev (gates de pre-ejecución)

```
# Activa los 3 gates aunque PROJECT.md esté en modo default
/jr-exe-spec @specs/feature.md --dev

# Forzar modo default sobre un proyecto en dev
/jr-exe-spec @specs/feature.md --no-dev
```

## Diferencias entre modos

| | default | --dev |
|---|---|---|
| Valida spec existe | ✓ | ✓ |
| Acepta Sketches | con warning | **rechaza** |
| Acepta `Readiness: Needs work` | con warning | **rechaza** (a menos que `--no-dev`) |
| Pre-execution gates (3 preguntas) | — | ✓ |
| Comparación de answers vs plan | — | ✓ |
| Rechaza respuestas vagas | — | ✓ |
| Plan + ejecución | ✓ | ✓ |
| Log enriquecido en progress.md | — | ✓ (incluye risk + rollback) |

## Los 3 gates (`--dev`)

Antes de mostrarte el plan de ejecución, el toolkit te hace 3 preguntas. **No es burocracia** — es para asegurar que entendiste el spec antes de aprobarlo.

### Gate 1 — Files-to-touch check

> ¿Qué archivos esperas que se creen o modifiquen?

Tu lista se compara con el plan interno. Si ≥30% de los archivos del plan no están en tu lista, o si listas archivos críticos (middleware, auth, migrations) que el plan no toca → discrepancia crítica que debe reconciliarse.

### Gate 2 — Risk check

> ¿Cuál crees que es la parte más riesgosa?

Se rechaza si:
- Menos de 10 palabras
- Solo términos genéricos sin sustantivo concreto: `bugs`, `errores`, `complejo`, `difícil`
- Tautológico ("la parte riesgosa es la riesgosa")

Hasta 2 reformulaciones permitidas. Después puedes hacer override explícito ("override risk gate") y queda registrado.

### Gate 3 — Rollback check

> Si esto falla en producción, ¿cómo lo revertirías?

Se rechaza si:
- Menos de 5 palabras
- Solo "git revert" cuando el spec toca: DB migrations, schema, sesiones, datos persistentes, servicios externos
- Mismas opciones de reformulación + override que gate 2

## Ejemplo de interacción `--dev`

```
$ /jr-exe-spec @specs/auth-oauth-google.md --dev

🛡️  Pre-execution check (mode: --dev)

Antes de mostrarte el plan, necesito 3 cosas...

1️⃣  Files-to-touch check
2️⃣  Risk check  
3️⃣  Rollback check

Responde las 3 cuando estés listo.

> Tu respuesta:
> 1. Crearé src/auth/google.ts y voy a tocar middleware.ts y routes/auth.ts
> 2. La parte más riesgosa es el callback handler — si el state no coincide 
>    con el de la sesión, podemos perder el redirect destino del usuario
> 3. git revert + flush de la cookie de session_state en producción para 
>    invalidar tokens parciales

⚠️ Gate 1 — discrepancia: el plan también toca src/services/session.ts 
   (necesario para guardar el state). ¿Lo dejaste fuera intencionalmente?

> Tu respuesta:
> No, no lo había considerado. Procede.

✅ Pre-execution gates passed (mode: --dev)
   Files-to-touch: 4 archivos confirmados (incluyendo session.ts post-reconcile)
   Risk identified: state mismatch en callback → pérdida de redirect destino
   Rollback strategy: git revert + flush de session_state en producción

📋 Execution Plan — auth-oauth-google
[plan content]

Approve? Reply "yes" to execute.
```

## Cuándo el toolkit rechaza ejecutar (modo `--dev`)

| Situación | Acción |
|---|---|
| Spec en `specs/sketches/` | Refuse: pide iterar con `/jr-build-spec --dev` |
| Spec con `Readiness: Needs work` | Refuse: pide subir score o invocar con `--no-dev` |
| Gate 1 con discrepancia crítica sin reconciliar | Refuse hasta reconciliación |
| Gate 2/3 vago después de 2 reformulaciones sin override | Pide override explícito |

## Override

Si después de 2 reformulaciones de gate 2 o 3 sigues con una respuesta que el toolkit considera vaga, puedes forzar con:

```
override risk gate
# o
override rollback gate
```

El override + tu última respuesta queda registrado en la tabla History del spec y en `docs/progress.md`. **La responsabilidad es tuya.** El toolkit deja el rastro.

## Notas

- En modo `default` nada cambia respecto a v1.7.0.
- Los gates están diseñados para hacerte pensar, no para impedirte trabajar. Si una pregunta te molesta, probablemente es la que más necesitas.
- Si trabajas en un proyecto importante, considera dejar `Mode: dev` en PROJECT.md (con `/jr-init --dev`) y olvidarte del flag.
- Los gates se aplican **antes** del plan, no después. La idea es que llegues al plan con la cabeza en el lugar correcto.
- `--dev` también enriquece el log de progreso: las entradas en `docs/progress.md` incluyen el risk identificado y la estrategia de rollback. Útil cuando vuelves al proyecto después.
