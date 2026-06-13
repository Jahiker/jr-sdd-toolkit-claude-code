#!/usr/bin/env bash
# ============================================================
# install-all.sh
# Instala todos los skills de jr-toolkit en ~/.claude/
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
CLAUDE_COMMANDS_DIR="${HOME}/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${SCRIPT_DIR}/skills"

SKILLS=(
  jr-init
  jr-vision
  jr-arch
  jr-roadmap
  jr-build-spec
  jr-iterate-spec
  jr-patch
  jr-worklist
  jr-exe-spec
  jr-verify-spec
  jr-fix-spec
  jr-status
  jr-sync
  jr-drift
  jr-progress
)

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║         jr-toolkit — Spec-Driven Development         ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""

mkdir -p "${CLAUDE_SKILLS_DIR}"
mkdir -p "${CLAUDE_COMMANDS_DIR}"

for skill in "${SKILLS[@]}"; do
  src="${SKILLS_SRC}/${skill}"
  dest_skill="${CLAUDE_SKILLS_DIR}/${skill}"
  src_command="${src}/command.md"
  dest_command="${CLAUDE_COMMANDS_DIR}/${skill}.md"

  if [[ ! -d "${src}" ]]; then
    echo -e "${YELLOW}⚠  ${skill} — no encontrado, saltando${RESET}"
    continue
  fi

  rm -rf "${dest_skill}"
  cp -r "${src}" "${dest_skill}"

  if [[ -f "${src_command}" ]]; then
    cp "${src_command}" "${dest_command}"
  fi

  echo -e "${GREEN}✓${RESET} ${skill}"
done

echo ""
echo -e "${GREEN}${BOLD}✅ Toolkit instalado correctamente${RESET}"
echo ""
echo -e "  ${BOLD}Comandos disponibles en Claude Code:${RESET}"
echo -e "  ${BLUE}/jr-init${RESET}             → Inicializar proyecto (PROJECT.md)"
echo -e "  ${BLUE}/jr-vision${RESET}           → Idea → Documento de visión"
echo -e "  ${BLUE}/jr-arch${RESET}             → Visión → Arquitectura técnica"
echo -e "  ${BLUE}/jr-roadmap${RESET}          → Arquitectura → Roadmap"
echo -e "  ${BLUE}/jr-build-spec${RESET}       → Requerimiento → Spec Draft"
echo -e "  ${BLUE}/jr-iterate-spec${RESET}     → Iterar un spec existente"
echo -e "  ${BLUE}/jr-patch${RESET}            → Cambio rápido de bajo riesgo (sin spec)"
echo -e "  ${BLUE}/jr-worklist${RESET}         → Documento QA → worklist punto por punto"
echo -e "  ${BLUE}/jr-exe-spec${RESET}         → Implementar un spec"
echo -e "  ${BLUE}/jr-verify-spec${RESET}      → Verificar cobertura de CAs"
echo -e "  ${BLUE}/jr-fix-spec${RESET}         → Diagnosticar y corregir bugs"
echo -e "  ${BLUE}/jr-status${RESET}           → Dashboard de specs"
echo -e "  ${BLUE}/jr-sync${RESET}             → Sincronizar PROJECT.md con el proyecto"
echo -e "  ${BLUE}/jr-drift${RESET}            → Detectar divergencia specs ↔ código"
echo -e "  ${BLUE}/jr-progress${RESET}         → Log narrativo de progreso"
echo ""
echo -e "  ${YELLOW}Reinicia Claude Code para activar los skills.${RESET}"
echo ""
