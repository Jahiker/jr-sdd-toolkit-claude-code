---
name: jr-iterate-spec
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-iterate-spec o quiera iterar, extender, modificar o mejorar un spec que ya existe (en cualquier status: Draft, Implemented o Verified). Se activa con frases como "iterar el spec", "agregar al spec", "modificar el spec", "el spec necesita un cambio", "nueva versión del spec", "extender el feature", o cuando se mencione /jr-iterate-spec. Recibe el spec existente como base y el nuevo requerimiento o cambio solicitado, evalúa el impacto sobre RFs y archivos existentes, versiona el spec semánticamente (patch para mejoras pequeñas, minor para cambios estructurales) y produce el spec iterado listo para ejecutar con jr-exe-spec. NO crea un spec nuevo — versiona el existente.
---

# jr-iterate-spec

Skill para iterar sobre specs existentes. Recibe un spec base ya documentado (en cualquier status) y un nuevo requerimiento o cambio, evalúa el impacto, versiona semánticamente y produce el spec actualizado con un delta claro de qué cambia respecto a la versión anterior.

---

## Paso 0 — Validar input

El usuario debe proveer **dos cosas**:
1. El spec existente: `@specs/nombre-del-spec.md`
2. El nuevo requerimiento o cambio (puede ser texto en el chat o un archivo `.md`)

Si falta alguno, solicítalo:

> "Para iterar necesito dos cosas:
> 1. El spec existente: `/jr-iterate-spec @specs/nombre.md`
> 2. El cambio o nuevo requerimiento que quieres incorporar (descríbelo o comparte un archivo)"

No continúes hasta tener ambos.

---

## Paso 1 — Leer el spec base

1. Lee el spec existente completo.
2. Registra internamente:
   - Versión actual (ej: `1.0`, `1.1`, `2.0`)
   - Status actual (`Draft`, `Implemented`, `Verified`)
   - Todos los RFs existentes con sus CAs
   - Sección `Archivos Afectados` si existe
   - Historial de versiones
3. Si el status es `Implemented` o `Verified`, toma nota — el delta deberá ser muy consciente de no romper lo ya implementado.

---

## Paso 2 — Analizar el cambio solicitado

Lee el nuevo requerimiento y determina:

**Tipo de cambio** (esto define el versionado):

| Tipo | Ejemplos | Versión |
|---|---|---|
| **Patch** | Agregar un CA a un RF existente, corregir redacción, aclarar un edge case, agregar un RNF, pequeña extensión de comportamiento | `1.0 → 1.1` |
| **Minor** | Agregar uno o más RFs nuevos, modificar el flujo principal, cambiar diseño técnico significativamente, agregar integraciones nuevas, cambiar el modelo de datos | `1.0 → 2.0` |

Anuncia tu evaluación antes de continuar:

```
## 📊 Análisis del cambio

**Tipo detectado:** Patch / Minor
**Versión actual:** X.X → **Nueva versión:** X.X

**Impacto:**
- RFs que se modifican: [lista o "Ninguno"]
- RFs que se agregan: [lista o "Ninguno"]
- RFs que se eliminan: [lista o "Ninguno"]
- Archivos ya implementados que se verían afectados: [lista o "Desconocido si no hay sección Archivos Afectados"]

¿Confirmas que el tipo de cambio es correcto, o quieres ajustarlo?
```

Espera confirmación antes de continuar.

---

## Paso 3 — Detección de conflictos

Antes de construir el spec iterado, evalúa:

- ¿El cambio contradice algún RF existente?
- ¿El cambio modifica comportamiento ya implementado de forma que podría romperlo?
- ¿El cambio tiene dependencias con otros specs que no están implementados?
- ¿El cambio está fuera del scope original del spec? (si es así, ¿no debería ser un spec nuevo?)

Si detectas conflictos o riesgos, repórtalos:

```
## ⚠️ Conflictos detectados

- **RF-02 CA-03** define que X, pero el nuevo cambio define lo contrario. ¿Cuál prevalece?
- El cambio modifica `src/services/feature.ts` que ya está implementado — riesgo de regresión.

¿Cómo quieres resolver esto antes de continuar?
```

Si el cambio es tan grande que claramente debería ser un spec separado, sugiérelo:
> "Este cambio introduce un dominio completamente nuevo. ¿No sería mejor un spec separado que extienda este como dependencia?"

Respeta la decisión del usuario.

---

## Paso 4 — Formular preguntas (solo si hay ambigüedades)

Si el nuevo requerimiento tiene ambigüedades que impiden escribir CAs verificables, formula preguntas categorizadas igual que `jr-build-spec`:

**🙋 Preguntas para el Cliente:**
```
**C1.** [Pregunta de negocio]
```

**🛠️ Preguntas para el Dev:**
```
**D1.** [Pregunta técnica]
```

Si el cambio está suficientemente claro, omite este paso y avanza directamente.

---

## Paso 5 — Construir el spec iterado

Toma el spec base y aplica los cambios. El spec resultante debe ser **el spec completo** (no solo el delta), con estas modificaciones:

**En el encabezado:**
```markdown
**Versión:** [nueva versión]
**Fecha:** YYYY-MM-DD
**Status:** Draft
```
> Si el spec estaba `Implemented` o `Verified`, el status vuelve a `Draft` porque hay cambios pendientes de ejecutar.

**En los RFs:**
- RFs sin cambios: se mantienen idénticos, sin marcas adicionales.
- RFs modificados: agregar al final del RF una nota `> 🔄 Modificado en v[X.X]: [descripción del cambio en una línea]`
- RFs nuevos: agregar con el siguiente número disponible (RF-03, RF-04...) con nota `> ✨ Nuevo en v[X.X]`
- RFs eliminados: si aplica, moverlos a la sección **Fuera de Scope** con nota `> ~~RF-XX eliminado en v[X.X]: [motivo]~~`

**En Diseño Técnico:**
Actualizar solo las subsecciones afectadas. Agregar nota al inicio de cada subsección modificada:
`> 🔄 Actualizado en v[X.X]`

**En Archivos Afectados** (si existe):
Agregar los nuevos archivos que el delta introducirá, marcados como `[PENDIENTE]` hasta que se ejecute.

**Agregar sección Delta** (justo antes del Historial):

```markdown
## Delta v[X.X] — Resumen de cambios

### Qué cambia respecto a v[X anterior]
- [Cambio 1 en una línea]
- [Cambio 2 en una línea]

### Qué NO cambia
- [Lo que permanece igual y es relevante aclararlo]

### Riesgo de regresión
- [Archivos ya implementados que podrían verse afectados, o "Bajo — sin impacto en código existente"]
```

**En Historial:**
```markdown
| [nueva versión] | YYYY-MM-DD | Iterado | jr-iterate-spec — [descripción del cambio en una línea] |
```

---

## Paso 6 — Guardar el spec iterado

> ⚠️ **Obligatorio y no negociable. El skill NO termina hasta que el archivo exista en disco. Ejecutar sin pedir confirmación.**

1. **Sobreescribe** el archivo existente `specs/nombre-del-spec.md` con el spec iterado completo.
2. **Verifica** que el archivo fue escrito correctamente.
3. **Confirma:**

```
✅ Spec iterado guardado en `specs/[nombre].md` (v[anterior] → v[nueva])

### Resumen del delta
- [Cambio 1]
- [Cambio 2]

### Próximos pasos
- Revisa el spec y ajusta si algo no quedó bien
- Ejecuta el delta: `/jr-exe-spec @specs/[nombre].md`
- Después de implementar: `/jr-verify-spec @specs/[nombre].md`
```

---

## Principios

- **El spec es la fuente de verdad**: si algo no está en el spec, no existe. El delta debe ser explícito.
- **No romper lo que funciona**: el impacto sobre código ya implementado siempre se documenta.
- **Versionar, no reescribir**: el historial del spec es valioso — se preserva siempre.
- **Scope consciente**: si el cambio es tan grande que desvirtúa el spec original, es mejor un spec nuevo con dependencia.
