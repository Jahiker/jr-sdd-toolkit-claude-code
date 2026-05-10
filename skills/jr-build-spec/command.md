# /jr-build-spec

Transforma un requerimiento o historia de usuario en un spec técnico profesional.

## Uso

Tres formas válidas — usa la que más te convenga:

```
# Con archivo .md
/jr-build-spec @ruta/al/requerimiento.md

# Directo en el chat (sin archivo)
/jr-build-spec
quiero agregar autenticación con OAuth de Google al login...

# Combinado (archivo + contexto adicional en chat)
/jr-build-spec @req.md
y además tener en cuenta que ya tenemos un session manager existente
```

## Descripción

1. **Lee el input** desde la fuente disponible (archivo, chat, o ambos)
2. **Escanea el proyecto**: stack, arquitectura, convenciones (desde PROJECT.md)
3. **Detecta solapamientos** con specs existentes en `specs/` y los reporta
4. **Evalúa el scope** y advierte si el requerimiento es demasiado grande para un solo spec
5. **Categoriza preguntas** en dos grupos:
   - 🙋 Preguntas para el Cliente / Product Owner
   - 🛠️ Preguntas para el Dev / Arquitecto
6. **Itera** contigo para resolver preguntas (no necesitas responderlas todas de una vez)
7. **Genera** un spec profesional con estructura completa
8. **Guarda** el spec en `specs/[nombre-feature].md`

## Notas

- A partir de v1.6.0 ya **no es obligatorio** un archivo `.md`. Puedes describir el requerimiento directamente en el chat.
- Si no proporcionas ni archivo ni descripción, el skill te lo pedirá.
- Los solapamientos con specs existentes se reportan antes de empezar.
- Las preguntas sin respuesta quedan como `[PENDING]` en el spec.
- Al finalizar, el skill te indica los próximos pasos: `/jr-exe-spec` y `/jr-verify-spec`.
