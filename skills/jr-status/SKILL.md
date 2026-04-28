---
name: jr-status
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-status o quiera ver el estado general de los specs del proyecto. Se activa con frases como "estado de los specs", "ver specs", "qué specs hay", "dashboard de specs", "cuáles están pendientes", "qué falta por implementar", "resumen del proyecto", o cuando se mencione /jr-status. No recibe argumentos — escanea el directorio specs/ del proyecto actual, lee todos los specs, y genera un dashboard visual con estado, versión, pendientes y próximos pasos accionables por cada spec.
---

# jr-status

Skill de visibilidad del proyecto. Escanea todos los specs del directorio `specs/`, los clasifica por status y genera un dashboard accionable que muestra de un vistazo qué está hecho, qué está en progreso y qué tiene deuda pendiente.

---

## Paso 0 — Verificar existencia de specs

1. Busca el directorio `specs/` en la raíz del proyecto.
2. Si no existe o está vacío:
   > "No se encontró el directorio `specs/` o está vacío. Crea tu primer spec con `/jr-build-spec @ruta/requerimiento.md`"
   Termina aquí.
3. Lista todos los archivos `.md` dentro de `specs/`.

---

## Paso 1 — Leer y clasificar cada spec

Para cada archivo `.md` en `specs/`, lee:
- `**Status:**` — Draft / Implemented / Verified
- `**Versión:**`
- `**Fecha:**`
- `**Specs relacionados:**`
- Título (primera línea `# Título`)
- Sección `## 10. Preguntas Pendientes` — ¿tiene ítems `[PENDING]`?
- Sección `## Delta` — ¿existe? ¿cuántos cambios tuvo?
- Sección `## Archivos Afectados` — cuántos archivos toca
- Último entry de `## Historial` — última acción y fecha

Clasifica cada spec en uno de estos estados:

| Estado | Criterio |
|---|---|
| 🟡 **DRAFT** | Status: Draft, sin [PENDING] críticos |
| 🔴 **DRAFT — BLOQUEADO** | Status: Draft, tiene [PENDING] sin resolver en RFs o Diseño Técnico |
| 🔵 **IMPLEMENTED** | Status: Implemented |
| ✅ **VERIFIED** | Status: Verified |
| ⚠️ **NEEDS ATTENTION** | Cualquier status con [PENDING] críticos o gaps reportados por jr-verify-spec |

---

## Paso 2 — Generar el Dashboard

```markdown
# 📊 jr-status — [Nombre del Proyecto o directorio raíz]
**Fecha:** YYYY-MM-DD  |  **Total specs:** N

---

## Resumen
| ✅ Verified | 🔵 Implemented | 🟡 Draft | 🔴 Bloqueado | ⚠️ Attention |
|---|---|---|---|---|
| X | X | X | X | X |

---

## Specs por Estado

### ✅ Verified
| Spec | Versión | Última acción | Archivos |
|---|---|---|---|
| `specs/nombre.md` — Título del Feature | v1.1 | 2024-01-15 verificado | 5 |

### 🔵 Implemented
| Spec | Versión | Última acción | Archivos | Acción sugerida |
|---|---|---|---|---|
| `specs/nombre.md` — Título del Feature | v1.0 | 2024-01-10 implementado | 3 | Ejecutar `/jr-verify-spec` |

### 🟡 Draft
| Spec | Versión | Fecha | Pendientes | Acción sugerida |
|---|---|---|---|---|
| `specs/nombre.md` — Título del Feature | v1.0 | 2024-01-08 | 0 | Ejecutar `/jr-exe-spec` |

### 🔴 Draft — Bloqueado
| Spec | Versión | Pendientes sin resolver | Acción sugerida |
|---|---|---|---|
| `specs/nombre.md` — Título del Feature | v1.0 | 2 (C1, D3) | Resolver pendientes → `/jr-exe-spec` |

### ⚠️ Needs Attention
| Spec | Versión | Problema detectado | Acción sugerida |
|---|---|---|---|
| `specs/nombre.md` — Título del Feature | v2.0 | Gaps en verificación | Re-ejecutar `/jr-exe-spec` para cerrar gaps |

---

## Dependencias entre Specs

> Solo se muestran specs con dependencias declaradas.

- `specs/checkout.md` depende de → `specs/autenticacion.md` ✅
- `specs/notificaciones.md` depende de → `specs/perfil-usuario.md` 🔵 *(dependencia no verificada aún)*

---

## Próximos pasos recomendados

> Ordenados por prioridad y desbloqueabilidad.

1. **[URGENTE]** Resolver pendientes en `specs/nombre-bloqueado.md` (C1, D3) para poder ejecutarlo
2. **[QUICK WIN]** `specs/nombre-draft.md` está listo — ejecutar `/jr-exe-spec @specs/nombre-draft.md`
3. **[DEUDA]** `specs/nombre-implemented.md` implementado pero sin verificar — ejecutar `/jr-verify-spec @specs/nombre-implemented.md`
4. **[ITERACIÓN]** `specs/nombre-verified.md` v1.0 verificado — ¿hay nuevos requerimientos? `/jr-iterate-spec @specs/nombre-verified.md`

---

## Estadísticas del Proyecto

- **Specs totales:** N
- **Cobertura verificada:** X% (verified / total)
- **Deuda técnica:** X specs implementados sin verificar
- **Specs bloqueados:** X (requieren decisiones pendientes)
- **Feature más reciente:** `specs/nombre.md` — hace X días
```

---

## Paso 3 — Detectar anomalías

Además del dashboard, reporta si detectas:

**Specs huérfanos:** specs que declaran dependencia de otro spec que no existe en `specs/`.
```
⚠️ `specs/checkout.md` declara dependencia de `specs/pagos.md` que no existe en el directorio.
```

**Specs muy viejos en Draft:** specs en Draft con más de 30 días sin actividad.
```
⚠️ `specs/feature-antigua.md` lleva 45 días en Draft sin cambios. ¿Sigue siendo relevante?
```

**Specs sin Historial:** specs que no tienen la sección `## Historial` (generados antes de la v2 del toolkit).
```
ℹ️ `specs/feature-vieja.md` no tiene sección Historial — fue generado con una versión anterior del toolkit.
```

---

## Principios

- **Solo leer, nunca modificar**: este skill es de observabilidad, no toca ningún archivo.
- **Accionable sobre informativo**: cada ítem del dashboard tiene una acción sugerida concreta.
- **Honesto sobre deuda**: no ocultar specs con problemas — visibilidad es el objetivo.
