# /jr-vision

Transforma una idea en bruto en un documento de visión del producto estructurado y accionable. Primer paso del flujo de inicio de proyecto.

## Uso

```
/jr-vision
Tengo una idea: quiero construir una app para gestionar clientes y facturas para freelancers.
```

O con archivo:
```
/jr-vision @docs/mi-idea.md
```

## Descripción

1. **Lee** la idea o descripción inicial
2. **Analiza** qué está claro y qué es ambiguo
3. **Pregunta** solo lo necesario: problema real, usuarios, scope, MVP vs fases
4. **Construye** el documento de visión con estructura profesional
5. **Guarda** en `docs/vision.md`

## Secciones del documento generado

Resumen en una línea · El problema · La solución · Usuarios · Propuesta de valor · Alcance (MVP / Fase 2 / Fuera de scope) · Contexto de negocio · Métricas de éxito · Riesgos y supuestos

## Flujo completo de inicio de proyecto

```
/jr-vision    → docs/vision.md
/jr-arch      → docs/architecture.md + PROJECT.md
/jr-roadmap   → docs/roadmap.md + specs/ placeholders
/jr-build-spec → specs/feature.md (uno por uno, en orden del roadmap)
```

## Notas

- No necesitas tener la idea perfecta — el skill la refina.
- Lo que no esté definido queda como [Por definir] en el documento.
- El MVP se define explícitamente y se separa de las fases futuras.
