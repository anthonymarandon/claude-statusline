#!/usr/bin/env bash
# Claude Code Statusline — mise à jour non-interactive
# Appelé par le skill /statusline-update ou directement en CLI

set -e

GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
DIM="\033[2m"
BOLD="\033[1m"
R="\033[0m"

REPO_BASE="https://raw.githubusercontent.com/anthonymarandon/claude-statusline/main"
DEST="$HOME/.claude"

echo ""
echo -e "${CYAN}=== Mise à jour Claude Code Statusline ===${R}"
echo ""

# Vérifier que l'installation existe
if [ ! -f "$DEST/statusline-command.sh" ]; then
  echo -e "${RED}Erreur : statusline non installée.${R}"
  echo "Lancez d'abord l'installation :"
  echo "  curl -fsSL $REPO_BASE/install.sh | bash"
  exit 1
fi

# Récupérer la version actuelle avant mise à jour
OLD_VERSION="inconnu"
if [ -f "$DEST/statusline-command.sh" ]; then
  OLD_VERSION=$(grep -m1 'STATUSLINE_VERSION=' "$DEST/statusline-command.sh" 2>/dev/null | cut -d'"' -f2 || echo "inconnu")
fi

# Télécharger les fichiers
echo -e "${DIM}Téléchargement des fichiers...${R}"

FILES=(
  "statusline-command.sh"
  "update.sh"
  "skills/session-info/SKILL.md"
  "skills/statusline-update/SKILL.md"
  "skills/statusline-help/SKILL.md"
)

errors=0
for file in "${FILES[@]}"; do
  dir=$(dirname "$DEST/$file")
  mkdir -p "$dir"

  if curl -fsSL "$REPO_BASE/$file" -o "$DEST/$file" 2>/dev/null; then
    echo -e "${GREEN}✓${R} $file"
  else
    echo -e "${RED}✗${R} $file (échec)"
    ((errors++))
  fi
done

# Rendre les scripts exécutables
chmod +x "$DEST/statusline-command.sh" 2>/dev/null
chmod +x "$DEST/update.sh" 2>/dev/null

# Récupérer la nouvelle version
NEW_VERSION=$(grep -m1 'STATUSLINE_VERSION=' "$DEST/statusline-command.sh" 2>/dev/null | cut -d'"' -f2 || echo "inconnu")

# Réinitialiser le cache de version pour refléter la mise à jour
rm -f "$DEST/.statusline-latest-version" 2>/dev/null

echo ""
if [ "$errors" -eq 0 ]; then
  echo -e "${GREEN}=== Mise à jour terminée ! ===${R}"
  echo -e "  ${DIM}${OLD_VERSION}${R} → ${BOLD}${NEW_VERSION}${R}"
else
  echo -e "${RED}Mise à jour partielle : $errors fichier(s) en erreur.${R}"
fi
echo ""
echo "Relancez Claude Code pour appliquer les changements."
echo ""
