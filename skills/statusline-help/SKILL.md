---
name: statusline-help
description: Explique visuellement chaque indicateur de la statusline Claude Code
---

# Guide de la Statusline

Tu dois expliquer à l'utilisateur comment lire sa statusline Claude Code. Reproduis visuellement le layout actuel puis détaille chaque ligne.

## Ce que tu affiches

Commence par afficher un exemple visuel de la statusline telle qu'elle apparaît dans le terminal (utilise un bloc de code avec des valeurs d'exemple réalistes) :

```
📂 Dossier    ~/mon-projet  main
🤖 Modèle     Claude 4.6 Opus v1.26.9
💰 Coût       $1.2450
📝 Lignes     +47 -12
⚡ API        🔥65%
✎ Tokens     8.3k
📊 Contexte   ████░░░░░░ 40%
```

Puis explique chaque ligne :

### 📂 Dossier
Le répertoire de travail actuel + la branche Git si le projet est un dépôt Git.

### 🤖 Modèle
Le modèle Claude utilisé (Opus, Sonnet, Haiku) + la version du CLI Claude Code.
- Si une mise à jour est disponible, un indicateur vert `⬆ vX.X.X` apparaît à côté.

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

Cette ligne n'apparaît que si des appels API ont été effectués.

### ✎ Tokens
Le nombre total de tokens générés par Claude dans la session (en milliers si > 1000).

Cette ligne n'apparaît que si des tokens ont été générés.

### 📊 Contexte
La barre de progression du contexte — combien de la fenêtre de contexte est utilisée.
- **Vert** : < 33% — large
- **Jaune** : 33-60% — normal
- **Orange** : 60-80% — commence à se remplir
- **Rouge** : > 80% — bientôt saturé, pense à démarrer une nouvelle session
- **Fond rouge clignotant** `⚠ >200k` : le contexte a été compressé, la conversation est très longue

## Ton

Clair, pédagogique et concis. Tu expliques comme un guide utilisateur bien fait — pas de jargon inutile, des exemples concrets. Tu peux être sympa mais reste informatif, c'est un guide pas une blague.
