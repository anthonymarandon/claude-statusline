#!/usr/bin/env bash
set -e

# Couleurs
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[1;31m"
DIM="\033[2m"
BOLD="\033[1m"
R="\033[0m"

REPO_BASE="https://raw.githubusercontent.com/anthonymarandon/claude-statusline/main"
REPO_URL="https://github.com/anthonymarandon/claude-statusline"

# Sélecteur interactif avec flèches (fonctionne avec curl | bash via /dev/tty)
# Usage: select_option "option1" "option2" ...
# Retourne l'index (0, 1, ...) dans la variable $SELECTED
select_option() {
  local options=("$@")
  local selected=0
  local count=${#options[@]}

  # Cacher le curseur
  printf "\033[?25l" > /dev/tty
  # Restaurer le curseur à la sortie
  trap 'printf "\033[?25h" > /dev/tty' RETURN

  while true; do
    # Afficher les options
    for i in "${!options[@]}"; do
      if [ "$i" -eq "$selected" ]; then
        echo -e "  ${CYAN}▸ ${BOLD}${options[$i]}${R}" > /dev/tty
      else
        echo -e "  ${DIM}  ${options[$i]}${R}" > /dev/tty
      fi
    done

    # Lire une touche depuis /dev/tty
    IFS= read -rsn1 key < /dev/tty
    if [[ "$key" == $'\x1b' ]]; then
      read -rsn2 key < /dev/tty
      case "$key" in
        '[A') ((selected > 0)) && ((selected--)) ;;
        '[B') ((selected < count - 1)) && ((selected++)) ;;
      esac
    elif [[ "$key" == "" ]]; then
      break
    fi

    # Remonter pour redessiner
    for ((i=0; i<count; i++)); do
      printf "\033[1A\033[2K" > /dev/tty
    done
  done

  SELECTED=$selected
}

echo ""
echo -e "${CYAN}=== Claude Code Custom Statusline ===${R}"
echo ""

# Vérifier jq
if ! command -v jq &> /dev/null; then
  echo -e "${RED}Erreur : jq n'est pas installé.${R}"
  echo ""
  echo "Installez-le avec :"
  case "$(uname -s)" in
    Darwin) echo "  brew install jq" ;;
    Linux)  echo "  sudo apt install jq  (Debian/Ubuntu)"
            echo "  sudo pacman -S jq    (Arch)"
            echo "  sudo dnf install jq  (Fedora)" ;;
    *)      echo "  Voir https://jqlang.github.io/jq/download/" ;;
  esac
  echo ""
  exit 1
fi
echo -e "${GREEN}✓${R} jq détecté ($(jq --version))"

# Vérifier curl
if ! command -v curl &> /dev/null; then
  echo -e "${RED}Erreur : curl n'est pas installé.${R}"
  exit 1
fi

# Vérifier que le dossier ~/.claude existe
if [ ! -d "$HOME/.claude" ]; then
  echo -e "${YELLOW}Création du dossier ~/.claude...${R}"
  mkdir -p "$HOME/.claude"
fi
echo -e "${GREEN}✓${R} Dossier ~/.claude trouvé"

# -- Vérifier les fichiers existants et expliquer les modifications --
SETTINGS="$HOME/.claude/settings.json"
SCRIPT_DEST="$HOME/.claude/statusline-command.sh"
STATUSLINE_CONFIG='{"type":"command","command":"bash ~/.claude/statusline-command.sh"}'
changes=()

UPDATE_SKILL_DEST="$HOME/.claude/skills/statusline-update/SKILL.md"
UPDATE_SCRIPT_DEST="$HOME/.claude/update.sh"

if [ -f "$SCRIPT_DEST" ]; then
  changes+=("  ${YELLOW}~/.claude/statusline-command.sh${R} sera mis à jour")
fi

if [ -f "$SETTINGS" ]; then
  if jq -e '.statusLine' "$SETTINGS" > /dev/null 2>&1; then
    changes+=("  ${YELLOW}~/.claude/settings.json${R} : la clé ${BOLD}statusLine${R} sera mise à jour")
  else
    changes+=("  ${YELLOW}~/.claude/settings.json${R} : la clé ${BOLD}statusLine${R} sera ajoutée")
  fi
else
  changes+=("  ${YELLOW}~/.claude/settings.json${R} sera créé")
fi

if [ -f "$UPDATE_SKILL_DEST" ]; then
  changes+=("  ${YELLOW}~/.claude/skills/statusline-update/SKILL.md${R} sera mis à jour")
else
  changes+=("  ${YELLOW}~/.claude/skills/statusline-update/SKILL.md${R} sera créé (commande ${BOLD}/statusline-update${R})")
fi

HELP_SKILL_DEST="$HOME/.claude/skills/statusline-help/SKILL.md"
if [ -f "$HELP_SKILL_DEST" ]; then
  changes+=("  ${YELLOW}~/.claude/skills/statusline-help/SKILL.md${R} sera mis à jour")
else
  changes+=("  ${YELLOW}~/.claude/skills/statusline-help/SKILL.md${R} sera créé (commande ${BOLD}/statusline-help${R})")
fi

UNINSTALL_SKILL_DEST="$HOME/.claude/skills/statusline-uninstall/SKILL.md"
UNINSTALL_SCRIPT_DEST="$HOME/.claude/uninstall.sh"
if [ -f "$UNINSTALL_SKILL_DEST" ]; then
  changes+=("  ${YELLOW}~/.claude/skills/statusline-uninstall/SKILL.md${R} sera mis à jour")
else
  changes+=("  ${YELLOW}~/.claude/skills/statusline-uninstall/SKILL.md${R} sera créé (commande ${BOLD}/statusline-uninstall${R})")
fi

if [ -f "$UPDATE_SCRIPT_DEST" ]; then
  changes+=("  ${YELLOW}~/.claude/update.sh${R} sera mis à jour")
else
  changes+=("  ${YELLOW}~/.claude/update.sh${R} sera créé (script de mise à jour)")
fi

if [ ${#changes[@]} -gt 0 ]; then
  echo ""
  echo -e "${YELLOW}Modifications prévues :${R}"
  for c in "${changes[@]}"; do
    echo -e "$c"
  done
  echo ""
  echo -e "Continuer ?"
  select_option "Oui, continuer" "Non, annuler"
  echo ""
  if [ "$SELECTED" -eq 1 ]; then
    echo -e "${RED}Installation annulée.${R}"
    exit 0
  fi
fi

# Télécharger le script
SCRIPT_URL="$REPO_BASE/statusline-command.sh"

echo -e "${GREEN}→ Installation de la statusline${R}"
echo -e "${DIM}  Téléchargement depuis GitHub...${R}"

if ! curl -fsSL "$SCRIPT_URL" -o "$SCRIPT_DEST"; then
  echo -e "${RED}Erreur : impossible de télécharger le script.${R}"
  echo -e "${DIM}URL : $SCRIPT_URL${R}"
  exit 1
fi

chmod +x "$SCRIPT_DEST"
echo -e "${GREEN}✓${R} Script installé dans ~/.claude/statusline-command.sh"

# Configurer settings.json
if [ -f "$SETTINGS" ]; then
  tmp=$(mktemp)
  jq --argjson sl "$STATUSLINE_CONFIG" '.statusLine = $sl' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
  echo -e "${GREEN}✓${R} statusLine configuré dans settings.json"
else
  echo "{\"statusLine\":$STATUSLINE_CONFIG}" | jq '.' > "$SETTINGS"
  echo -e "${GREEN}✓${R} settings.json créé"
fi

# Installer le skill /statusline-update
UPDATE_SKILL_URL="$REPO_BASE/skills/statusline-update/SKILL.md"
mkdir -p "$HOME/.claude/skills/statusline-update"

if curl -fsSL "$UPDATE_SKILL_URL" -o "$UPDATE_SKILL_DEST"; then
  echo -e "${GREEN}✓${R} Commande /statusline-update installée"
else
  echo -e "${YELLOW}⚠${R}  Impossible de télécharger le skill /statusline-update (non bloquant)"
fi

# Installer le skill /statusline-help
HELP_SKILL_URL="$REPO_BASE/skills/statusline-help/SKILL.md"
mkdir -p "$HOME/.claude/skills/statusline-help"

if curl -fsSL "$HELP_SKILL_URL" -o "$HELP_SKILL_DEST"; then
  echo -e "${GREEN}✓${R} Commande /statusline-help installée"
else
  echo -e "${YELLOW}⚠${R}  Impossible de télécharger le skill /statusline-help (non bloquant)"
fi

# Installer le skill /statusline-uninstall
UNINSTALL_SKILL_URL="$REPO_BASE/skills/statusline-uninstall/SKILL.md"
mkdir -p "$HOME/.claude/skills/statusline-uninstall"

if curl -fsSL "$UNINSTALL_SKILL_URL" -o "$UNINSTALL_SKILL_DEST"; then
  echo -e "${GREEN}✓${R} Commande /statusline-uninstall installée"
else
  echo -e "${YELLOW}⚠${R}  Impossible de télécharger le skill /statusline-uninstall (non bloquant)"
fi

# Installer le script de mise à jour
UPDATE_SCRIPT_URL="$REPO_BASE/update.sh"

if curl -fsSL "$UPDATE_SCRIPT_URL" -o "$UPDATE_SCRIPT_DEST"; then
  chmod +x "$UPDATE_SCRIPT_DEST"
  echo -e "${GREEN}✓${R} Script de mise à jour installé"
else
  echo -e "${YELLOW}⚠${R}  Impossible de télécharger le script de mise à jour (non bloquant)"
fi

# Installer le script de désinstallation
UNINSTALL_SCRIPT_URL="$REPO_BASE/uninstall.sh"

if curl -fsSL "$UNINSTALL_SCRIPT_URL" -o "$UNINSTALL_SCRIPT_DEST"; then
  chmod +x "$UNINSTALL_SCRIPT_DEST"
  echo -e "${GREEN}✓${R} Script de désinstallation installé"
else
  echo -e "${YELLOW}⚠${R}  Impossible de télécharger le script de désinstallation (non bloquant)"
fi

# Terminé
echo ""
echo -e "${GREEN}=== Installation terminée ! ===${R}"
echo ""
echo "Relancez Claude Code pour voir votre nouvelle statusline."
echo ""
echo -e "Mises à jour :    tapez ${BOLD}/statusline-update${R} dans Claude Code"
echo -e "Désinstallation : tapez ${BOLD}/statusline-uninstall${R} dans Claude Code"
echo -e "ou lancez directement : ${CYAN}bash ~/.claude/update.sh${R} / ${CYAN}bash ~/.claude/uninstall.sh${R}"
echo ""
