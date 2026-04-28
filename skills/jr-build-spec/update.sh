#!/usr/bin/env bash
# ============================================================
# update-jr-build-spec.sh
# Actualiza el skill jr-build-spec ya instalado localmente.
# Conserva la estructura existente, solo reemplaza los archivos.
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

log()   { echo -e "${BLUE}[jr-build-spec]${RESET} $*"; }
ok()    { echo -e "${GREEN}✓${RESET} $*"; }
warn()  { echo -e "${YELLOW}⚠${RESET}  $*"; }
error() { echo -e "${RED}✗${RESET} $*" >&2; exit 1; }

SKILL_DEST="${HOME}/.claude/skills/jr-build-spec"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║     jr-build-spec — Actualización local      ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════╝${RESET}"
echo ""

# Verificar que el skill esté instalado
if [[ ! -d "${SKILL_DEST}" ]]; then
  error "El skill no está instalado en ${SKILL_DEST}. Usa install.sh para instalarlo primero."
fi

# Verificar archivos fuente
[[ -f "${SCRIPT_DIR}/SKILL.md" ]] || error "No se encontró SKILL.md en ${SCRIPT_DIR}"

log "Skill encontrado en ${SKILL_DEST}"
log "Actualizando SKILL.md..."

# Backup del SKILL.md anterior
BACKUP="${SKILL_DEST}/SKILL.md.bak"
cp "${SKILL_DEST}/SKILL.md" "${BACKUP}"
ok "Backup guardado → ${BACKUP}"

# Reemplazar SKILL.md
cp "${SCRIPT_DIR}/SKILL.md" "${SKILL_DEST}/SKILL.md"
ok "SKILL.md actualizado"

# Copiar scripts/ si existen en la fuente
if [[ -d "${SCRIPT_DIR}/scripts" ]]; then
  cp -r "${SCRIPT_DIR}/scripts" "${SKILL_DEST}/scripts"
  ok "scripts/ actualizados"
fi

# Verificación
[[ -f "${SKILL_DEST}/SKILL.md" ]] || error "La actualización falló: SKILL.md no encontrado en destino."

echo ""
echo -e "${GREEN}${BOLD}✅ Actualización completada${RESET}"
echo ""
echo -e "  ${BOLD}Skill:${RESET}  ${SKILL_DEST}/SKILL.md"
echo -e "  ${BOLD}Backup:${RESET} ${BACKUP}"
echo ""
echo -e "  ${YELLOW}Nota:${RESET} Reinicia Claude.ai para que los cambios tomen efecto."
echo ""
