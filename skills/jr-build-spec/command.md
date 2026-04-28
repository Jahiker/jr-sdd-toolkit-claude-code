# /jr-build-spec

Transforma un requerimiento o historia de usuario en un spec técnico profesional.

## Uso

```
/jr-build-spec @ruta/al/requerimiento.md
```

## Descripción

1. **Lee** el archivo `.md` con el requerimiento crudo
2. **Escanea** el proyecto: stack, arquitectura, convenciones
3. **Detecta solapamientos** con specs existentes en `specs/` y los reporta
4. **Evalúa el scope** y advierte si el requerimiento es demasiado grande para un solo spec
5. **Categoriza preguntas** en dos grupos:
   - 🙋 Preguntas para el Cliente / Product Owner
   - 🛠️ Preguntas para el Dev / Arquitecto
6. **Itera** contigo para resolver preguntas (no necesitas responderlas todas de una vez)
7. **Genera** un spec profesional con estructura completa
8. **Guarda** el spec en `specs/[nombre-feature].md`

## Notas

- Si ejecutas el comando sin archivo, el skill te lo pedirá.
- Los solapamientos con specs existentes se reportan antes de empezar.
- Las preguntas sin respuesta quedan como `[PENDING]` en el spec.
- Al finalizar, el skill te indica los próximos pasos: `/jr-exe-spec` y `/jr-verify-spec`.
