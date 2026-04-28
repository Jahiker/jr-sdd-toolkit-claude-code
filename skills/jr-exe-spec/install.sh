#!/usr/bin/env bash
# ============================================================
# install-jr-exe-spec.sh
# Instala el skill jr-exe-spec y el comando /jr-exe-spec
# de forma LOCAL en tu máquina (no a nivel de proyecto).
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

log()   { echo -e "${BLUE}[jr-exe-spec]${RESET} $*"; }
ok()    { echo -e "${GREEN}✓${RESET} $*"; }
warn()  { echo -e "${YELLOW}⚠${RESET}  $*"; }
error() { echo -e "${RED}✗${RESET} $*" >&2; exit 1; }

CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
SKILL_DEST="${CLAUDE_SKILLS_DIR}/jr-exe-spec"
CLAUDE_COMMANDS_DIR="${HOME}/.claude/commands"
COMMAND_DEST="${CLAUDE_COMMANDS_DIR}/jr-exe-spec.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -f "${SCRIPT_DIR}/SKILL.md" ]]                          || error "No se encontró SKILL.md"
[[ -f "${SCRIPT_DIR}/command.md" ]]                        || error "No se encontró command.md"
[[ -f "${SCRIPT_DIR}/references/stack-patterns.md" ]]      || error "No se encontró references/stack-patterns.md"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║       jr-exe-spec — Instalador local         ║${RESET}"
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

mkdir -p "${SKILL_DEST}/references"
cp "${SCRIPT_DIR}/SKILL.md" "${SKILL_DEST}/SKILL.md"
cp "${SCRIPT_DIR}/references/stack-patterns.md" "${SKILL_DEST}/references/stack-patterns.md"
[[ -d "${SCRIPT_DIR}/scripts" ]] && cp -r "${SCRIPT_DIR}/scripts" "${SKILL_DEST}/scripts"
ok "Skill instalado → ${SKILL_DEST}"

log "Instalando comando /jr-exe-spec..."
cp "${SCRIPT_DIR}/command.md" "${COMMAND_DEST}"
ok "Comando instalado → ${COMMAND_DEST}"

echo ""
ERRORS=0
[[ -f "${SKILL_DEST}/SKILL.md" ]]                     || { warn "SKILL.md no encontrado";          ERRORS=$((ERRORS+1)); }
[[ -f "${SKILL_DEST}/references/stack-patterns.md" ]] || { warn "stack-patterns no encontrado";    ERRORS=$((ERRORS+1)); }
[[ -f "${COMMAND_DEST}" ]]                            || { warn "command.md no encontrado";         ERRORS=$((ERRORS+1)); }

if [[ $ERRORS -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}✅ Instalación completada exitosamente${RESET}"
  echo ""
  echo -e "  ${BOLD}Skill:${RESET}       ${SKILL_DEST}/SKILL.md"
  echo -e "  ${BOLD}Referencias:${RESET} ${SKILL_DEST}/references/"
  echo -e "  ${BOLD}Comando:${RESET}     ${COMMAND_DEST}"
  echo ""
  echo -e "  ${BOLD}Uso:${RESET}"
  echo -e "  ${BLUE}/jr-exe-spec @specs/nombre-del-spec.md${RESET}"
  echo ""
  echo -e "  ${YELLOW}Nota:${RESET} Reinicia Claude.ai para que el skill quede disponible."
  echo ""
else
  error "La instalación tuvo ${ERRORS} problema(s)."
fi
