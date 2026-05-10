#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="jr-sync"
SKILL_DEST="${HOME}/.claude/skills/${SKILL_NAME}"
COMMAND_DEST="${HOME}/.claude/commands/${SKILL_NAME}.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$(dirname "${SKILL_DEST}")"
mkdir -p "$(dirname "${COMMAND_DEST}")"

rm -rf "${SKILL_DEST}"
cp -r "${SCRIPT_DIR}" "${SKILL_DEST}"

if [[ -f "${SCRIPT_DIR}/command.md" ]]; then
  cp "${SCRIPT_DIR}/command.md" "${COMMAND_DEST}"
fi

echo "✓ ${SKILL_NAME} instalado"
echo "  Skill:   ${SKILL_DEST}"
echo "  Command: ${COMMAND_DEST}"
