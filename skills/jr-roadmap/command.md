# /jr-roadmap

Descompone el producto en épicas y features, los ordena por dependencias técnicas y valor, y produce el mapa de trabajo accionable para usar con el resto del toolkit.

## Uso

```
/jr-roadmap
```

No requiere argumentos. Lee `docs/vision.md` y `docs/architecture.md` automáticamente.

## Descripción

1. **Lee** visión y arquitectura
2. **Identifica** todos los features: técnicos, de producto MVP y Fase 2
3. **Presenta** la lista para validación antes de ordenar
4. **Ordena** respetando dependencias técnicas y priorizando valor
5. **Guarda** en `docs/roadmap.md`
6. **Crea** placeholders en `specs/` para todos los features

## Estructura del roadmap generado

- **Fase 0:** Fundación técnica (setup, auth, infra)
- **Fase 1:** MVP core (features que entregan el valor principal)
- **Fase 2:** Extensiones (amplían el valor del MVP)
- Mapa de dependencias entre features
- Instrucciones de uso con el toolkit

## Notas

- Requiere `docs/vision.md` y `docs/architecture.md`.
- Los placeholders en `specs/` hacen que `/jr-status` muestre el proyecto completo desde el inicio.
- El roadmap es un documento vivo — itera con `/jr-iterate-spec @docs/roadmap.md` si cambian prioridades.
