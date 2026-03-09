#!/usr/bin/env bash
# Claude Code Statusline — désinstallation complète
# Appelé par le skill /statusline-uninstall ou directement en CLI

set -e

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
CYAN="\033[1;36m"
DIM="\033[2m"
BOLD="\033[1m"
R="\033[0m"

DEST="$HOME/.claude"

echo ""
echo -e "${CYAN}=== Désinstallation Claude Code Statusline ===${R}"
echo ""

# Vérifier que l'installation existe
if [ ! -f "$DEST/statusline-command.sh" ]; then
  echo -e "${YELLOW}La statusline ne semble pas installée.${R}"
  echo "Rien à désinstaller."
  exit 0
fi

# Récupérer la version actuelle
VERSION="inconnu"
if [ -f "$DEST/statusline-command.sh" ]; then
  VERSION=$(grep -m1 'STATUSLINE_VERSION=' "$DEST/statusline-command.sh" 2>/dev/null | cut -d'"' -f2 || echo "inconnu")
fi

echo -e "Version installée : ${BOLD}${VERSION}${R}"
echo ""

# Liste des fichiers et dossiers à supprimer
FILES=(
  "$DEST/statusline-command.sh"
  "$DEST/update.sh"
  "$DEST/uninstall.sh"
  "$DEST/.statusline-latest-version"
  "/tmp/claude-statusline-input.json"
)

SKILL_DIRS=(
  "$DEST/skills/session-info"
  "$DEST/skills/statusline-update"
  "$DEST/skills/statusline-help"
  "$DEST/skills/statusline-uninstall"
)

echo -e "${YELLOW}Fichiers qui seront supprimés :${R}"
for f in "${FILES[@]}"; do
  if [ -f "$f" ]; then
    echo -e "  ${DIM}$f${R}"
  fi
done
for d in "${SKILL_DIRS[@]}"; do
  if [ -d "$d" ]; then
    echo -e "  ${DIM}$d/${R}"
  fi
done
if [ -f "$DEST/settings.json" ] && command -v jq &> /dev/null && jq -e '.statusLine' "$DEST/settings.json" > /dev/null 2>&1; then
  echo -e "  ${DIM}$DEST/settings.json${R} : la clé ${BOLD}statusLine${R} sera retirée"
fi
echo ""

# Confirmation
echo -e "${RED}Cette action est irréversible.${R} Continuer ? (o/N)"
read -r confirm < /dev/tty 2>/dev/null || read -r confirm
if [[ "$confirm" != "o" && "$confirm" != "O" && "$confirm" != "oui" && "$confirm" != "Oui" ]]; then
  echo ""
  echo -e "${YELLOW}Désinstallation annulée.${R}"
  exit 0
fi

echo ""

# Supprimer les fichiers
for f in "${FILES[@]}"; do
  if [ -f "$f" ]; then
    rm -f "$f"
    echo -e "${GREEN}✓${R} Supprimé : $f"
  fi
done

# Supprimer les dossiers de skills
for d in "${SKILL_DIRS[@]}"; do
  if [ -d "$d" ]; then
    rm -rf "$d"
    echo -e "${GREEN}✓${R} Supprimé : $d/"
  fi
done

# Nettoyer le dossier skills s'il est vide
if [ -d "$DEST/skills" ] && [ -z "$(ls -A "$DEST/skills" 2>/dev/null)" ]; then
  rmdir "$DEST/skills"
  echo -e "${GREEN}✓${R} Supprimé : $DEST/skills/ (vide)"
fi

# Retirer la clé statusLine de settings.json
if [ -f "$DEST/settings.json" ] && command -v jq &> /dev/null; then
  if jq -e '.statusLine' "$DEST/settings.json" > /dev/null 2>&1; then
    tmp=$(mktemp)
    jq 'del(.statusLine)' "$DEST/settings.json" > "$tmp" && mv "$tmp" "$DEST/settings.json"
    echo -e "${GREEN}✓${R} Clé statusLine retirée de settings.json"
  fi
fi

echo ""
echo -e "${GREEN}=== Désinstallation terminée ! ===${R}"
echo ""
echo "La statusline a été complètement supprimée."
echo "Relancez Claude Code pour appliquer les changements."
echo ""
