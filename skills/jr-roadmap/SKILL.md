---
name: jr-roadmap
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-roadmap o quiera descomponer un producto en features ejecutables y ordenados. Se activa con frases como "hacer el roadmap", "planificar el proyecto", "qué construir primero", "descomponer el producto", "backlog del proyecto", "orden de desarrollo", o cuando se mencione /jr-roadmap. Lee docs/vision.md y docs/architecture.md, descompone el producto en épicas y features, los ordena por dependencias técnicas y valor, y produce un roadmap accionable con el orden de ejecución recomendado. Al finalizar, el usuario puede ejecutar jr-build-spec sobre cada feature en orden. Es el tercer paso del flujo de inicio de proyecto.
---

# jr-roadmap

Tercer skill del flujo de inicio de proyecto. Con visión y arquitectura definidas, descompone el producto en épicas y features, los ordena por dependencias y valor entregado, y produce el mapa de trabajo que guía el uso del resto del toolkit.

**Posición en el flujo:**
```
jr-vision → jr-arch → [jr-roadmap] → jr-build-spec → jr-exe-spec → jr-verify-spec
```

---

## Paso 0 — Validar input

```
/jr-roadmap
```

No requiere argumentos. Busca automáticamente `docs/vision.md` y `docs/architecture.md`.

Si falta alguno:
> "Necesito estos documentos para construir el roadmap:
> - `docs/vision.md` → ejecuta `/jr-vision` [encontrado ✓ / no encontrado ✗]
> - `docs/architecture.md` → ejecuta `/jr-arch` [encontrado ✓ / no encontrado ✗]"

Lee ambos documentos completos antes de continuar.

---

## Paso 1 — Extraer features desde la visión y la arquitectura

Con base en ambos documentos, lista todos los features identificados:

- Del **MVP** de la visión (sección 6)
- De los **módulos** de la arquitectura (sección 4)
- De las **entidades del modelo de datos** (sección 6 de arquitectura)
- Features **técnicos implícitos** que no están en la visión pero son necesarios (autenticación, infraestructura base, etc.)

Presenta la lista al usuario antes de ordenar:

```
## 📋 Features identificados

Encontré los siguientes features desde la visión y la arquitectura. 
¿Falta algo o quieres agregar/quitar alguno antes de ordenarlos?

**Técnicos (infraestructura):**
- [ ] Setup del proyecto y CI/CD
- [ ] Sistema de autenticación
- [ ] [otros técnicos]

**MVP (producto):**
- [ ] [Feature 1]
- [ ] [Feature 2]
- [ ] [Feature 3]

**Fase 2 (no en MVP):**
- [ ] [Feature A]
- [ ] [Feature B]
```

Espera confirmación o ajustes antes de continuar.

---

## Paso 2 — Ordenar por dependencias y valor

Para cada feature, evalúa:

**Dependencias técnicas:** ¿qué debe existir antes de poder construir esto?
- Ejemplo: "Gestión de clientes" depende de "Sistema de autenticación"
- Ejemplo: "Dashboard de reportes" depende de "Módulo de facturación"

**Valor entregado:** ¿cuánto valor aporta al usuario final?
- Alto: es parte del flujo principal del producto
- Medio: mejora la experiencia pero no es bloqueante
- Bajo: nice-to-have, no cambia el valor core

**Complejidad técnica:**
- Alta: involucra múltiples módulos, integraciones externas, o lógica compleja
- Media: un módulo con lógica moderada
- Baja: CRUD simple, UI sin lógica compleja

Con esto, ordena los features respetando las dependencias y priorizando valor sobre complejidad.

---

## Paso 3 — Construir el roadmap

```markdown
# Roadmap — [Nombre del Proyecto]

**Status:** Active
**Fecha:** YYYY-MM-DD
**Autor:** jr-roadmap
**Basado en:** docs/vision.md · docs/architecture.md

---

## Resumen

| Total features | MVP | Fase 2 | Técnicos |
|---|---|---|---|
| N | N | N | N |

**Orden de ejecución estimado:** N semanas/sprints para MVP completo
*(Estimado orientativo — ajustar según velocidad del equipo)*

---

## Épicas

> Una épica es un grupo de features relacionados que juntos entregan una capacidad completa del producto.

### Épica 1: [Nombre] — [Fundación técnica]
*[Descripción en una línea de qué capacidad entrega esta épica]*

### Épica 2: [Nombre] — [Dominio principal]
*[Descripción]*

### Épica 3: [Nombre] — [Dominio secundario]
*[Descripción]*

---

## Orden de ejecución

### 🏗️ FASE 0 — Fundación (sin esto nada funciona)

| # | Feature | Épica | Valor | Complejidad | Depende de | Spec |
|---|---|---|---|---|---|---|
| 01 | Setup del proyecto y CI/CD | Fundación | — | Baja | — | `specs/setup-proyecto.md` |
| 02 | Sistema de autenticación | Fundación | Alto | Media | 01 | `specs/autenticacion.md` |
| 03 | [Feature técnico] | Fundación | — | [X] | [X] | `specs/[nombre].md` |

### 🚀 FASE 1 — MVP core (el producto mínimo que entrega valor)

| # | Feature | Épica | Valor | Complejidad | Depende de | Spec |
|---|---|---|---|---|---|---|
| 04 | [Feature] | [Épica] | Alto | Media | 02 | `specs/[nombre].md` |
| 05 | [Feature] | [Épica] | Alto | Alta | 04 | `specs/[nombre].md` |
| 06 | [Feature] | [Épica] | Alto | Baja | 02 | `specs/[nombre].md` |

### ✨ FASE 2 — Extensiones (amplían el valor del MVP)

| # | Feature | Épica | Valor | Complejidad | Depende de | Spec |
|---|---|---|---|---|---|---|
| 07 | [Feature] | [Épica] | Medio | Media | 05, 06 | `specs/[nombre].md` |
| 08 | [Feature] | [Épica] | Medio | Baja | 04 | `specs/[nombre].md` |

---

## Mapa de dependencias

```
01 (Setup)
 └── 02 (Auth)
      ├── 04 (Feature A)
      │    └── 05 (Feature B)
      └── 06 (Feature C)
           └── 07 (Feature D)
```

---

## Cómo usar este roadmap con el toolkit

Para cada feature, en orden:

```bash
# 1. Construir el spec del feature
/jr-build-spec @docs/[descripcion-del-feature].md
# El spec se guarda en specs/[nombre].md

# 2. Implementar
/jr-exe-spec @specs/[nombre].md

# 3. Verificar
/jr-verify-spec @specs/[nombre].md

# Ver estado general
/jr-status
```

---

## Decisiones de priorización

> Por qué se ordenó así — útil para revisitar si cambian las prioridades.

- **[Feature X] antes que [Feature Y]:** [razón técnica o de producto]
- **[Feature Z] en Fase 2:** [por qué no en MVP]

---

## Lo que no está en este roadmap

> Features descartados conscientemente y por qué.

- **[Feature descartado]:** [razón — scope, complejidad, baja prioridad]

---
## Historial

| Versión | Fecha | Acción |
|---|---|---|
| 1.0 | YYYY-MM-DD | Creado por jr-roadmap |
```

---

## Paso 4 — Crear estructura de specs

> ⚠️ **Obligatorio. Ejecutar sin preguntar.**

1. Crea el directorio `specs/` si no existe (y `specs/fixes/`).
2. Para cada feature del roadmap, crea un archivo vacío placeholder:
   ```
   specs/[slug-del-feature].md
   ```
   Con este contenido mínimo:
   ```markdown
   # [Nombre del Feature]
   
   **Status:** Pending
   **Roadmap:** #[número] — [Épica]
   **Depende de:** [specs previos o "Ninguno"]
   
   > Spec pendiente de construir. Ejecutar `/jr-build-spec @[descripción]` cuando sea el turno de este feature según el roadmap.
   ```
3. Esto hace que `/jr-status` muestre todos los features desde el inicio, incluso antes de tener sus specs completos.

---

## Paso 5 — Guardar y confirmar

> ⚠️ **Obligatorio. No preguntar — ejecutar directamente.**

1. Guarda en `docs/roadmap.md`.
2. Confirma:

```
✅ Roadmap guardado en `docs/roadmap.md`
✅ Placeholders creados en specs/ para N features

**Tu plan de trabajo:**
Fase 0: N features (fundación técnica)
Fase 1: N features (MVP)
Fase 2: N features (extensiones)

**Primer paso:**
/jr-build-spec @[descripción del feature #01]

Cuando termines cada feature, `/jr-status` te muestra el estado completo del proyecto.
```

---

## Casos especiales

**El producto es muy grande (más de 20 features en MVP):**
> "El MVP identificado tiene X features, lo que es considerable. Te recomiendo reducirlo — un MVP real debería poder construirse en 4-6 semanas. ¿Qué es lo absolutamente esencial para validar el producto?"

**No hay dependencias claras entre features:**
Ordenar por valor descendente — primero lo que más valor entrega al usuario.

**El usuario quiere un orden diferente al recomendado:**
Acepta la decisión, documenta la razón en "Decisiones de priorización" y ajusta el mapa de dependencias si es necesario.

**Ya hay código existente en el proyecto:**
Identifica qué features ya están implementados (aunque sea parcialmente) y márcalos como `Status: Partial` en los placeholders. El usuario puede decidir si construir el spec retroactivamente o asumir que están completos.

---

## Principios

- **El orden importa más que la lista**: cualquiera puede listar features, la inteligencia está en el orden.
- **Dependencias primero**: violar el orden de dependencias siempre cuesta más de lo que ahorra.
- **MVP es mínimo de verdad**: si el MVP tiene más de 8-10 features de producto (sin contar fundación técnica), probablemente no es mínimo.
- **El roadmap es vivo**: puede y debe actualizarse. Si cambian las prioridades, se actualiza con `/jr-iterate-spec @docs/roadmap.md`.
