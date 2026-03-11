---
name: commit
description: "Workflow de commit en 3 étapes : analyse du diff, rédaction d'un message en français catégorisé par fichier, puis commit local avec push optionnel. À utiliser quand l'utilisateur demande de commiter, sauvegarder ou pousser ses modifications."
---

# Commit

Workflow de commit en 3 étapes. Tout doit être en français.

## Étape 1 : Analyse des modifications

- Lancer `git status` pour voir les fichiers modifiés et non suivis
- Lancer `git diff` (staged + unstaged) pour comprendre le contenu des changements
- Lancer `git log --oneline -5` pour voir le style des derniers commits
- Résumer à l'utilisateur ce qui a changé, fichier par fichier

## Étape 2 : Rédaction du message de commit

Le message de commit doit respecter ce format :

```
<type>(<portée>): <description courte>

<détail des modifications par fichier si pertinent>
```

### Types autorisés :
- `feat` : nouvelle fonctionnalité
- `fix` : correction de bug
- `refactor` : refactoring sans changement fonctionnel
- `style` : formatage, cosmétique, pas de changement de logique
- `docs` : documentation uniquement
- `chore` : maintenance, config, dépendances
- `test` : ajout ou modification de tests

### Règles :
- Le message est **toujours en français**
- La portée correspond au fichier ou module principal modifié (ex: `statusline`, `install`, `readme`)
- Si plusieurs fichiers sont modifiés, utiliser la portée la plus représentative ou les lister dans le corps du commit
- La description est concise (max ~70 caractères sur la première ligne)
- Le corps détaille les changements significatifs si nécessaire
- Terminer par : `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

### Exemple :

```
feat(statusline): ajout du layout responsive

- statusline-command.sh : reflow dynamique selon la largeur du terminal
- README.md : documentation de la fonctionnalité responsive
- CHANGELOG.md : entrée pour la version 1.5.0

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

## Étape 3 : Commit, tag et push

- Ajouter les fichiers modifiés au staging (`git add` par fichier, jamais `git add .` ou `-A`)
- Créer le commit
- **Créer un tag annoté** sur le commit avec la version correspondante (ex: `git tag -a v2.0.0 -m "v2.0.0 — description courte"`)
  - Le numéro de version doit correspondre à `STATUSLINE_VERSION` dans `statusline-command.sh`
  - Si la version n'a pas changé, incrémenter le patch (ex: `v2.0.0` → `v2.0.1`)
- Afficher le résultat du commit et du tag
- Demander à l'utilisateur : **"Tu veux que je push sur le remote ?"**
- Ne push que si l'utilisateur confirme explicitement (penser à `git push --tags`)
