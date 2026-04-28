# /jr-status

Genera un dashboard del estado de todos los specs del proyecto. Visibilidad completa de qué está hecho, qué está en progreso y qué tiene deuda pendiente.

## Uso

```
/jr-status
```

No requiere argumentos. Escanea automáticamente el directorio `specs/` del proyecto actual.

## Descripción

1. **Escanea** todos los `.md` en `specs/`
2. **Clasifica** cada spec: ✅ Verified · 🔵 Implemented · 🟡 Draft · 🔴 Bloqueado · ⚠️ Needs Attention
3. **Genera** un dashboard con tablas por estado, dependencias entre specs y estadísticas
4. **Recomienda** próximos pasos ordenados por prioridad
5. **Detecta** anomalías: specs huérfanos, drafts viejos sin actividad, specs sin historial

## Notas

- Solo lectura — no modifica ningún archivo.
- Funciona mejor cuando los specs fueron creados con jr-build-spec (tienen Status, Versión, Historial).
- Para specs viejos sin Historial, lo reporta como anomalía pero los incluye en el dashboard.
