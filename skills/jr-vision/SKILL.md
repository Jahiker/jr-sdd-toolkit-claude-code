---
name: jr-vision
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-vision o tenga una idea de producto que quiera desarrollar desde cero. Se activa con frases como "tengo una idea", "quiero construir un producto", "nuevo proyecto", "quiero crear una app", "idea de negocio", "startup idea", o cuando se mencione /jr-vision. Recibe una descripción libre de la idea (puede ser un párrafo, notas desordenadas, o un archivo .md), hace preguntas para clarificar visión, usuarios, problema real y alcance, y produce un documento de visión del producto estructurado profesionalmente. Es el primer paso obligatorio para proyectos nuevos — sin visión clara no se puede definir arquitectura ni roadmap.
---

# jr-vision

Primer skill del flujo de inicio de proyecto. Transforma una idea en bruto en un documento de visión claro, honesto y accionable que sirve de base para todas las decisiones técnicas y de producto que vienen después.

**Posición en el flujo:**
```
idea → [jr-vision] → jr-arch → jr-roadmap → jr-build-spec → jr-exe-spec → jr-verify-spec
```

---

## Paso 0 — Validar input

El usuario puede invocar este skill de dos formas:

**Con archivo:**
```
/jr-vision @docs/mi-idea.md
```

**Con descripción directa en el chat:**
```
/jr-vision
Quiero construir una app que ayude a freelancers a gestionar sus clientes y facturas
```

Si no hay ningún input, pide:
> "Cuéntame tu idea. Puede ser un párrafo, notas desordenadas, o adjunta un archivo `.md`. No necesita estar pulida — para eso estamos aquí."

---

## Paso 1 — Leer y analizar la idea inicial

Lee lo que el usuario compartió y extrae:
- **Qué quiere construir** (el producto)
- **Para quién** (usuarios mencionados explícita o implícitamente)
- **Qué problema resuelve** (o si aún no está claro)
- **Qué ya mencionó sobre el scope** (grande, pequeño, MVP, etc.)
- **Qué tecnologías mencionó** (si las mencionó)

Haz un análisis interno antes de preguntar — no preguntes lo que ya está implícito en la idea.

---

## Paso 2 — Preguntas de clarificación

Formula **solo las preguntas necesarias** para completar la visión. Categorízalas:

### 🎯 Producto y problema
```
**P1.** [Pregunta sobre el problema real que resuelve]
**P2.** [Pregunta sobre qué lo diferencia de soluciones existentes]
```

### 👥 Usuarios
```
**U1.** [Pregunta sobre quién es el usuario principal]
**U2.** [Pregunta sobre contexto de uso si no está claro]
```

### 📐 Scope y alcance
```
**S1.** [Pregunta sobre MVP vs visión completa]
**S2.** [Pregunta sobre restricciones: tiempo, presupuesto, equipo]
```

### 💼 Negocio (solo si aplica)
```
**N1.** [Pregunta sobre modelo de negocio si es relevante para decisiones técnicas]
```

Indica:
> "No necesitas responder todo de una vez. Responde lo que puedas y construimos desde ahí."

---

## Paso 3 — Iteración

- Acepta respuestas parciales.
- Si quedan preguntas sin responder pero hay suficiente claridad para construir la visión, pregunta si avanzar.
- Lo que no esté definido se marca como `[Por definir]` en el documento.

---

## Paso 4 — Construir el documento de visión

```markdown
# Visión del Producto — [Nombre del Proyecto]

**Status:** Draft
**Fecha:** YYYY-MM-DD
**Autor:** jr-vision

---

## 1. Resumen en una línea
> [El producto] es [qué hace] para [quién] que [problema que resuelve].
> A diferencia de [alternativa actual], [diferenciador clave].

## 2. El problema
**Situación actual:** [Cómo resuelven esto hoy los usuarios — sin el producto]
**Por qué es un problema real:** [Impacto concreto del problema]
**Para quién es un problema:** [Perfil del usuario afectado]

## 3. La solución
**Qué hace el producto:** [Descripción funcional clara, sin tecnicismos]
**Qué NO hace:** [Límites explícitos — qué está fuera del scope]
**Por qué esta solución:** [Por qué este enfoque y no otro]

## 4. Usuarios

### Usuario principal
**Perfil:** [Descripción]
**Contexto de uso:** [Cuándo, dónde, con qué frecuencia lo usa]
**Objetivo principal:** [Qué quiere lograr]
**Frustraciones actuales:** [Con las alternativas existentes]

### Usuario(s) secundario(s) (si aplica)
**Perfil:** [Descripción]
**Relación con el producto:** [Cómo lo usa diferente al principal]

## 5. Propuesta de valor
> [2-3 oraciones que cualquier persona entendería, sin jerga técnica]

**Beneficios clave:**
- [Beneficio 1 — medible o perceptible]
- [Beneficio 2]
- [Beneficio 3]

## 6. Alcance

### MVP — Lo mínimo que entrega valor real
- [Feature esencial 1]
- [Feature esencial 2]
- [Feature esencial 3]

### Fase 2 — Extensiones naturales
- [Feature que amplía el valor del MVP]
- [Feature que amplía el valor del MVP]

### Fuera de scope (por ahora)
- [Lo que no se construye en ninguna de estas fases]
- [Lo que se descarta conscientemente]

## 7. Contexto de negocio

**Modelo:** [Freemium / SaaS / One-time / Open source / Interno / etc.]
**Monetización:** [Cómo genera valor económico, o "No aplica" si es interno]
**Restricciones conocidas:** [Tiempo, presupuesto, equipo, regulaciones]

## 8. Métricas de éxito
> ¿Cómo sabremos que el producto funciona?

- [Métrica 1: concreta y medible]
- [Métrica 2]
- [Métrica 3]

## 9. Riesgos y supuestos

| Supuesto | Riesgo si es falso | Prioridad de validación |
|---|---|---|
| [Los usuarios harán X] | [Consecuencia si no lo hacen] | Alta / Media / Baja |
| [La tecnología Y permite Z] | [Consecuencia técnica] | Alta / Media / Baja |

## 10. Preguntas pendientes
*(Eliminar si no hay)*
- **[Por definir]:** [Pregunta sin resolver que afecta decisiones futuras]

---
## Historial

| Versión | Fecha | Acción |
|---|---|---|
| 1.0 | YYYY-MM-DD | Creado por jr-vision |
```

**Principios de escritura:**
- Lenguaje claro, sin jerga técnica ni de startup.
- Honesto sobre lo que no está definido — `[Por definir]` es mejor que inventar.
- El MVP debe ser brutalmente mínimo — si parece pequeño, es probablemente del tamaño correcto.
- La sección "Fuera de scope" es tan importante como el scope — previene scope creep desde el día 1.

---

## Paso 5 — Guardar el documento

> ⚠️ **Obligatorio. No preguntar — ejecutar directamente.**

1. Crea el directorio `docs/` en la raíz del proyecto si no existe.
2. Guarda en `docs/vision.md`.
3. Confirma:

```
✅ Documento de visión guardado en `docs/vision.md`

**Próximo paso:**
Ejecuta `/jr-arch` para definir la arquitectura del sistema basada en esta visión.
```

---

## Casos especiales

**La idea es demasiado vaga para construir nada:**
No bloquees. Construye la visión con lo que hay, marca abundantemente con `[Por definir]`, y en las preguntas pendientes lista explícitamente qué debe resolverse antes de avanzar a arquitectura.

**La idea es demasiado grande (producto completo vs MVP):**
Señálalo claramente en la sección de Alcance y sé directo:
> "La visión completa que describes es grande. El MVP que propongo es [X]. ¿Estás de acuerdo o quieres ajustar qué entra en el MVP?"

**El usuario ya tiene claridad total y solo quiere el documento:**
Omite las preguntas y construye directamente el documento con la información provista. No hagas preguntas innecesarias si la idea ya está bien definida.

**Es un proyecto interno (no producto de usuario final):**
Adapta las secciones: "usuarios" se convierte en "equipos o sistemas que lo usan", "modelo de negocio" se convierte en "valor para la organización". La estructura se mantiene.
