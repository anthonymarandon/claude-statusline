---
name: statusline-help
description: Explique visuellement chaque indicateur de la statusline Claude Code
---

# Guide de la Statusline

Tu dois expliquer à l'utilisateur comment lire sa statusline Claude Code. Reproduis visuellement le layout actuel puis détaille chaque ligne.

## Ce que tu affiches

Commence par afficher un exemple visuel de la statusline telle qu'elle apparaît dans le terminal (utilise un bloc de code avec des valeurs d'exemple réalistes) :

```
📂 Dossier    ~/mon-projet  main ●
🤖 Modèle     Claude 4.6 Opus
💰 Coût       $1.2450
📝 Lignes     +47 -12
⚡ API        🔥65% │ 45m12s
✎ Tokens     8.3k
📊 Contexte   ████░░░░░░ 40%
📡 Statusline v2.0.0  ⬆ v2.0.0 dispo
💬 Conseil    ✨ Session efficace et économique
```

Puis explique chaque ligne :

### 📂 Dossier
Le répertoire de travail actuel + la branche Git si le projet est un dépôt Git.
- Un **●** orange apparaît après le nom de la branche s'il y a des modifications non commitées (fichiers modifiés, ajoutés ou supprimés).

### 🤖 Modèle
Le modèle Claude utilisé (Opus, Sonnet, Haiku).
- Si un mode de sortie est actif, il s'affiche à côté : **🏃 sprinter** (mode `/fast`) ou **🤓 concentré** (mode `/verbose`). En mode par défaut, rien n'est affiché.

### 💰 Coût
Le coût cumulé de la session en dollars USD.
- **Vert** : < 1$ — tranquille
- **Jaune** : 1$–5$ — ça commence à chiffrer
- **Rouge** : > 5$ — attention au portefeuille

### 📝 Lignes
Le nombre de lignes ajoutées (+) et supprimées (-) pendant la session.
- Les ajouts sont en **vert**
- Les suppressions sont en **orange**

### ⚡ API
Le ratio entre le temps passé à appeler l'API Claude et le temps total de la session. Indique si tu laisses Claude réfléchir ou si tu enchaînes les prompts.
- 🌿 **< 40%** : rythme posé, tu réfléchis entre les prompts
- ⚡ **40-70%** : bon équilibre
- 🔥 **> 70%** : tu mitrailles les prompts !

Après le séparateur, la **durée totale de la session** est affichée avec une couleur adaptative :
- **Vert** : < 30 min — session fraîche
- **Jaune** : 30 min – 1h — ça commence à durer
- **Orange** : 1h – 2h — session longue
- **Rouge** : > 2h — pense à ouvrir une nouvelle session

Cette ligne n'apparaît que si des appels API ont été effectués.

### ✎ Tokens
Le nombre total de tokens générés par Claude dans la session (en milliers si > 1000).

Cette ligne n'apparaît que si des tokens ont été générés.

### 📡 Statusline
La version actuelle de la statusline installée. Si une mise à jour est disponible, un indicateur vert `⬆ vX.X.X dispo` apparaît à côté.
- C'est bien une mise à jour de **la statusline**, pas du modèle Claude ni du CLI.

### 💬 Conseil
Un message contextuel qui change dynamiquement selon l'état de votre session. Il analyse le coût, la durée, le ratio API, le contexte et les lignes modifiées pour afficher un conseil adapté. Exemples :
- 🚀 **Très productif !** — beaucoup de code modifié pour un coût raisonnable
- ⚠️ **Pensez à démarrer une nouvelle session** — coût élevé ou contexte saturé
- 🛑 **+2h de session** — session trop longue, nouvelle session conseillée
- 😴 **Session calme** — peu d'activité pour le moment
- ✨ **Session efficace et économique** — tout va bien
- 💚 **Session très économique** — coût minimal

### 📊 Contexte
La barre de progression du contexte — combien de la fenêtre de contexte est utilisée.
- **Vert** : < 33% — large
- **Jaune** : 33-60% — normal
- **Orange** : 60-80% — commence à se remplir
- **Rouge** : > 80% — bientôt saturé, pense à démarrer une nouvelle session
- **Fond rouge clignotant** `⚠ >200k` : le contexte a été compressé, la conversation est très longue

## Ton

Clair, pédagogique et concis. Tu expliques comme un guide utilisateur bien fait — pas de jargon inutile, des exemples concrets. Tu peux être sympa mais reste informatif, c'est un guide pas une blague.
