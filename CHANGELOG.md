# Changelog

## 2.2.0

- Feat : affichage des tokens **input** (↓) en violet doux et **output** (↑) en bleu ciel sur la ligne Tokens
- Feat : taux de **cache hit** (💾 XX%) avec volume de tokens lus depuis le cache, coloré selon l'efficacité (vert ≥ 75%, jaune 40–75%, orange < 40%)
- Feat : nouvelles variables jq extraites : `total_input`, `cache_read`, `cache_create`
- Feat : nouvelles couleurs `C_INPUT` (violet doux) et `C_CACHE` (aqua) pour les tokens
- Docs : ajout de la section « Avertissement — Pratiques non autorisées » dans le README
- Docs : documentation détaillée des cas d'usage non couverts (`maquette/usage-notice-warning/`)
- Docs : mise à jour de la maquette tokens avec les variantes input/output et cache hit
- Suppression : fonctionnalité d'affichage des quotas d'abonnement (usage 5h/7j) — repose sur un endpoint API non documenté et viole les CGU d'Anthropic (voir `maquette/usage-notice-warning/usage-quota-non-inclus.md`)

## 2.1.0

- Fix : validation après parsing jq — affiche "⚠ Statusline : données indisponibles" si le JSON est malformé
- Fix : fichier debug déplacé vers `~/.claude/.statusline-debug.json` avec permissions `600` (plus de leak dans `/tmp/`)
- Fix : désinstallation sécurisée — terminal interactif obligatoire, timeout 30s, plus de fallback stdin
- Fix : validation semver (`X.Y.Z`) avant toute comparaison de versions
- Fix : vérification de `git` avant utilisation des commandes git
- Perf : 17 appels `awk` réduits à 2 — comparaisons via arithmétique bash native (centièmes)
- Refactor : patterns curl factorisés dans `_download_file` (`install.sh`)
- Feat : mise à jour atomique avec rollback — tous les fichiers sont téléchargés dans un dossier temporaire avant déplacement (`update.sh`)
- Feat : détection des capacités couleur du terminal (`NO_COLOR`, `TERM=dumb`, fallback 8 couleurs ANSI)
- Docs : ajout des messages contextuels dans le help et le README
- Docs : suppression de la section `/session-info` du README (supprimé en v2.0.0)
- Docs : section troubleshooting ajoutée au README
- Docs : chemin debug mis à jour dans le README

## 2.0.0

- Nouvelle ligne `💬 Conseil` : messages contextuels automatiques basés sur l'activité de la session
  - 12 scénarios par priorité décroissante : contexte critique, surchauffe (coût+API), marathon sans commit, durée longue, session productive, session économique, etc.
  - Combinaison intelligente de plusieurs facteurs (coût, API, durée, lignes, git dirty, contexte)
- Suppression du skill `/session-info` (coach humoristique), remplacé par les messages contextuels intégrés
- Fix `update.sh` : téléchargement atomique via fichier temporaire + `mv` (évite les crashs si la statusline est en cours d'exécution pendant la mise à jour)
- Fix `update.sh` : `chmod +x` appliqué immédiatement après chaque téléchargement (au lieu d'après la boucle)
- Fix `update.sh` : remplacement de `((errors++))` par `errors=$((errors + 1))` pour compatibilité avec `set -e`

## 1.9.0

- Commande `/statusline-uninstall` : désinstallation complète de la statusline en une seule commande
- Script `uninstall.sh` : supprime tous les fichiers, skills, cache et retire la clé `statusLine` de `settings.json` (sans toucher au reste de la configuration)
- Confirmation obligatoire avant suppression (irréversible)
- `install.sh` et `update.sh` installent et mettent à jour automatiquement le skill et le script de désinstallation

## 1.8.0

- Indicateur git dirty : un `●` orange apparaît après la branche quand il y a des modifications non commitées
- Durée de session affichée sur la ligne API avec couleur adaptative (vert < 30 min, jaune > 30 min, orange > 1h, rouge > 2h)
- Mode de sortie affiché à côté du modèle : `🏃 sprinter` (mode fast) ou `🤓 concentré` (mode verbose)
- Fallback si `jq` est absent : message d'aide avec la commande d'installation adaptée à l'OS (macOS, Linux, Windows)
- Vérification des mises à jour synchrone au démarrage quand le cache est expiré ou absent (l'indicateur `⬆` s'affiche dès le premier rendu)

## 1.7.0

- Nouvelle ligne `📡 Statusline` dédiée à la version de la statusline et aux notifications de mise à jour
- Séparation claire entre le modèle Claude et la version de la statusline (évite la confusion avec une MAJ du modèle)
- La ligne `🤖 Modèle` n'affiche plus que le nom du modèle Claude
- Mise à jour du skill `/statusline-help` pour refléter le nouveau layout

## 1.6.0

- Nouveau layout vertical : un indicateur par ligne avec label et emoji pour une lecture claire
  - 📂 Dossier, 🤖 Modèle, 💰 Coût, 📝 Lignes, ⚡ API, ✎ Tokens, 📊 Contexte
- Retrait du responsive (non fonctionnel dans le contexte du CLI)
- Couleur des lignes supprimées : orange au lieu de rouge pour une meilleure lisibilité
- Nouveau skill `/statusline-help` : explique visuellement chaque indicateur de la statusline
- Vérification des mises à jour toutes les 2 minutes (au lieu d'1 heure)

## 1.4.1

- Refonte du ton de `/session-info` : plus fun, plus personnel, ambiance pote dev qui charrie

## 1.4.0

- Affichage multi-ligne : la statusline s'affiche désormais sur 2 lignes pour une meilleure lisibilité
  - Ligne 1 : chemin + branche git + modèle + version
  - Ligne 2 : coût + lignes modifiées + ratio API + tokens output + barre de contexte
- Meilleure adaptation aux fenêtres étroites

## 1.3.0

- Notification de mise à jour : la statusline affiche `⬆ vX.Y.Z` quand une nouvelle version est disponible
- Vérification automatique via l'API GitHub (1 check/heure, cache local, fetch asynchrone)
- Script `update.sh` pour mise à jour non-interactive
- Commande `/statusline-update` pour mettre à jour directement depuis Claude Code
- Commande `/release` interne au projet (checklist avant publication)

## 1.2.0

- Icônes adaptatives pour le ratio API : 🌿 (économe), ⚡ (actif), 🔥 (intensif)
- Sélecteur interactif avec flèches dans l'installateur (remplace O/n)
- Message de fin simplifié : renvoi vers le dépôt GitHub

## 1.1.0

- Installateur simplifié : une seule commande curl, plus de git clone
- Unification en une seule statusline (suppression du système V1/V2)

## 1.0.0

- Chemin courant en cyan bold avec branche git en magenta
- Nom du modèle en hot pink avec icône robot
- Version de Claude Code en gris
- Coût dynamique avec couleur adaptative (vert < 1$, jaune 1-5$, rouge > 5$)
- Lignes ajoutées (vert néon) / supprimées (rouge néon)
- Ratio API : pourcentage du temps passé en appels Claude vs temps total
- Compteur de tokens output générés dans la session
- Barre de progression du contexte (█/░) avec couleur adaptative
- Alerte visuelle (fond rouge) quand le contexte dépasse 75%
- Alerte clignotante si le contexte dépasse 200k tokens
- Séparateurs violets
- Compatibilité locale macOS (LANG=C pour le formatage décimal)
- Dump automatique du JSON dans `/tmp/claude-statusline-input.json`
- Commande `/session-info` pour un résumé en langage naturel
