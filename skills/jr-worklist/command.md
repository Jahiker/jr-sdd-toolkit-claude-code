---
description: Turn a QA document or feedback list into a tracked worklist, worked one item at a time
model: sonnet
tools: Read, Write, Edit, Glob, Grep
---

# /jr-worklist

Convierte un documento de QA (o cualquier lista de feedback/mejoras) en una worklist trackeada y trabájala **punto por punto**. Ningún item arranca hasta que el anterior esté resuelto o explícitamente bloqueado.

## Uso

```
# Ingestar un documento de QA
/jr-worklist @QA-homepage-v2.pdf
/jr-worklist @feedback-cliente.md

# También acepta texto pegado directamente
/jr-worklist
1. El botón de ver más no funciona
2. Logo pixelado en mobile
3. ...

# Trabajar el siguiente punto
/jr-worklist next

# Ver el avance
/jr-worklist status

# Con varias worklists activas
/jr-worklist @specs/worklists/qa-homepage.md next
```

## El flujo

1. **Ingesta** — parsea el documento, extrae los items con su cita textual, clasifica cada uno por ruta (patch / fix / spec), asigna severidad y propone orden de ataque.
2. **`next`** — toma el siguiente punto, lo marca 🔄 In progress (solo puede haber uno), muestra el header de reconocimiento y te consulta contexto previo.
3. **Trabajo** — según la ruta: cambios triviales inline, bugs con diagnóstico + corrección, features te sugiere `/jr-build-spec`.
4. **Verificación** — el item solo se marca ✅ cuando TÚ confirmas que lo probaste ("verificado"). Si falla, sigue in progress.
5. **Repite** hasta completar.

## El checkpoint de contexto

Los reportes de QA suelen venir de personas no técnicas ("el botón no funciona" sin más). Antes de explorar a ciegas, el skill te pregunta:

```
Antes de explorar, ¿tienes contexto que acelere esto?
  a) Ya sé la causa raíz → dímela y voy directo
  b) Tengo pistas (página, componente, sospecha) → acoto la búsqueda
  c) No tengo nada → exploro desde cero
```

- Si das la **causa raíz**, el skill la verifica quirúrgicamente (no la aplica a ciegas) y va directo a corregir. Si tu hipótesis no se confirma, te lo dice honestamente.
- Si das **pistas**, la búsqueda se restringe a esa zona.
- Tu contexto queda registrado en el item para futura referencia.

## El gate de un-punto-a-la-vez

```
$ /jr-worklist next     ← con el #2 a medias

⛔ El item #2 sigue 🔄 In progress. Un punto a la vez.
  a) Retomarlo → te muestro dónde quedó
  b) Marcarlo 🚫 Blocked si no depende de ti → "blocked: [razón]"
  c) Si ya lo verificaste → "verificado"
```

Items bloqueados (esperas assets del cliente, una API key) salen de la cola pero quedan visibles en el status. Se desbloquean con `unblock #N`.

## Rutas de items

| Ruta | Cuándo | Qué pasa |
|---|---|---|
| `patch` | Cosmético, copy, typo | Flujo inline rápido: diff → confirmar → aplicar |
| `fix` | Bug: algo construido que no funciona | Diagnóstico compacto + corrección. La worklist es el registro — sin archivos extra |
| `spec` | Feature disfrazado de punto de QA | Te sugiere `/jr-build-spec` — no se implementa directo |

## Persistencia y tracking

- La worklist vive en `specs/worklists/[nombre].md` con el detalle de cada item: cita textual del QA, contexto que aportaste, qué se cambió.
- Si cierras sesión con un item a medias, se guarda el "último avance" — al retomar días después no empiezas de cero.
- Cada item resuelto deja una línea en `docs/progress.md`.
- `/jr-worklist status` te da la tabla de avance lista para reportarle al cliente o PM.

## Interacción con modo dev

En `Mode: dev`: clasificación de rutas más conservadora (más items van a fix/spec), y los items tipo spec no se pueden degradar a manejo inline.

## Notas

- La cita textual del documento QA es el criterio de aceptación — resuelto significa que las palabras del reporter se cumplen, no tu interpretación.
- Tu conocimiento previo es la herramienta de diagnóstico más barata. El skill pregunta primero, explora después — pero verifica siempre.
- Un punto a la vez es feature, no limitación: los items a medias son la razón por la que las rondas de QA se arrastran semanas.
