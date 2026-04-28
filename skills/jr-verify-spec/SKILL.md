---
name: jr-verify-spec
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-verify-spec o cuando quiera verificar que la implementación de un spec cubre sus criterios de aceptación. Se activa con frases como "verificar el spec", "revisar criterios de aceptación", "checar qué se implementó", "validar el spec", "auditar implementación", o cuando se mencione /jr-verify-spec. Recibe un archivo spec .md (implementado por jr-exe-spec), recorre los archivos afectados, evalúa cobertura de cada criterio de aceptación, detecta gaps, genera un reporte de cobertura y actualiza el historial del spec. Actúa como QA del ciclo spec-driven: cierra el loop entre lo que se pidió y lo que se entregó.
---

# jr-verify-spec

Skill de verificación post-implementación. Cierra el loop del ciclo spec-driven: lee el spec implementado, recorre el código producido, evalúa criterio por criterio, detecta gaps y genera un reporte de cobertura trazable.

No reemplaza los tests automatizados — los complementa. Su rol es dar visibilidad explícita entre lo que el spec prometía y lo que el código realmente entrega.

---

## Paso 0 — Validar input

Si el usuario ejecutó `/jr-verify-spec` **sin adjuntar un archivo `.md`**, responde:

> "Para ejecutar `/jr-verify-spec` necesito el spec. Compártelo así: `/jr-verify-spec @specs/nombre-del-spec.md`"

No continúes hasta tener el archivo.

---

## Paso 1 — Leer el spec y preparar la auditoría

1. Lee el spec `.md` completo.
2. Verifica el status:
   - Si `Status: Draft` → advierte: "Este spec aún no fue implementado (Status: Draft). ¿Quieres verificar de todas formas lo que haya en el código?"
   - Si `Status: Implemented` → continúa normalmente.
3. Extrae y lista internamente todos los elementos verificables:
   - Cada **Criterio de Aceptación** (CA-XX) de cada Requerimiento Funcional
   - Cada **Requerimiento No Funcional** que sea verificable en código (performance, seguridad, compatibilidad)
   - Cada ítem de la sección **Archivos Afectados** (si existe)
4. Confirma al usuario:
   > "Voy a auditar **X criterios de aceptación** y **Y requerimientos no funcionales** del spec `specs/[nombre].md`. Revisaré el código en busca de evidencia de cobertura."

---

## Paso 2 — Recorrer el código

Para cada archivo listado en `## Archivos Afectados` del spec (o mencionado en el Diseño Técnico si la sección no existe):

1. Abre y lee el archivo.
2. Busca el comentario de trazabilidad: `// spec: specs/nombre.md` (o equivalente en el lenguaje).
3. Identifica qué lógica implementa y a cuáles CAs podría dar cobertura.

Si no hay sección `## Archivos Afectados` en el spec, infiere los archivos a partir del Diseño Técnico (sección Componentes Involucrados) y del rastreo por el directorio del proyecto.

---

## Paso 3 — Evaluar cobertura por criterio

Para cada CA, determina uno de estos estados:

| Estado | Descripción |
|---|---|
| ✅ **CUBIERTO** | Hay código que implementa claramente este criterio |
| ⚠️ **PARCIAL** | Hay implementación pero incompleta o con condiciones no manejadas |
| ❌ **AUSENTE** | No se encontró evidencia de implementación en el código |
| 🔍 **NO VERIFICABLE EN CÓDIGO** | El criterio requiere prueba en runtime (ej: "responde en < 200ms") |

Para los marcados como PARCIAL o AUSENTE, registra:
- En qué archivo se esperaba la implementación
- Qué parte específica falta
- Sugerencia concreta de qué agregar o corregir

---

## Paso 4 — Generar el Reporte de Cobertura

```markdown
## 🔍 Reporte de Verificación — [Nombre del Feature]

**Spec:** specs/nombre-del-spec.md
**Fecha de verificación:** YYYY-MM-DD
**Verificado por:** jr-verify-spec

### Resumen
| Total CAs | ✅ Cubiertos | ⚠️ Parciales | ❌ Ausentes | 🔍 No verificables en código |
|---|---|---|---|---|
| X | X | X | X | X |

**Cobertura:** X% (cubiertos / verificables en código)

---

### Detalle por Requerimiento Funcional

#### RF-01: [Nombre]
| CA | Estado | Evidencia / Gap |
|---|---|---|
| CA-01 | ✅ CUBIERTO | `src/services/feature.ts:45` — función `handleX` implementa el flujo completo |
| CA-02 | ⚠️ PARCIAL | `src/components/Form.tsx:12` — valida el campo pero no maneja el caso de valor vacío |
| CA-03 | ❌ AUSENTE | No se encontró lógica de notificación en ningún archivo afectado |

#### RF-02: [Nombre]
...

---

### Requerimientos No Funcionales
| RNF | Estado | Notas |
|---|---|---|
| Performance: respuesta < 200ms | 🔍 NO VERIFICABLE EN CÓDIGO | Requiere prueba en runtime con datos reales |
| Seguridad: inputs sanitizados | ✅ CUBIERTO | `sanitizeInput()` aplicado en todos los handlers del spec |

---

### Gaps Prioritarios
> Ordenados por impacto. Deben resolverse antes de considerar el feature completo.

**GAP-01 — [CA-03 de RF-01]: Ausencia de lógica de notificación**
- **Impacto:** Alto — el criterio es parte del flujo principal
- **Dónde agregar:** `src/services/notification.ts` (o crear si no existe)
- **Qué implementar:** [descripción concreta de lo que falta]

**GAP-02 — [CA-02 de RF-01]: Caso de valor vacío no manejado**
- **Impacto:** Medio — edge case que puede producir errores silenciosos
- **Dónde corregir:** `src/components/Form.tsx:12`
- **Qué agregar:** validación de string vacío antes del submit

---

### Trazabilidad
- Archivos con comentario `spec:` encontrados: [lista]
- Archivos sin comentario `spec:` pero relacionados: [lista, si aplica]

---

### Conclusión
[Una de estas tres:]

**✅ Spec completamente cubierto** — Todos los criterios verificables en código están implementados. El feature puede considerarse listo para QA/testing.

**⚠️ Spec parcialmente cubierto** — X gaps encontrados. Se recomienda resolver los gaps prioritarios antes de pasar a QA.

**❌ Spec con gaps críticos** — Criterios del flujo principal sin implementar. Se recomienda volver a `/jr-exe-spec` para completar la implementación.
```

---

## Paso 5 — Actualizar el spec

Abre `specs/nombre-del-spec.md` y agrega entrada en `## Historial`:

```markdown
| [versión] | YYYY-MM-DD | Verificado | jr-verify-spec — Cobertura: X% · Gaps: Y |
```

Si la cobertura es 100% (todos los CAs verificables están cubiertos), cambia:
`**Status:** Implemented` → `**Status:** Verified`

Si hay gaps, el status permanece en `Implemented` hasta que se corrijan y se vuelva a verificar.

---

## Comportamiento ante casos especiales

**Spec sin sección `Archivos Afectados`:**
Infiere los archivos desde la sección `Diseño Técnico > Componentes Involucrados`. Si tampoco existe, busca en el proyecto archivos que contengan el comentario `// spec: specs/nombre.md`. Informa al usuario qué archivos revisaste.

**Archivo listado en el spec que no existe en el proyecto:**
Márcalo como `❌ AUSENTE` y regístralo como gap crítico.

**Spec con muchos CAs (más de 20):**
Agrupa por RF y presenta el reporte por secciones. No omitas ningún CA, solo organiza mejor la presentación.

**El usuario solo quiere verificar un RF específico:**
Acepta: "Verificaré solo RF-02". Ejecuta el mismo flujo pero acotado al RF solicitado. Nota en el reporte que la verificación fue parcial.

---

## Principios

- **No asumas, verifica**: un criterio está cubierto solo si hay código que lo implemente, no si "parece que debería estar".
- **Sé específico en los gaps**: "falta la validación" no es útil. "Falta validar `email !== ''` en `Form.tsx:23` antes de llamar a `submitForm()`" sí lo es.
- **No bloquees el flujo**: el reporte es informativo. El usuario decide si corregir antes de continuar o documentar la deuda técnica.
- **Cierra el loop**: el valor de este skill es hacer explícito lo que el spec prometió vs lo que el código entrega. Esa brecha, visible y documentada, es más valiosa que ignorarla.
