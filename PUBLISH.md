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

```bash
npm version patch   # 1.8.0 → 1.8.1  (bug fixes)
npm version minor   # 1.8.0 → 1.9.0  (nueva skill o capacidad)
npm version major   # 1.8.0 → 2.0.0  (breaking changes)
```

> Si ya tienes el `package.json` con la versión correcta, no corras `npm version` — pasa directo al commit y tag manuales.

### 3. Commit y push

```bash
git add .
git commit -m "feat: <descripción del cambio>"
git push origin main --tags
```

**Convención:**
- `feat:` nueva skill o capacidad
- `fix:` bug en el comportamiento
- `perf:` optimización de tokens o rendimiento
- `docs:` README o documentación
- `chore:` mantenimiento del repo

### 4. Publicar en npm

```bash
npm publish --access public
```

Si tienes 2FA:

```bash
npm publish --access public --otp=123456
```

> El `--otp` recibe el **código de 6 dígitos** de tu app de 2FA, NO un token `npm_xxx`. Los tokens van en `~/.npmrc`.

### 5. Crear release en GitHub

```bash
gh release create v1.8.0 \
  --title "v1.8.0 — Dev mode Phase 1: jr-build-spec rubric + jr-exe-spec gates" \
  --notes "Release notes here"
```

---

## Verificación post-publish

```bash
npm view @jahiker/claude-toolkit version
npx @jahiker/claude-toolkit@latest install
```

---

## Troubleshooting

### `npm publish` falla con "version already exists"

```bash
npm version patch
git push origin main --tags
npm publish --access public
```

### `claude-toolkit: command not found` después de instalar global

```bash
# Opción A — usar npx (siempre funciona)
npx @jahiker/claude-toolkit install

# Opción B — encontrar el binario y agregar al PATH
which node
```

### Error E400 con OTP malformado

Si ves `["otp" with value "npm_***" fails to match the required pattern: /^\d+$/]`, estás pasando un token de acceso como si fuera código OTP.

- **Token de acceso** (`npm_xxx`, ~64 chars): va en `~/.npmrc` como `_authToken`.
- **OTP** (6 dígitos): va en `--otp=123456`.

```bash
echo "//registry.npmjs.org/:_authToken=npm_TU_TOKEN" >> ~/.npmrc
npm publish --access public
```

---

## Versionado del toolkit

| Versión | Cambios principales |
|---|---|
| 1.0.0 | Initial: jr-init, jr-build-spec, jr-exe-spec, jr-verify-spec, jr-status, jr-iterate-spec |
| 1.1.0 | Added jr-vision, jr-arch, jr-roadmap, jr-fix-spec |
| 1.2.0 | Full i18n rewrite — skills respond in user's language |
| 1.3.0 | Fixed bin name: `jr-toolkit` → `claude-toolkit` |
| 1.4.0 | Token optimization: compact skills + lazy references + Toolkit Context |
| 1.5.0 | Maintenance release |
| 1.6.0 | jr-build-spec accepts direct chat input + new jr-sync skill (drift reconciliation) |
| 1.7.0 | Session continuity: jr-progress skill + cross-skill log writes to docs/progress.md |
| 1.8.0 | Dev mode Phase 1: jr-build-spec --dev rubric (6 dimensions, sketches dir) + jr-exe-spec --dev gates (files / risk / rollback) + Mode field in PROJECT.md |
| 1.8.1 | Quick-win optimization: command.md frontmatter with model + tools per skill. Read-only skills (status, progress, sync, init) → haiku. Reasoning skills → sonnet. Code-writing skill (exe-spec) → opus. Significant token cost reduction with no behavioral changes. |
| 1.8.2 | verify-spec scope optimization (read only Affected Files, surgical reading for large files, no whole-codebase grep fallback) to cut its high token cost. New `version` CLI command (+ `--version`/`-v`) showing package version and install status. |
| 1.9.0 | New jr-patch skill: fast path for trivial low-risk changes (colors, copy, typos, config) without the full spec flow. Mandatory risk classifier with two levels — hard block (logic/auth/DB/money/deps/>2 files → redirect to fix-spec/iterate-spec) and soft warning (2 files / ~15 lines / `// spec:` code). Respects Mode: dev (tighter thresholds, spec-code hard-blocked). Out-of-spec patches logged for drift tracking. 13 skills total. |
| 1.10.0 | New jr-worklist skill: QA documents → tracked worklists (specs/worklists/) worked one item at a time with strict gate, dev-context checkpoint (root cause / hints / explore), per-item routing (patch/fix/spec), human verification to close items, session-resumable. Plus jr-iterate-spec scope optimization (surgical edits, no full-spec rewrite, no codebase scanning). 14 skills total. |
