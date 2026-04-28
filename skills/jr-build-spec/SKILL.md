---
name: jr-build-spec
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-build-spec o cuando reciba un archivo .md con una especificación, historia de usuario, o requerimiento poco pulido que necesite ser analizado, refinado y documentado como un spec profesional. Se activa con frases como "construir spec", "refinar requerimiento", "analizar historia de usuario", "crear especificación técnica", o cuando se mencione /jr-build-spec. Requiere un archivo .md como input; si no se provee, debe solicitarlo. El skill analiza el contexto del proyecto, detecta solapamientos con specs existentes, categoriza preguntas para cliente y dev, advierte si el scope es demasiado grande, espera respuestas iterativas y produce un spec profesional estilo arquitecto Silicon Valley en el directorio specs/.
---

# jr-build-spec

Skill para transformar requerimientos crudos o historias de usuario poco pulidas en especificaciones técnicas profesionales, listas para ser trabajadas por un equipo de desarrollo.

---

## Paso 0 — Validar input

Si el usuario ejecutó `/jr-build-spec` **sin adjuntar un archivo `.md`**, responde:

> "Para ejecutar `/jr-build-spec` necesito el archivo `.md` con el requerimiento o historia de usuario. Por favor compártelo así: `/jr-build-spec @ruta/al/archivo.md`"

No continúes hasta tener el archivo.

---

## Paso 1 — Leer, entender y escanear contexto

1. Lee el archivo `.md` recibido completamente.
2. Escanea el proyecto para entender contexto:
   - Detecta si existe `specs/` (si no, se creará al final)
   - Busca archivos de configuración (`package.json`, `composer.json`, `pyproject.toml`, `Makefile`, `README.md`, etc.) para identificar stack y arquitectura
   - Convenciones del proyecto: estructura de carpetas, naming, patrones existentes
3. Formula tu análisis inicial: ¿Qué se está pidiendo? ¿Qué está claro? ¿Qué es ambiguo?

---

## Paso 2 — Detección de solapamientos con specs existentes

Si existe el directorio `specs/`, lee **todos los specs existentes** (al menos sus secciones de Resumen Ejecutivo y Requerimientos Funcionales).

Luego evalúa:

- ¿Hay specs que cubran funcionalidad **igual o muy similar** al nuevo requerimiento?
- ¿Hay specs que el nuevo requerimiento **extiende o modifica**?
- ¿Hay specs que el nuevo requerimiento **podría romper o contradecir**?
- ¿Hay specs que deberían ejecutarse **antes** de este (dependencias)?

Si encuentras algo relevante, repórtalo **antes** de hacer cualquier pregunta:

```
## 🔍 Specs relacionados encontrados

| Spec | Relación | Impacto |
|---|---|---|
| `specs/autenticacion.md` | Este spec extiende el flujo de login | Revisar sección 7 antes de continuar |
| `specs/perfil-usuario.md` | Solapamiento en manejo de avatar | Podría duplicar lógica |

> ⚠️ Considera si este nuevo spec debería ser una iteración de uno existente en lugar de uno nuevo.
> ¿Quieres continuar como spec nuevo o prefieres que lo integremos a uno existente?
```

Espera decisión del usuario antes de continuar.

---

## Paso 3 — Evaluación de scope

Antes de formular preguntas, evalúa la magnitud del requerimiento:

**Señales de scope excesivo:**
- Menciona más de 3 módulos distintos del sistema
- Involucra cambios en base de datos + API + UI + integraciones externas simultáneamente
- El requerimiento tiene múltiples "fases" o "etapas" implícitas
- Requeriría más de ~5 días de trabajo para un dev solo

Si detectas scope excesivo, advierte:

```
## ⚠️ Scope Detection

Este requerimiento parece abarcar múltiples features independientes:
- [Feature A detectado]
- [Feature B detectado]
- [Feature C detectado]

Recomiendo dividirlo en specs separados ejecutables incrementalmente.
¿Quieres que lo divida ahora, o prefieres continuar como un spec único?
```

Respeta la decisión del usuario. Si elige continuar como uno solo, documenta la advertencia en el spec final.

---

## Paso 4 — Categorizar y formular preguntas

Con base en el análisis, genera **dos listas de preguntas**:

#### 🙋 Preguntas para el Cliente / Product Owner
Dudas de negocio, alcance, prioridades, comportamiento esperado, usuarios finales, restricciones comerciales.

```
**C1.** [Pregunta concreta enfocada en negocio]
**C2.** [Pregunta concreta enfocada en negocio]
```

#### 🛠️ Preguntas para el Dev / Arquitecto
Dudas técnicas: integraciones, dependencias, limitaciones del sistema, decisiones de diseño, compatibilidad.

```
**D1.** [Pregunta técnica concreta]
**D2.** [Pregunta técnica concreta]
```

Indica al final:
> "No es necesario responder todas a la vez. Responde las que puedas ahora y continuamos desde ahí."

---

## Paso 5 — Iteración de preguntas y respuestas

- El usuario puede responder parcialmente.
- Marca internamente las preguntas resueltas.
- Si quedan preguntas sin responder pero hay suficiente información, pregunta:
  > "¿Quieres que avance con la información actual y dejemos las pendientes como `[PENDING]` en el spec?"
- Acepta la decisión y continúa.

---

## Paso 6 — Construir el Spec

Genera el spec con esta estructura:

```markdown
# [Nombre del Feature / Requerimiento]

**Status:** Draft
**Versión:** 1.0
**Fecha:** YYYY-MM-DD
**Autor:** jr-build-spec
**Specs relacionados:** [lista de specs relacionados detectados en Paso 2, o "Ninguno"]
**Advertencia de scope:** [si aplica, o eliminar esta línea]

---

## 1. Resumen Ejecutivo
2-3 oraciones: qué es, por qué importa, cuál es el resultado esperado.

## 2. Contexto y Motivación
- Problema que resuelve
- Usuario(s) afectado(s)
- Impacto en el negocio

## 3. Objetivos
- [ ] Objetivo 1
- [ ] Objetivo 2

## 4. Fuera de Scope
- Lo que explícitamente NO incluye este spec

## 5. Requerimientos Funcionales

### RF-01: [Nombre]
**Descripción:** ...
**Criterios de Aceptación:**
- [ ] CA-01: ...
- [ ] CA-02: ...

### RF-02: [Nombre]
...

## 6. Requerimientos No Funcionales
- **Performance:** ...
- **Seguridad:** ...
- **Escalabilidad:** ...
- **Compatibilidad:** ...

## 7. Diseño Técnico

### Arquitectura
[Descripción de cómo encaja en el sistema actual]

### Componentes Involucrados
| Componente | Rol | Cambios requeridos |
|---|---|---|
| ... | ... | ... |

### Flujo de Datos
[Descripción del flujo principal o pseudocódigo si aplica]

### Consideraciones de Base de Datos
[Cambios en esquema, nuevas tablas, índices, etc. Si no aplica: "Sin cambios en BD"]

### APIs / Integraciones
[Endpoints nuevos o modificados, contratos, payloads. Si no aplica: "Sin cambios en API"]

## 8. Casos Borde y Manejo de Errores
- **Caso:** [descripción] → **Comportamiento esperado:** [respuesta]

## 9. Dependencias
- **Specs que deben ejecutarse antes:** [lista o "Ninguno"]
- **Internas:** [otros módulos, servicios]
- **Externas:** [librerías, APIs de terceros]
- **Bloqueadores:** [lo que debe estar listo antes de empezar]

## 10. Preguntas Pendientes
> Deben resolverse antes de comenzar desarrollo o ejecución del spec.

- **[PENDING-C1]:** [pregunta del cliente sin resolver]
- **[PENDING-D1]:** [pregunta técnica sin resolver]

*(Eliminar esta sección si no hay pendientes)*

## 11. Notas Adicionales
[Contexto extra, referencias, links relevantes]

---
## Historial

| Versión | Fecha | Acción | Notas |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | Creado | Generado por jr-build-spec |
```

**Reglas de escritura:**
- Lenguaje técnico preciso, sin redundancias.
- Lo no definido va como `[TBD]` o `[PENDING]`.
- Cada RF debe tener al menos un CA verificable y testeable.
- El spec debe poder ser leído por un dev nuevo sin contexto previo.
- La sección "Specs relacionados" del encabezado siempre se completa (aunque sea "Ninguno").

---

## Paso 7 — Guardar el Spec

> ⚠️ **Este paso es obligatorio y no negociable. El skill NO termina hasta que el archivo exista físicamente en disco. No preguntes, no pidas confirmación — ejecuta directamente.**

1. **Crea el directorio `specs/`** en la raíz del proyecto si no existe. Hazlo sin preguntar.
2. **Determina el nombre del archivo:** `specs/[slug-del-feature].md`
   - kebab-case, minúsculas, sin tildes ni caracteres especiales.
   - Ejemplo: `specs/sistema-de-notificaciones-push.md`
3. **Escribe el archivo** con todo el contenido del spec generado. Si el archivo ya existe, sobreescríbelo sin pedir confirmación.
4. **Verifica** que el archivo fue creado correctamente antes de continuar.
5. **Confirma al usuario:**
   > "✅ Spec guardado en `specs/[nombre].md`
   >
   > Próximos pasos:
   > - Revisa y ajusta el spec si algo no quedó bien
   > - Cuando esté listo, ejecuta: `/jr-exe-spec @specs/[nombre].md`
   > - Al finalizar la implementación: `/jr-verify-spec @specs/[nombre].md`"

**Si por alguna razón no puedes escribir el archivo** (permisos, ruta inválida), repórtalo con el error exacto y muestra el contenido del spec en el chat para que el usuario pueda guardarlo manualmente.

---

## Principios de Calidad

- **Claridad sobre brevedad**: mejor largo y completo que corto y ambiguo.
- **Verificabilidad**: cada requerimiento debe poder ser testeado.
- **Trazabilidad**: conecta decisiones con su motivación, y specs entre sí.
- **Honestidad**: lo que no está claro se marca como pendiente, no se inventa.
- **Scope consciente**: un spec bien acotado es mejor que uno que intenta hacer todo.
- **Contexto-aware**: el spec refleja las convenciones y stack del proyecto.
