# Guía de publicación — jr-toolkit

Instrucciones para publicar el repo en GitHub y el paquete en npm.

---

## Antes de empezar

Reemplaza `YOUR_USERNAME` con tu usuario real de GitHub en estos archivos:
- `package.json` → campo `repository.url` y `homepage`
- `README.md` → links de instalación con `git clone`

También agrega tu nombre en `LICENSE`.

---

## 1. Crear el repo en GitHub

```bash
# Desde la carpeta del toolkit
cd jr-toolkit-repo

# Inicializar git
git init
git add .
git commit -m "feat: initial release v1.0.0"

# Crear repo en GitHub (requiere GitHub CLI instalado)
gh repo create jr-toolkit --public --description "Spec-Driven Development toolkit for Claude.ai" --push --source .

# Si no tienes GitHub CLI, crea el repo manualmente en github.com
# y luego:
git remote add origin https://github.com/YOUR_USERNAME/jr-toolkit.git
git branch -M main
git push -u origin main
```

---

## 2. Publicar en npm

```bash
# Asegúrate de estar logueado en npm
npm login

# Verificar que el package.json está correcto
npm pack --dry-run

# Publicar
npm publish --access public
```

> Si el nombre `jr-toolkit` ya está tomado en npm, cámbialo en `package.json` por
> `@YOUR_USERNAME/jr-toolkit` (scoped package) y publica con `npm publish --access public`.

---

## 3. Crear un release en GitHub

```bash
# Crear tag de versión
git tag v1.0.0
git push origin v1.0.0

# Crear release (con GitHub CLI)
gh release create v1.0.0 --title "v1.0.0 — Initial release" --notes "First public release of jr-toolkit."
```

O hazlo desde github.com → Releases → Draft a new release.

---

## Para versiones futuras

Cuando actualices los skills:

```bash
# 1. Actualizar versión en package.json (patch, minor o major)
npm version patch   # 1.0.0 → 1.0.1
npm version minor   # 1.0.0 → 1.1.0
npm version major   # 1.0.0 → 2.0.0

# 2. Push al repo
git push origin main --tags

# 3. Publicar en npm
npm publish --access public

# 4. Crear release en GitHub
gh release create v1.x.x --title "v1.x.x" --notes "..."
```

---

## Verificar instalación desde npm

Después de publicar, cualquier persona puede instalarlo con:

```bash
npx jr-toolkit install
```

O con npm global:

```bash
npm install -g jr-toolkit
jr-toolkit install
```
