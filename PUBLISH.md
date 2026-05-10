# Guía de publicación — jr-toolkit

Instrucciones para publicar el repo en GitHub y el paquete en npm.

**Repo:** https://github.com/Jahiker/jr-sdd-toolkit-claude-code
**Paquete npm:** [@jahiker/claude-toolkit](https://www.npmjs.com/package/@jahiker/claude-toolkit)

---

## Setup inicial (solo la primera vez)

Asegúrate de tener:
- Acceso de escritura al repo en GitHub
- Sesión de npm activa: `npm whoami` debe responder con tu usuario
- Token de npm con permisos de publish (granular o classic)

---

## Flujo de release (cada nueva versión)

### 1. Verificar el estado del paquete

```bash
cd /Users/macbook/Downloads/jr-toolkit-repo

# Ver qué se va a empaquetar
npm pack --dry-run

# Verificar nombre y versión actual
npm view @jahiker/claude-toolkit version
```

### 2. Bumpear la versión

Elige según la naturaleza del cambio:

```bash
npm version patch   # 1.7.0 → 1.7.1  (bug fixes)
npm version minor   # 1.7.0 → 1.8.0  (nueva skill o capacidad)
npm version major   # 1.7.0 → 2.0.0  (breaking changes)
```

`npm version` actualiza `package.json` y crea un tag git automáticamente.

> Si ya tienes el `package.json` con la versión correcta (ej. ya está en 1.7.0), no corras `npm version` — pasa directo al commit y tag manuales.

### 3. Commit y push

```bash
git add .
git commit -m "feat: <descripción del cambio>"
git push origin main --tags
```

**Convención de commits:**
- `feat:` nueva skill o capacidad
- `fix:` bug en el comportamiento de un skill
- `perf:` optimización de tokens o rendimiento
- `docs:` README o documentación
- `chore:` mantenimiento del repo (deps, configs, etc.)

### 4. Publicar en npm

```bash
npm publish --access public
```

Si tienes 2FA activado:

```bash
npm publish --access public --otp=123456
```

> ⚠️ El `--otp` recibe el **código de 6 dígitos** de tu app de 2FA (Google Authenticator, Authy, etc.), NO un token de acceso `npm_xxx`. Los tokens van en `~/.npmrc`, no en `--otp`.

### 5. Crear release en GitHub (opcional pero recomendado)

```bash
gh release create v1.7.0 \
  --title "v1.7.0 — Session continuity: jr-progress + cross-skill log writes" \
  --notes "Release notes here"
```

O desde la UI: https://github.com/Jahiker/jr-sdd-toolkit-claude-code/releases/new

---

## Verificación post-publish

```bash
# Confirmar que la nueva versión está disponible
npm view @jahiker/claude-toolkit version

# Probar instalación limpia
npx @jahiker/claude-toolkit@latest install
```

---

## Troubleshooting

### `npm publish` falla con "version already exists"

La versión que intentas publicar ya existe en npm. Bumpea de nuevo y reintenta:

```bash
npm version patch
git push origin main --tags
npm publish --access public
```

### `claude-toolkit: command not found` después de instalar global

El binario está en el directorio de Node de tu nvm pero no en el PATH. Soluciones:

```bash
# Opción A — usar npx (siempre funciona)
npx @jahiker/claude-toolkit install

# Opción B — encontrar el binario y agregar al PATH
which node
# Por ejemplo: /Users/macbook/.nvm/versions/node/v24.12.0/bin/node
# El binario estará en el mismo directorio: claude-toolkit
```

### Cambios en SKILL.md no se reflejan en Claude Code

Después de publicar y reinstalar:

```bash
npx @jahiker/claude-toolkit install
```

Reinicia Claude Code para que los skills se recarguen.

### Error E400 con OTP malformado

Si ves `["otp" with value "npm_***" fails to match the required pattern: /^\d+$/]`, estás pasando un token de acceso como si fuera código OTP.

- **Token de acceso** (`npm_xxx`, ~64 chars): va en `~/.npmrc` como `_authToken`.
- **OTP** (6 dígitos numéricos): va en el flag `--otp=123456`.

Solución:

```bash
# Configura el token persistente
echo "//registry.npmjs.org/:_authToken=npm_TU_TOKEN_AQUI" >> ~/.npmrc

# Después publica sin --otp (si el token es Automation)
npm publish --access public

# O con OTP fresco si tu cuenta exige 2FA en publish
npm publish --access public --otp=123456
```

---

## Versionado del toolkit

| Versión | Cambios principales |
|---|---|
| 1.0.0 | Initial: jr-init, jr-build-spec, jr-exe-spec, jr-verify-spec, jr-status, jr-iterate-spec |
| 1.1.0 | Added jr-vision, jr-arch, jr-roadmap, jr-fix-spec |
| 1.2.0 | Full i18n rewrite — skills respond in user's conversation language |
| 1.3.0 | Fixed bin name: `jr-toolkit` → `claude-toolkit` |
| 1.4.0 | Token optimization: compact skills (~58% reduction) + lazy references + Toolkit Context |
| 1.5.0 | Maintenance release |
| 1.6.0 | jr-build-spec accepts direct chat input + new jr-sync skill (drift reconciliation) |
| 1.7.0 | Session continuity: new jr-progress skill + all modifier skills append to docs/progress.md |
