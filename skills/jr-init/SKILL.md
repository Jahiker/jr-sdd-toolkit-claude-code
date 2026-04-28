---
name: jr-init
description: >
  Úsalo siempre que el usuario ejecute el comando /jr-init o quiera inicializar un proyecto para trabajar con el toolkit spec-driven. Se activa con frases como "inicializar el proyecto", "configurar el proyecto", "preparar el proyecto para specs", "setup del proyecto", "init del proyecto", o cuando se mencione /jr-init. Ejecuta el /init normal de Claude Code para explorar el proyecto, y además crea el archivo PROJECT.md con stack, arquitectura, convenciones y decisiones técnicas del proyecto. Si ya existe CLAUDE.md, lo lee para extraer contexto sin modificarlo. Si PROJECT.md ya existe, lo actualiza en lugar de sobreescribirlo.
---

# jr-init

Skill de inicialización de proyecto. Combina el `/init` estándar de Claude Code con la creación de `PROJECT.md` — un archivo de contexto permanente que describe el proyecto para que cualquier skill del toolkit pueda entenderlo sin re-inferirlo en cada sesión.

---

## Paso 0 — Verificar estado del proyecto

Antes de hacer nada, verifica:

1. ¿Existe `CLAUDE.md`? → leerlo completo para extraer contexto (no modificar)
2. ¿Existe `PROJECT.md`? → si existe, es una **actualización**, no una creación desde cero
3. ¿Existe `specs/`? → registrar cuántos specs hay (contexto útil para el PROJECT.md)

Anuncia al usuario:

```
🔍 Analizando el proyecto...
- CLAUDE.md: [encontrado / no encontrado]
- PROJECT.md: [encontrado → actualizaré / no encontrado → crearé]
- specs/: [X specs encontrados / no existe aún]
```

---

## Paso 1 — Ejecutar exploración del proyecto (equivalente a /init)

Explora el proyecto en profundidad para entender todo lo necesario. Este es el núcleo del `/init` de Claude Code — hazlo de forma exhaustiva:

### 1.1 Estructura y configuración
- Lee `package.json` / `composer.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` (lo que exista)
- Lee `README.md` si existe
- Lee `CLAUDE.md` si existe (ya leído en Paso 0)
- Detecta archivos de configuración: `.eslintrc`, `.prettierrc`, `tsconfig.json`, `vite.config.*`, `webpack.config.*`, `tailwind.config.*`, `docker-compose.yml`, `Dockerfile`, `.env.example`
- Escanea la estructura de directorios raíz (2 niveles de profundidad)

### 1.2 Stack tecnológico
Identifica con precisión:
- **Lenguajes:** JS, TS, PHP, Python, etc. y sus versiones
- **Frameworks principales:** React, Vue, Next.js, Laravel, WordPress, etc.
- **Herramientas de build:** Vite, Webpack, etc.
- **Estilos:** CSS, Sass, Tailwind, etc.
- **Testing:** Jest, Vitest, PHPUnit, Cypress, etc.
- **Base de datos / ORM:** Prisma, Eloquent, Sequelize, etc.
- **Infraestructura:** Docker, servicios externos declarados

### 1.3 Arquitectura
- ¿Monolito, monorepo, microservicios?
- ¿App Router o Pages Router (Next.js)?
- ¿MVC, feature-based, domain-driven?
- ¿Dónde vive la lógica de negocio?
- ¿Cómo se organizan los componentes/módulos?
- ¿Hay patrones de estado? (Redux, Zustand, Pinia, etc.)
- ¿Cómo se manejan las API calls? (fetch directo, axios, react-query, etc.)

### 1.4 Convenciones detectadas
- Naming de archivos: PascalCase, kebab-case, snake_case
- Naming de componentes / clases / funciones
- Estructura de imports (absolutos con alias, relativos)
- Patrones de exports (named, default)
- Dónde se ponen los tipos/interfaces
- Cómo se manejan los errores
- Cómo se organizan los tests

### 1.5 Decisiones técnicas importantes
- ¿Hay linting/formatting configurado? ¿Con qué reglas relevantes?
- ¿Hay pre-commit hooks?
- ¿Hay CI/CD declarado? (`.github/workflows`, etc.)
- ¿Variables de entorno documentadas en `.env.example`?
- ¿Hay patrones de autenticación ya establecidos?
- ¿Hay librerías de UI (shadcn, MUI, etc.)?

---

## Paso 2 — Leer specs existentes (si aplica)

Si existe `specs/`, lee los títulos y status de todos los specs para incluirlos como contexto en `PROJECT.md`.

---

## Paso 3 — Crear o actualizar PROJECT.md

> ⚠️ **Obligatorio. Ejecutar sin pedir confirmación. El skill NO termina hasta que PROJECT.md exista en disco.**

### Si PROJECT.md NO existe → crear:

```markdown
# PROJECT.md

> Archivo de contexto del proyecto generado por jr-init.
> Mantenlo actualizado cuando cambies el stack, la arquitectura o las convenciones.
> Los skills del toolkit (jr-build-spec, jr-exe-spec, jr-verify-spec, jr-iterate-spec) leen este archivo al inicio de cada sesión.

---

## Proyecto

**Nombre:** [nombre del proyecto, inferido de package.json o directorio raíz]
**Descripción:** [descripción breve, inferida de README o package.json]
**Última actualización de este archivo:** YYYY-MM-DD

---

## Stack Tecnológico

### Lenguajes
- [Lenguaje] [versión]

### Frameworks y librerías principales
- [Framework] [versión] — [rol en el proyecto]

### Build & Tooling
- [Herramienta] — [para qué]

### Estilos
- [CSS/Sass/Tailwind] — [configuración relevante]

### Testing
- [Framework de tests] — [dónde están los tests, cómo correrlos]

### Base de datos / ORM
- [BD] + [ORM si aplica]

### Infraestructura
- [Docker / servicios / etc.]

---

## Arquitectura

**Tipo:** [Monolito / Monorepo / Microservicios / etc.]
**Patrón:** [MVC / Feature-based / Domain-driven / etc.]

### Estructura de directorios
```
[árbol de directorios relevante, 2-3 niveles]
```

### Dónde vive cada cosa
- **Lógica de negocio:** [ruta]
- **Componentes UI:** [ruta]
- **API / Routes:** [ruta]
- **Tipos / Interfaces:** [ruta]
- **Estilos:** [ruta]
- **Tests:** [ruta]
- **Configuración:** [ruta]

### Flujo de datos general
[Descripción breve de cómo fluyen los datos: UI → servicio → BD, o similar]

---

## Convenciones

### Naming
- **Archivos de componentes:** [PascalCase.tsx / kebab-case.vue / etc.]
- **Archivos de utilidades/servicios:** [kebab-case.ts / snake_case.php / etc.]
- **Funciones:** [camelCase / snake_case]
- **Clases:** [PascalCase]
- **Constantes:** [UPPER_SNAKE_CASE]
- **Variables de entorno:** [UPPER_SNAKE_CASE con prefijo si aplica]

### Imports
- **Estilo:** [absolutos con alias `@/` / relativos]
- **Alias configurados:** [lista de alias si existen]
- **Orden de imports:** [librerías externas → internas → locales / o el que aplique]

### Exports
- [Named exports como norma / default export para componentes de página / etc.]

### Manejo de errores
- [Patrón usado: try/catch + next(error) / Result type / etc.]

### Estado global
- [Herramienta y patrón: Zustand stores en `/store` / Pinia con composition API / etc.]

---

## Decisiones técnicas

> Decisiones importantes ya tomadas que no deben revertirse sin discusión.

- **[Decisión]:** [contexto y motivo]
- **[Decisión]:** [contexto y motivo]

---

## Variables de entorno requeridas

> Ver `.env.example` para valores. Aquí solo se documenta el propósito.

| Variable | Propósito |
|---|---|
| `VARIABLE_NAME` | [para qué se usa] |

*(Sección vacía si no hay `.env.example` o no se detectaron variables)*

---

## Comandos útiles

```bash
# Desarrollo
[comando para levantar el proyecto]

# Build
[comando de build]

# Tests
[comando de tests]

# Linting
[comando de lint]
```

---

## Specs del proyecto

*(Actualizar con /jr-status)*

| Spec | Status | Versión |
|---|---|---|
[lista de specs existentes, o "No hay specs aún — usar /jr-build-spec para crear el primero"]

---

## Notas adicionales

[Cualquier cosa importante que un dev nuevo deba saber y no esté cubierta arriba]
```

### Si PROJECT.md YA existe → actualizar:

1. Lee el `PROJECT.md` actual completo.
2. Compara con lo detectado en el Paso 1.
3. Actualiza **solo las secciones que hayan cambiado** (nuevas dependencias, nuevas convenciones detectadas, etc.).
4. Preserva las secciones que el usuario haya editado manualmente (especialmente "Decisiones técnicas" y "Notas adicionales").
5. Actualiza `**Última actualización de este archivo:**` con la fecha actual.
6. Agrega al inicio del archivo una nota:
   ```
   > *(Actualizado por jr-init el YYYY-MM-DD)*
   ```

---

## Paso 4 — Confirmar y orientar

```
✅ Inicialización completada

**Archivos generados/actualizados:**
- `PROJECT.md` — contexto del proyecto para el toolkit

**Stack detectado:** [resumen en una línea]
**Arquitectura:** [resumen en una línea]

**Tu toolkit está listo:**
- `/jr-build-spec @archivo.md` — convertir un requerimiento en spec
- `/jr-status`                 — ver estado de todos los specs
- `/jr-exe-spec @specs/x.md`  — implementar un spec aprobado
- `/jr-verify-spec @specs/x.md` — verificar cobertura de CAs
- `/jr-iterate-spec @specs/x.md` — iterar sobre un spec existente

**Próximo paso sugerido:**
[Si hay specs en Draft sin ejecutar → sugerir jr-exe-spec]
[Si no hay specs → sugerir jr-build-spec]
[Si hay specs Implemented sin verificar → sugerir jr-verify-spec]
```

---

## Comportamiento ante casos especiales

**El proyecto es muy grande (más de 50 archivos en raíz):**
Enfócate en los archivos de configuración y los directorios de primer nivel. No intentes leer cada archivo — infiere la arquitectura desde la estructura y los configs.

**No hay ningún archivo de configuración reconocible:**
Documenta lo que puedas inferir desde la estructura de directorios y marca las secciones desconocidas como `[Por definir]`.

**El proyecto es un monorepo:**
Documenta la estructura de packages/apps por separado. Identifica qué es shared y qué es específico de cada app.

**`CLAUDE.md` tiene información que contradice lo detectado:**
Prioriza lo que está en `CLAUDE.md` — fue escrito intencionalmente por el dev. Documenta la discrepancia en "Notas adicionales" si es relevante.
