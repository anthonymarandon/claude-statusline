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
  _raw=$(grep -m1 'STATUSLINE_VERSION=' "$DEST/statusline-command.sh" 2>/dev/null | cut -d'"' -f2)
  [[ "$_raw" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && OLD_VERSION="$_raw" || OLD_VERSION="inconnu"
fi

# Télécharger les fichiers dans un dossier temporaire (rollback si échec)
echo -e "${DIM}Téléchargement des fichiers...${R}"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

FILES=(
  "statusline-command.sh"
  "update.sh"
  "uninstall.sh"
  "skills/statusline-update/SKILL.md"
  "skills/statusline-help/SKILL.md"
  "skills/statusline-uninstall/SKILL.md"
)

errors=0
for file in "${FILES[@]}"; do
  mkdir -p "$(dirname "$TMPDIR/$file")"
  if curl -fsSL "$REPO_BASE/$file" -o "$TMPDIR/$file" 2>/dev/null; then
    echo -e "${GREEN}✓${R} $file"
  else
    echo -e "${RED}✗${R} $file (échec)"
    errors=$((errors + 1))
  fi
done

echo ""
if [ "$errors" -gt 0 ]; then
  echo -e "${RED}Mise à jour annulée : $errors fichier(s) en erreur.${R}"
  echo "Aucun fichier n'a été modifié."
  exit 1
fi

# Tous les téléchargements ont réussi — déplacer d'un coup
for file in "${FILES[@]}"; do
  mkdir -p "$(dirname "$DEST/$file")"
  mv -f "$TMPDIR/$file" "$DEST/$file"
  case "$file" in *.sh) chmod +x "$DEST/$file" 2>/dev/null ;; esac
done

# Récupérer la nouvelle version
_raw=$(grep -m1 'STATUSLINE_VERSION=' "$DEST/statusline-command.sh" 2>/dev/null | cut -d'"' -f2)
[[ "$_raw" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && NEW_VERSION="$_raw" || NEW_VERSION="inconnu"

# Réinitialiser le cache de version pour refléter la mise à jour
rm -f "$DEST/.statusline-latest-version" 2>/dev/null

echo -e "${GREEN}=== Mise à jour terminée ! ===${R}"
echo -e "  ${DIM}${OLD_VERSION}${R} → ${BOLD}${NEW_VERSION}${R}"
echo ""
echo "Relancez Claude Code pour appliquer les changements."
echo ""
