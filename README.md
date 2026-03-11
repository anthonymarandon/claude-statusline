# Claude Code Custom Statusline

> :art: Une statusline personnalisée et colorée pour [Claude Code](https://docs.anthropic.com/en/docs/claude-code), le CLI officiel d'Anthropic.

---

## :eyes: Aperçu

Statusline verticale avec un indicateur par ligne, labels clairs, coût dynamique, ratio API avec icônes adaptatives, tokens output, alertes contexte — tout ce qu'il faut pour garder le contrôle de sa session.

![Preview](screenshots/preview.png)

---

## :rocket: Installation

```bash
curl -fsSL https://raw.githubusercontent.com/anthonymarandon/claude-statusline/main/install.sh | bash
```

> Le script télécharge le fichier dans `~/.claude/`, configure `settings.json`, et vous demande confirmation si des fichiers existants seront modifiés.

---

## :arrows_counterclockwise: Mise à jour

La statusline vérifie automatiquement (toutes les 2 minutes) si une nouvelle version est disponible. Si c'est le cas, un indicateur `⬆ vX.Y.Z` apparaît dans la statusline.

Pour mettre à jour, deux options :

```bash
# Depuis Claude Code (recommandé)
/statusline-update

# Ou directement en terminal
bash ~/.claude/update.sh
```

---

## :speech_balloon: Commandes

### Commande `/statusline-help`

Tapez `/statusline-help` dans Claude Code pour obtenir une **explication visuelle** de chaque indicateur de la statusline : ce qu'il mesure, les codes couleur, et quand il apparaît.

### Commande `/statusline-update`

Tapez `/statusline-update` dans Claude Code pour lancer la mise à jour de la statusline sans quitter votre session.

### Commande `/statusline-uninstall`

Tapez `/statusline-uninstall` dans Claude Code pour **désinstaller complètement** la statusline. Le script supprime tous les fichiers associés (scripts, skills, cache) et retire la clé `statusLine` de `settings.json` sans toucher au reste de votre configuration.

> Une confirmation est demandée avant toute suppression.

---

## :bar_chart: Fonctionnalités

| Fonctionnalité | Détail |
|---|---|
| :file_folder: Chemin | Répertoire courant avec `~` en cyan |
| :deciduous_tree: Branche git | Branche active en magenta + ● orange si dirty |
| :robot: Modèle | Nom du modèle Claude (ex: Opus 4.6) en rose |
| :satellite: Statusline | Version de la statusline + indicateur de mise à jour |
| :dollar: Coût dynamique | Couleur adaptative selon le montant |
| :heavy_plus_sign: :heavy_minus_sign: Lignes | Lignes ajoutées (vert) / supprimées (orange) |
| :zap: Ratio API | Icône et couleur selon l'intensité + durée de session |
| :pencil2: Tokens output | Tokens générés par Claude dans la session |
| :bar_chart: Barre contexte | Barre `█░` colorée selon le remplissage |
| :rotating_light: Alerte > 75% | Fond rouge quand le contexte se remplit |
| :warning: Alerte > 200k | Avertissement clignotant si la fenêtre explose |
| :arrow_up: Mise à jour | Indicateur vert quand une nouvelle version est disponible |
| :speech_balloon: Message contextuel | Conseil dynamique selon l'état de la session |
| :grey_question: `/statusline-help` | Explique chaque indicateur de la statusline |

### :dollar: Coût dynamique

La couleur du coût change selon le montant pour vous alerter visuellement :

| Couleur | Seuil | Signification |
|---|---|---|
| :green_circle: Vert | < 1$ | Tout va bien |
| :yellow_circle: Jaune | 1$ – 5$ | Ça commence à chiffrer |
| :red_circle: Rouge | > 5$ | Session coûteuse, pensez à en ouvrir une nouvelle |

### :zap: Ratio API

Le pourcentage du temps passé à **attendre les réponses de Claude** par rapport au temps total de la session. L'icône change selon l'intensité :

| Icône | Couleur | Seuil | Signification |
|---|---|---|---|
| :seedling: | :green_circle: Vert | ≤ 40% | Session économe |
| :zap: | :yellow_circle: Jaune | 40–70% | Échange actif |
| :fire: | :orange_circle: Orange | > 70% | Claude travaille en continu |

### :speech_balloon: Messages contextuels

La ligne `💬 Conseil` affiche un message dynamique qui s'adapte à l'état de votre session. Le message est choisi automatiquement selon le coût, la durée, le ratio API, le remplissage du contexte et les lignes modifiées.

| Exemple | Condition |
|---|---|
| 🚀 Très productif ! | +100 lignes modifiées, coût < 2$ |
| ⚠️ Pensez à démarrer une nouvelle session | Coût > 3$ ou contexte > 75% |
| 🛑 +2h de session | Durée > 2h |
| 😴 Session calme | Peu d'activité |
| ✨ Session efficace et économique | Coût < 1$, API ≤ 40%, durée < 15min |
| 💚 Session très économique | Coût < 0.50$ |

---

## :package: Prérequis

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installé
- [`jq`](https://jqlang.github.io/jq/) — outil de parsing JSON en ligne de commande

> :bulb: `jq` est souvent préinstallé sur macOS. Le script d'installation le vérifie automatiquement.

| OS | Installer jq |
|---|---|
| :apple: macOS | `brew install jq` |
| :penguin: Ubuntu / Debian | `sudo apt install jq` |
| :penguin: Arch | `sudo pacman -S jq` |
| :penguin: Fedora | `sudo dnf install jq` |
| :computer: Windows | `winget install jqlang.jq` ou `choco install jq` |

---

## :art: Personnalisation

Modifiez les variables de couleur en haut du script :

```bash
C_PATH="\033[1;36m"        # Chemin — cyan
C_GIT="\033[1;35m"         # Branche git — magenta
C_MODEL="\033[1;38;5;213m" # Modèle — rose
C_ADD="\033[1;38;5;46m"    # Lignes ajoutées — vert
C_DEL="\033[1;38;5;208m"   # Lignes supprimées — orange
```

---

## :bug: Debug

Le JSON reçu de Claude Code est sauvegardé automatiquement :

```bash
cat ~/.claude/.statusline-debug.json
```

<details>
<summary>:mag: Voir tous les champs JSON disponibles</summary>

| Champ | Description |
|---|---|
| `session_id` | Identifiant de la session |
| `version` | Version de Claude Code |
| `model.id` / `model.display_name` | Modèle utilisé |
| `workspace.current_dir` | Répertoire courant |
| `cost.total_cost_usd` | Coût en USD |
| `cost.total_duration_ms` | Durée totale (ms) |
| `cost.total_api_duration_ms` | Durée API (ms) |
| `cost.total_lines_added` / `removed` | Lignes modifiées |
| `context_window.used_percentage` | % contexte utilisé |
| `context_window.total_output_tokens` | Tokens générés |
| `exceeds_200k_tokens` | Dépasse 200k ? |

</details>

---

## :warning: Note locale macOS / Europe

Si votre système utilise la virgule comme séparateur décimal, le formatage des prix peut casser. Le script gère ce cas avec `LANG=C awk`. Gardez cette syntaxe si vous modifiez le script :

```bash
echo "$cost_usd" | LANG=C awk '{printf "%.4f", $1}'
```

---

## :wrench: Troubleshooting

<details>
<summary><strong>La statusline ne s'affiche pas</strong></summary>

1. Vérifiez que `~/.claude/settings.json` contient bien la clé `statusLine` :
   ```bash
   cat ~/.claude/settings.json | jq '.statusLine'
   ```
2. Vérifiez que le script existe et est exécutable :
   ```bash
   ls -la ~/.claude/statusline-command.sh
   ```
3. Relancez Claude Code après l'installation.

</details>

<details>
<summary><strong>Erreur de parsing JSON / "données indisponibles"</strong></summary>

1. Vérifiez que `jq` est installé : `jq --version`
2. Inspectez le dernier JSON reçu :
   ```bash
   cat ~/.claude/.statusline-debug.json
   ```
3. Si le fichier est vide ou absent, le problème vient de l'entrée envoyée par Claude Code.

</details>

<details>
<summary><strong>Couleurs absentes ou caractères bizarres</strong></summary>

- Si votre terminal ne supporte pas les 256 couleurs, la statusline bascule automatiquement en 8 couleurs basiques.
- Si vous utilisez `NO_COLOR=1` ou `TERM=dumb`, les couleurs sont désactivées (convention [no-color.org](https://no-color.org/)).
- Vérifiez le support couleur : `tput colors` (doit afficher `256` ou plus).

</details>

<details>
<summary><strong>Problèmes de permissions</strong></summary>

Les scripts doivent être exécutables :
```bash
chmod +x ~/.claude/statusline-command.sh ~/.claude/update.sh ~/.claude/uninstall.sh
```

Le fichier de debug doit être en permissions `600` :
```bash
ls -la ~/.claude/.statusline-debug.json
```

</details>

<details>
<summary><strong>La mise à jour échoue</strong></summary>

1. Vérifiez votre connexion internet
2. Testez l'accès à GitHub : `curl -sf https://api.github.com/repos/anthonymarandon/claude-statusline/tags?per_page=1 | jq '.[0].name'`
3. En cas d'échec partiel, aucun fichier n'est modifié (rollback automatique). Réessayez plus tard.

</details>

---

## :scroll: Licence

MIT — Voir [LICENSE](LICENSE).
