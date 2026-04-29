# /jr-arch

Define la arquitectura técnica del proyecto basándose en el documento de visión. Produce stack justificado, estructura de módulos, modelo de datos inicial y decisiones técnicas fundamentales.

## Uso

```
/jr-arch
```

No requiere argumentos. Lee `docs/vision.md` automáticamente.

## Descripción

1. **Lee** `docs/vision.md` y escanea el proyecto actual
2. **Pregunta** lo necesario: stack preferido, equipo, infra, escala esperada
3. **Define** el stack con justificación para cada decisión
4. **Diseña** los módulos principales y el modelo de datos inicial
5. **Documenta** las decisiones técnicas fundamentales con contexto y alternativas
6. **Guarda** en `docs/architecture.md` y actualiza `PROJECT.md`

## Secciones del documento generado

Stack tecnológico justificado · Diagrama del sistema · Módulos principales · Estructura de directorios · Modelo de datos inicial · Decisiones técnicas fundamentales · Convenciones del proyecto · Seguridad · Deuda técnica conocida

## Notas

- Requiere `docs/vision.md` — ejecuta `/jr-vision` primero.
- Cada decisión técnica incluye alternativas consideradas y justificación.
- Actualiza `PROJECT.md` automáticamente para que todos los skills del toolkit tengan contexto.
