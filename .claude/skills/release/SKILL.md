---
name: release
description: "Checklist complète avant publication : bump de version, changelog, documentation, tests de syntaxe, commit et tag. À utiliser quand l'utilisateur prépare une nouvelle version ou demande une release."
---

# Checklist de release

Tu dois vérifier et préparer une release de la statusline. Passe en revue **chaque point** ci-dessous et agis si nécessaire. Ne push rien sans confirmation explicite de l'utilisateur.

## 1. Version

- [ ] `STATUSLINE_VERSION` dans `statusline-command.sh` est à jour avec le nouveau numéro de version
- [ ] Le numéro suit le semver `MAJOR.MINOR.PATCH` selon la règle suivante :
  - **PATCH** (+0.0.1) : correctif, bugfix, typo, ajustement mineur sans changement fonctionnel
  - **MINOR** (+0.1.0) : nouvelle fonctionnalité, amélioration, ajout d'un skill — rétrocompatible
  - **MAJOR** (+1.0.0) : breaking change, refonte majeure, changement incompatible avec les versions précédentes

## 2. Changelog

- [ ] `CHANGELOG.md` contient une entrée pour la nouvelle version
- [ ] L'entrée décrit toutes les modifications depuis la dernière version
- [ ] Les entrées sont claires et en français

## 3. Documentation

- [ ] `README.md` reflète les nouvelles fonctionnalités
- [ ] Les nouvelles commandes/skills sont documentées
- [ ] Les captures d'écran sont à jour (signaler si une nouvelle capture serait pertinente)

## 4. Scripts

- [ ] `install.sh` installe tous les nouveaux fichiers (skills, scripts)
- [ ] `update.sh` télécharge tous les nouveaux fichiers
- [ ] Les URLs dans les scripts pointent vers les bons chemins
- [ ] Les scripts sont exécutables (`chmod +x`)

## 5. Skills

- [ ] Tous les skills dans `skills/` sont cohérents avec le code
- [ ] Les nouveaux skills sont référencés dans `install.sh` et `update.sh`

## 6. Tests rapides

- [ ] Lancer `bash statusline-command.sh < /tmp/claude-statusline-input.json` pour vérifier que le script ne crash pas
- [ ] Vérifier la syntaxe bash : `bash -n statusline-command.sh && echo "OK"`
- [ ] Vérifier la syntaxe de l'installeur : `bash -n install.sh && echo "OK"`
- [ ] Vérifier la syntaxe du script de mise à jour : `bash -n update.sh && echo "OK"`

## 7. Git

- [ ] Tous les fichiers modifiés sont commités
- [ ] Le message de commit est descriptif
- [ ] Créer le tag de version : `git tag vX.Y.Z`
- [ ] Push avec les tags : `git push origin main --tags`

## Résumé

À la fin, affiche un récapitulatif :
- Version : X.Y.Z
- Fichiers modifiés
- Tag à créer
- Commande de push finale

Attends la confirmation de l'utilisateur avant de push et taguer.
