#!/usr/bin/env bash
# ============================================================
# install-all.sh
# Instala todo el toolkit jr-* de una sola vez.
# ============================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'

ok()    { echo -e "${GREEN}✓${RESET} $*"; }
warn()  { echo -e "${YELLOW}⚠${RESET}  $*"; }
error() { echo -e "${RED}✗${RESET} $*" >&2; exit 1; }
section(){ echo -e "\n${BLUE}━━━ $* ${RESET}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║         jr-toolkit — Instalación completa            ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""

SKILLS=(
  "jr-init"
  "jr-build-spec"
  "jr-iterate-spec"
  "jr-exe-spec"
  "jr-verify-spec"
  "jr-status"
)

for skill in "${SKILLS[@]}"; do
  section "$skill"
  SKILL_DIR="${SCRIPT_DIR}/${skill}"

  if [[ ! -f "${SKILL_DIR}/install.sh" ]]; then
    warn "No se encontró ${skill}/install.sh — saltando"
    ERRORS=$((ERRORS+1))
    continue
  fi

  chmod +x "${SKILL_DIR}/install.sh"
  bash "${SKILL_DIR}/install.sh"
done

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

if [[ $ERRORS -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}✅ Toolkit instalado completamente${RESET}"
  echo ""
  echo -e "  ${BOLD}Comandos disponibles:${RESET}"
  echo -e "  ${BLUE}/jr-init${RESET}             → Inicializar proyecto (crear PROJECT.md)"
  echo -e "  ${BLUE}/jr-build-spec${RESET}        → Requerimiento crudo → Spec Draft"
  echo -e "  ${BLUE}/jr-iterate-spec${RESET}      → Iterar un spec existente"
  echo -e "  ${BLUE}/jr-exe-spec${RESET}          → Spec aprobado → Código implementado"
  echo -e "  ${BLUE}/jr-verify-spec${RESET}       → Verificar cobertura de CAs"
  echo -e "  ${BLUE}/jr-status${RESET}            → Dashboard de specs del proyecto"
  echo ""
  echo -e "  ${YELLOW}Reinicia Claude.ai para activar todos los skills.${RESET}"
  echo ""
else
  echo -e "${RED}⚠ Instalación con ${ERRORS} problema(s). Revisa los mensajes anteriores.${RESET}"
  echo ""
fi
