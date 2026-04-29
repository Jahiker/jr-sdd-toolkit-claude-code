#!/usr/bin/env bash
set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'
log()   { echo -e "${BLUE}[jr-vision]${RESET} $*"; }
ok()    { echo -e "${GREEN}✓${RESET} $*"; }
warn()  { echo -e "${YELLOW}⚠${RESET}  $*"; }
error() { echo -e "${RED}✗${RESET} $*" >&2; exit 1; }
SKILL_DEST="${HOME}/.claude/skills/jr-vision"
COMMAND_DEST="${HOME}/.claude/commands/jr-vision.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -f "${SCRIPT_DIR}/SKILL.md" ]]   || error "No se encontró SKILL.md"
[[ -f "${SCRIPT_DIR}/command.md" ]] || error "No se encontró command.md"
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║      jr-vision — Instalador local         ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════╝${RESET}"
echo ""
mkdir -p "${HOME}/.claude/skills" "${HOME}/.claude/commands"
ok "Directorios listos"
[[ -d "${SKILL_DEST}" ]] && { warn "Ya existe. Sobreescribiendo..."; rm -rf "${SKILL_DEST}"; }
mkdir -p "${SKILL_DEST}"
cp "${SCRIPT_DIR}/SKILL.md"   "${SKILL_DEST}/SKILL.md"
cp "${SCRIPT_DIR}/command.md" "${COMMAND_DEST}"
[[ -d "${SCRIPT_DIR}/references" ]] && cp -r "${SCRIPT_DIR}/references" "${SKILL_DEST}/references"
ok "Skill instalado   → ${SKILL_DEST}"
ok "Comando instalado → ${COMMAND_DEST}"
ERRORS=0
[[ -f "${SKILL_DEST}/SKILL.md" ]] || { warn "SKILL.md no encontrado en destino"; ERRORS=$((ERRORS+1)); }
[[ -f "${COMMAND_DEST}" ]]        || { warn "command.md no encontrado en destino"; ERRORS=$((ERRORS+1)); }
if [[ $ERRORS -eq 0 ]]; then
  echo ""
  echo -e "${GREEN}${BOLD}✅ Instalación completada${RESET}"
  echo ""
  echo -e "  ${YELLOW}Nota:${RESET} Reinicia Claude.ai para activar el skill."
  echo ""
else
  error "La instalación tuvo ${ERRORS} problema(s)."
fi
