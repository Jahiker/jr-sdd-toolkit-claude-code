---
name: jr-exe-spec
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-exe-spec o proporcione un spec (.md) aprobado que deba implementarse en código. Se activa con frases como "ejecutar el spec", "implementar el spec", "aplicar los cambios del spec", "correr el spec", o cuando se mencione /jr-exe-spec. Recibe un archivo .md que es un spec generado por jr-build-spec (ya refinado y aprobado), construye un plan de ejecución detallado, espera aprobación y luego implementa todos los cambios: crea archivos, modifica código, instala dependencias, agrega trazabilidad entre spec y código, y actualiza el ciclo de vida del spec al finalizar. Stack soportado: JavaScript, TypeScript, PHP, React, Next.js, TanStack, Vue, Node.js, Laravel, WordPress, Shopify, CSS, Sass, Tailwind CSS, Webpack, Vite, Docker.
---

# jr-exe-spec

Skill para implementar specs técnicos aprobados. Recibe un spec `.md`, construye un plan de ejecución explícito, lo presenta para aprobación, ejecuta los cambios con trazabilidad completa entre spec y código, y actualiza el ciclo de vida del spec.

---

## Paso 0 — Validar input

Si el usuario ejecutó `/jr-exe-spec` **sin adjuntar un archivo `.md`**, responde:

> "Para ejecutar `/jr-exe-spec` necesito el spec aprobado. Compártelo así: `/jr-exe-spec @specs/nombre-del-spec.md`"

No continúes hasta tener el archivo.

---

## Paso 1 — Leer y validar el spec

1. Lee el spec `.md` completo.
2. Verifica el status del spec:
   - Si `Status: Implemented` → advierte: "Este spec ya fue implementado. ¿Quieres ejecutarlo de nuevo (re-implementación) o es una iteración nueva?"
   - Si `Status: Draft` → es correcto, continúa.
3. Verifica que el spec esté en condiciones de ejecutarse:
   - ¿Tiene sección de **Requerimientos Funcionales** con criterios de aceptación?
   - ¿Tiene sección de **Diseño Técnico**?
   - ¿Existen ítems `[PENDING]` o `[TBD]` en secciones críticas (RFs, Diseño Técnico, APIs)?
4. Si hay `[PENDING]` / `[TBD]` en secciones críticas, **detente**:

   > "⚠️ El spec tiene ítems sin resolver: [lista]. Deben estar definidos antes de ejecutar. ¿Los resolvemos ahora o continúo asumiendo [decisión razonable]?"

5. Verifica specs declarados en `**Dependencias > Specs que deben ejecutarse antes**`. Si alguno no tiene `Status: Implemented`, advierte:

   > "⚠️ Este spec depende de `specs/X.md` que aún no está implementado. ¿Quieres continuar de todas formas?"

6. Escanea el proyecto:
   - Stack detectado (`package.json`, `composer.json`, `Dockerfile`, etc.)
   - Estructura de directorios relevante
   - Archivos que el spec menciona: ¿existen? ¿en qué estado?
   - Convenciones del proyecto (nombres, estructura, imports)

   Consulta `references/stack-patterns.md` para patrones del stack detectado.

---

## Paso 2 — Construir el Plan de Ejecución

Genera el plan con esta estructura:

```
## 📋 Plan de Ejecución — [Nombre del Feature]

**Spec:** specs/nombre-del-spec.md
**Stack detectado:** [tecnologías]
**Archivos a crear:** X  |  **Archivos a modificar:** Y  |  **Dependencias a instalar:** Z

---

### FASE 1: [Nombre, ej: Tipos e interfaces]
  - [ ] 1.1 [Acción concreta] → `ruta/archivo.ext` [CREAR]
  - [ ] 1.2 [Acción concreta] → `ruta/archivo.ext` [MODIFICAR]

### FASE 2: [Nombre, ej: Lógica de negocio / servicios]
  - [ ] 2.1 [Acción concreta] → `ruta/archivo.ext` [CREAR]

### FASE 3: [Nombre, ej: UI / Controllers / Routes]
  - [ ] 3.1 [Acción concreta] → `ruta/archivo.ext` [MODIFICAR]

### FASE 4: Dependencias (si aplica)
  - [ ] 4.1 Instalar: `[package-manager] add [paquete@version]`

### FASE 5: Verificación manual sugerida
  - [ ] 5.1 [Qué verificar para confirmar que el feature funciona]

---
> ¿Apruebas este plan? Responde **"sí"** para ejecutar, o indícame qué ajustar.
```

**Reglas del plan:**
- Cada ítem es una acción atómica y verificable.
- Orden obligatorio: tipos/interfaces → modelos/schemas → servicios → UI/controllers/routes → estilos → config/env.
- Nunca mezclar fases de estructura con fases de lógica.
- Los archivos de configuración sensibles (`.env`, secrets) van como `.env.example` con keys vacías.

---

## Paso 3 — Esperar aprobación

**No ejecutes nada hasta recibir aprobación explícita.**

Si el usuario pide ajustes, modifica el plan y vuelve a presentarlo completo. Solo avanza con "sí", "adelante", "ejecuta" o equivalente claro.

---

## Paso 4 — Ejecutar el plan

Fase por fase, en orden. Por cada ítem:

1. **Anuncia**: `▶ 1.1 Creando \`src/services/feature.ts\`...`
2. **Ejecuta** el cambio.
3. **Agrega trazabilidad** en cada archivo que crees o modifiques significativamente:
   - En archivos JS/TS/PHP: comentario en la cabecera del archivo o de la función/clase principal
   - En archivos de configuración o markup: comentario apropiado al formato
   - Formato: `// spec: specs/nombre-del-spec.md` (o `/* spec: ... */`, `# spec: ...` según el lenguaje)
   - Solo en archivos **creados por este spec** o en bloques de código **introducidos por este spec**. No contamines código preexistente.
4. **Confirma**: `✓ 1.1 Completado`

**Si encuentras algo inesperado**, pausa y reporta antes de continuar:
> "⚠️ En el ítem 2.3: `archivo.ts` ya tiene una función `X` que entra en conflicto. Opciones: [A] Reemplazo, [B] Renombro la nueva, [C] Fusiono lógica. ¿Cuál prefieres?"

**Principios de escritura de código:**
- Sigue las convenciones del proyecto existente (naming, estructura de imports, formateo).
- Implementa exactamente lo que el spec define, no más, no menos.
- No over-engineer: si el spec dice "un campo nuevo", agrega el campo, no refactorices todo el modelo.
- Si el spec dice "reutilizar X componente/servicio", encuéntralo y reutilízalo.
- Consulta `references/stack-patterns.md` para decisiones de convención.

---

## Paso 5 — Reporte final y actualización del spec

### Reporte

```
## ✅ Ejecución Completada — [Nombre del Feature]

### Cambios realizados
| Archivo | Acción | Descripción |
|---|---|---|
| `ruta/archivo.ext` | CREADO | [qué hace] |
| `ruta/archivo.ext` | MODIFICADO | [qué cambió y dónde] |

### Dependencias instaladas
| Paquete | Versión | Motivo |
|---|---|---|
| paquete | x.x.x | [para qué] |

### Trazabilidad agregada
Todos los archivos creados o bloques introducidos por este spec incluyen:
`// spec: specs/[nombre-del-spec].md`

### Cómo verificar
1. [Paso concreto para probar que funciona]
2. [Otro paso si aplica]

### Decisiones tomadas durante ejecución
- [Decisión X tomada porque Y — el dev debe saberlo]

### Próximo paso
Ejecuta `/jr-verify-spec @specs/[nombre-del-spec].md` para verificar cobertura de criterios de aceptación.
```

### Actualización del spec

Abre `specs/nombre-del-spec.md` y aplica estos cambios:

1. Cambia `**Status:** Draft` → `**Status:** Implemented`
2. Agrega sección `## Archivos Afectados` (antes del Historial):

```markdown
## Archivos Afectados

| Archivo | Acción | Descripción |
|---|---|---|
| `ruta/archivo.ext` | CREADO | [qué hace] |
| `ruta/archivo.ext` | MODIFICADO | [qué cambió] |
```

3. Agrega entrada en la tabla `## Historial`:

```markdown
| 1.1 | YYYY-MM-DD | Implementado | jr-exe-spec — [resumen en una línea] |
```

---

## Manejo de casos especiales

**Archivo existe con contenido diferente al esperado:**
Pausa. Muestra diff esperado vs realidad. Opciones: sobreescribir / fusionar / saltar.

**Dependencia no disponible (módulo faltante, API inexistente):**
Pausa. Reporta qué falta. Sugiere alternativa si existe. Espera decisión.

**Spec menciona tests pero el proyecto no tiene setup de testing:**
Notifica al inicio. No bloquees la ejecución; agréguelo como nota en el reporte final.

**Archivos `.env` / secrets:**
Nunca escribas valores reales. Crea `.env.example` con keys vacías y documenta qué debe ir en cada una.

**Spec muy grande (más de 15 ítems en el plan):**
Antes de ejecutar, sugiere dividir la ejecución en sesiones por fase. Espera decisión.

---

## Referencias

- `references/stack-patterns.md` — Patrones de código por stack. Consultar en Paso 1 y durante ejecución para decisiones de convención o estructura.
