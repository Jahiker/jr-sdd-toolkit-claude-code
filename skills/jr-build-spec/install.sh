#!/usr/bin/env bash
# ============================================================
# install-jr-build-spec.sh
# Instala el skill jr-build-spec y el comando /jr-build-spec
# de forma LOCAL en tu máquina (no a nivel de proyecto).
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

CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
SKILL_DEST="${CLAUDE_SKILLS_DIR}/jr-build-spec"
CLAUDE_COMMANDS_DIR="${HOME}/.claude/commands"
COMMAND_DEST="${CLAUDE_COMMANDS_DIR}/jr-build-spec.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -f "${SCRIPT_DIR}/SKILL.md" ]]   || error "No se encontró SKILL.md en ${SCRIPT_DIR}"
[[ -f "${SCRIPT_DIR}/command.md" ]] || error "No se encontró command.md en ${SCRIPT_DIR}"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║      jr-build-spec — Instalador local        ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════╝${RESET}"
echo ""

log "Preparando directorios..."
mkdir -p "${CLAUDE_SKILLS_DIR}"
mkdir -p "${CLAUDE_COMMANDS_DIR}"
ok "Directorios listos"

log "Instalando skill en ${SKILL_DEST}..."
if [[ -d "${SKILL_DEST}" ]]; then
  warn "El skill ya existe. Sobreescribiendo..."
  rm -rf "${SKILL_DEST}"
fi

mkdir -p "${SKILL_DEST}"
cp "${SCRIPT_DIR}/SKILL.md" "${SKILL_DEST}/SKILL.md"

if [[ -d "${SCRIPT_DIR}/scripts" ]]; then
  cp -r "${SCRIPT_DIR}/scripts" "${SKILL_DEST}/scripts"
fi
ok "Skill instalado → ${SKILL_DEST}/SKILL.md"

log "Instalando comando /jr-build-spec..."
cp "${SCRIPT_DIR}/command.md" "${COMMAND_DEST}"
ok "Comando instalado → ${COMMAND_DEST}"

echo ""
log "Verificando instalación..."
ERRORS=0
[[ -f "${SKILL_DEST}/SKILL.md" ]] || { warn "SKILL.md no encontrado en destino"; ERRORS=$((ERRORS+1)); }
[[ -f "${COMMAND_DEST}" ]]        || { warn "command.md no encontrado en destino"; ERRORS=$((ERRORS+1)); }

if [[ $ERRORS -eq 0 ]]; then
  echo ""
  echo -e "${GREEN}${BOLD}✅ Instalación completada exitosamente${RESET}"
  echo ""
  echo -e "  ${BOLD}Skill:${RESET}   ${SKILL_DEST}/SKILL.md"
  echo -e "  ${BOLD}Comando:${RESET} ${COMMAND_DEST}"
  echo ""
  echo -e "  ${BOLD}Uso:${RESET}"
  echo -e "  ${BLUE}/jr-build-spec @ruta/al/requerimiento.md${RESET}"
  echo ""
  echo -e "  ${YELLOW}Nota:${RESET} Reinicia Claude.ai para que el skill quede disponible."
  echo ""
else
  error "La instalación tuvo ${ERRORS} problema(s)."
fi
