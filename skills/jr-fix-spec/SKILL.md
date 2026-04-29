---
name: jr-fix-spec
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-fix-spec o reporte un bug que necesite ser diagnosticado, documentado y corregido. Se activa con frases como "hay un bug en", "esto está fallando", "fix este error", "corregir comportamiento", "el feature no funciona como esperaba", o cuando se mencione /jr-fix-spec. Recibe un archivo .md con la descripción breve del bug (ubicado en specs/fixes/), diagnostica el root cause, construye un fix plan quirúrgico, ejecuta solo los cambios necesarios con trazabilidad, verifica regresión en archivos adyacentes, y actualiza el spec original si existe. Funciona tanto si hay un spec de feature relacionado como si el bug es en código legacy sin spec.
---

# jr-fix-spec

Skill para diagnosticar, documentar y corregir bugs de forma estructurada. Recibe una descripción breve del bug, construye un diagnóstico completo, ejecuta el fix mínimo necesario y deja trazabilidad completa del problema y su solución.

El principio central: **tocar lo mínimo posible para corregir lo máximo posible.**

---

## Paso 0 — Validar input

El usuario debe proveer un archivo `.md` con la descripción del bug:

```
/jr-fix-spec @specs/fixes/nombre-del-bug.md
```

Si no existe el archivo o no se adjuntó:
> "Necesito el archivo con la descripción del bug. Créalo en `specs/fixes/nombre-del-bug.md` con una descripción breve de qué está fallando y dónde, luego ejecuta `/jr-fix-spec @specs/fixes/nombre-del-bug.md`"

Si no existe el directorio `specs/fixes/`, créalo sin preguntar.

---

## Paso 1 — Leer el reporte del bug

Lee el archivo `.md` del bug y extrae:
- **Comportamiento actual:** qué está pasando
- **Comportamiento esperado:** qué debería pasar
- **Dónde ocurre:** archivo(s), componente(s), ruta(s) mencionadas
- **Condiciones de reproducción:** si se mencionan

---

## Paso 2 — Buscar spec relacionado

Busca en `specs/` si existe un spec que cubra el área afectada:

**Si existe spec relacionado:**
- Léelo completo
- Identifica el CA (criterio de aceptación) que este bug viola
- Registra: `Viola CA-XX del RF-XX: [descripción]`

**Si NO existe spec relacionado (código legacy o preexistente):**
- Documéntalo: `Bug en código sin spec asociado`
- Escanea los archivos mencionados en el reporte para entender el comportamiento esperado desde el código mismo
- Infiere el comportamiento correcto desde la lógica existente, nombres de funciones, comentarios, o contexto del proyecto

Anuncia al usuario cuál caso aplica antes de continuar.

---

## Paso 3 — Diagnóstico

Analiza el código en los archivos reportados (y los relacionados) para:

1. **Confirmar** que el bug existe donde se reportó
2. **Identificar el root cause** — la causa real, no el síntoma
3. **Mapear el impacto** — qué otros archivos o flujos podrían verse afectados por el fix

Presenta el diagnóstico antes de continuar:

```
## 🔍 Diagnóstico

**Bug confirmado:** Sí / No (si no, explicar qué se encontró)
**Root cause:** [descripción técnica precisa de por qué falla]
**Ubicación exacta:** `archivo.ts:línea` — [qué hay ahí]
**CA violado:** CA-XX de RF-XX — [descripción] / No aplica (sin spec)
**Impacto potencial del fix:** [archivos que podrían verse afectados al corregir]

¿Confirmas que el diagnóstico es correcto? Responde **"sí"** para continuar con el fix plan.
```

Espera confirmación antes de continuar.

---

## Paso 4 — Fix Plan

Genera un plan quirúrgico — **solo los cambios estrictamente necesarios**:

```
## 🔧 Fix Plan — [Nombre del Bug]

**Archivos a modificar:** X
**Archivos a verificar (regresión):** Y
**Estrategia:** [descripción en una línea de cómo se corrige]

---

### Cambios
  - [ ] 1. [Acción concreta] → `ruta/archivo.ext:línea` [QUÉ CAMBIAR]
  - [ ] 2. [Acción concreta si aplica] → `ruta/archivo.ext` [QUÉ CAMBIAR]

### Verificación de regresión
  - [ ] R1. Verificar que `[flujo adyacente]` sigue funcionando en `archivo.ext`
  - [ ] R2. Verificar que `[otro flujo]` no se ve afectado

---
> ¿Apruebas este fix plan? Responde **"sí"** para ejecutar.
```

**Reglas del fix plan:**
- Máximo de cambios posible en el menor número de archivos posible.
- Si el fix requiere tocar más de 5 archivos, pausar y preguntar: ¿esto es realmente un fix o es una iteración del feature?
- No refactorizar código adyacente aunque "se vea feo" — eso va en una iteración separada.
- No agregar funcionalidad nueva — solo corregir el comportamiento roto.

---

## Paso 5 — Esperar aprobación

No ejecutar nada hasta recibir confirmación explícita del usuario. Si pide ajustes al plan, modificar y volver a presentar.

---

## Paso 6 — Ejecutar el fix

Por cada cambio del plan:

1. **Anuncia:** `▶ 1. Corrigiendo \`src/components/Form.tsx:47\`...`
2. **Ejecuta** el cambio mínimo necesario.
3. **Agrega trazabilidad** en el bloque corregido:
   ```
   // fix: specs/fixes/nombre-del-bug.md — [descripción en una línea]
   ```
4. **Confirma:** `✓ 1. Completado`

**Si encuentra algo inesperado durante la ejecución**, pausa:
> "⚠️ Al corregir `archivo.ts:47` encontré que [situación inesperada]. Opciones: [A] / [B]. ¿Cuál prefieres?"

---

## Paso 7 — Verificación de regresión

Para cada ítem de verificación del plan:

1. Lee los archivos adyacentes mencionados.
2. Evalúa si el fix podría haberlos afectado.
3. Reporta:
   - ✅ `[flujo]` — sin impacto detectado
   - ⚠️ `[flujo]` — revisar manualmente: [qué verificar y dónde]

---

## Paso 8 — Actualizar documentación

### Si existe spec relacionado:

Abre `specs/[nombre-del-spec].md` y aplica:

1. En el RF afectado, agrega el caso borde como CA nuevo:
   ```markdown
   - [ ] CA-XX: [descripción del caso borde que el bug exponía] *(agregado en hotfix YYYY-MM-DD)*
   ```

2. Agrega entrada en `## Historial`:
   ```markdown
   | [versión] | YYYY-MM-DD | Hotfix | jr-fix-spec — [descripción del bug en una línea] |
   ```

3. **No cambia el Status ni la versión del spec** — un hotfix no es una iteración.

### Si NO existe spec relacionado:

Actualiza el archivo del bug report `specs/fixes/nombre-del-bug.md` con el diagnóstico y la solución aplicada:

```markdown
# Fix: [Nombre del Bug]

**Status:** Resolved
**Fecha:** YYYY-MM-DD
**Archivos afectados:** [lista]

## Descripción original
[lo que el usuario reportó]

## Root cause
[diagnóstico encontrado]

## Solución aplicada
[descripción de qué se cambió y por qué]

## Archivos modificados
| Archivo | Cambio |
|---|---|
| `ruta/archivo.ext` | [descripción del cambio] |

## Verificación de regresión
[resultado de la verificación]
```

---

## Paso 9 — Reporte final

```
## ✅ Fix Completado — [Nombre del Bug]

**Root cause resuelto:** [descripción en una línea]
**Archivos modificados:** X
**CA violado corregido:** CA-XX de RF-XX / No aplica

### Cambios aplicados
| Archivo | Línea(s) | Cambio |
|---|---|---|
| `ruta/archivo.ext` | 47 | [qué se corrigió] |

### Regresión
| Flujo | Estado |
|---|---|
| [flujo verificado] | ✅ Sin impacto |
| [flujo a revisar] | ⚠️ Verificar manualmente |

### Cómo confirmar el fix
1. [Paso concreto para reproducir el bug y verificar que ya no ocurre]

### Documentación actualizada
- [spec relacionado actualizado con CA nuevo] / [fix report guardado en specs/fixes/]
```

---

## Casos especiales

**El bug no se puede reproducir desde el código:**
> "No encontré evidencia del bug en `[archivo]`. Posiblemente sea un problema de estado en runtime, datos específicos, o condición de carrera. ¿Puedes darme más contexto sobre cómo reproducirlo?"

**El fix requiere un cambio mayor (más de 5 archivos):**
> "Este bug tiene un root cause más profundo que requiere cambios en X archivos. Esto se acerca más a una iteración del feature que a un hotfix. ¿Prefieres hacer un `/jr-iterate-spec` o continuar con el fix extendido?"

**Hay múltiples bugs en el reporte:**
Sepáralos explícitamente y pregunta:
> "Detecto 2 bugs distintos en el reporte. ¿Los resuelvo en un solo fix o prefieres reportes separados para cada uno?"

**El fix expone un problema de diseño más grande:**
Documéntalo sin resolverlo:
> "El fix está aplicado, pero el root cause expone un problema de diseño en [área]. Considera crear un spec para refactorizarlo. Lo documento en las notas del fix report."

---

## Principios

- **Mínimo cambio, máximo impacto**: un fix que toca 1 línea es mejor que uno que toca 10 si resuelve el problema.
- **No mezclar fix con mejoras**: si durante el fix ves algo que mejorar, documéntalo como deuda técnica, no lo corrijas en el mismo PR.
- **Trazabilidad siempre**: cada línea corregida debe saber por qué fue corregida.
- **Regresión no es opcional**: un fix que rompe otra cosa no es un fix.
- **Honesto sobre el root cause**: si no se puede determinar con certeza, se documenta la hipótesis como hipótesis.
