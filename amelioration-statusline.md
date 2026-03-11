# Améliorations Statusline — Audit global

## Priorité haute

### 1. ✅ Gestion d'erreur après le parsing jq
- **Fichier** : `statusline-command.sh` (lignes 23-36)
- **Problème** : si le JSON reçu est malformé, `eval` échoue silencieusement et toutes les variables (`model`, `cwd`, `cost_usd`...) restent vides. Le script continue et produit un affichage cassé.
- **Solution** : ajouter une validation après l'`eval` pour vérifier que les variables critiques sont définies, avec un fallback vers un affichage minimal (ex: "Statusline : données indisponibles").

### 2. ✅ Fichier temporaire non nettoyé et trop permissif
- **Fichier** : `statusline-command.sh` (ligne 21)
- **Problème** : `/tmp/claude-statusline-input.json` est écrit à chaque rendu, jamais supprimé, et lisible par tous les utilisateurs du système (potentiel leak de chemins de travail).
- **Solution** : déplacer vers `~/.claude/.statusline-debug.json` avec permissions `600`, ou ajouter un `trap` de nettoyage en sortie de script.

### 3. ✅ Confirmation de désinstallation fragile
- **Fichier** : `uninstall.sh` (ligne 71)
- **Problème** : `read -r confirm < /dev/tty 2>/dev/null || read -r confirm` — si `/dev/tty` est absent (environnement automatisé, pipe), le fallback sur stdin pourrait lire une entrée non voulue et déclencher la suppression.
- **Solution** : n'accepter que `/dev/tty`, et quitter avec un message d'erreur si indisponible. Ajouter un timeout au `read`.

### 4. ✅ Validation de version absente
- **Fichiers** : `statusline-command.sh` (lignes 87-96), `update.sh` (lignes 32, 67)
- **Problème** : la comparaison de versions ne vérifie jamais que la chaîne extraite est du semver valide. Un format inattendu (ex: `"2.0"`, `"beta"`, chaîne vide) casserait la comparaison arithmétique silencieusement.
- **Solution** : valider le format avec un test regex `^[0-9]+\.[0-9]+\.[0-9]+$` avant la comparaison.

---

## Priorité moyenne

### 5. ✅ Documentation pas à jour avec la v2.0.0
- **Fichiers** : `skills/statusline-help/SKILL.md`, `README.md`
- **Problème** : le skill `/statusline-help` ne mentionne pas la nouvelle ligne `💬 Conseil` (messages contextuels). Le README ne documente pas cette fonctionnalité non plus. Les exemples de version dans le help montrent encore `v1.7.0`.
- **Solution** : ajouter une section sur les messages contextuels dans le help et le README, mettre à jour les exemples.

### 6. ✅ Performances : 14+ appels awk par rendu
- **Fichier** : `statusline-command.sh`
- **Problème** : chaque comparaison numérique (coût, API, durée) lance un sous-processus awk. Sur un rendu fréquent, ça représente 14+ forks par affichage.
- **Solution** : utiliser l'arithmétique bash native quand possible (multiplier par 100 pour éviter les décimaux), ou regrouper les comparaisons dans un seul appel awk qui retourne tous les flags d'un coup.

### 7. ✅ Patterns curl dupliqués dans l'installateur
- **Fichier** : `install.sh`
- **Problème** : 7 blocs quasi identiques de `curl -fsSL ... -o ...` avec `mkdir -p` + message de succès/échec. Code répétitif et difficile à maintenir.
- **Solution** : extraire dans une fonction `_download_file "$url" "$dest" "$label"` réutilisable.

### 8. ✅ Mise à jour partielle sans rollback
- **Fichier** : `update.sh`
- **Problème** : si 3 fichiers sur 6 échouent au téléchargement, les fichiers déjà mis à jour restent en place. Le système est dans un état incohérent (mix de versions).
- **Solution** : télécharger tous les fichiers dans un dossier temporaire, puis tout déplacer d'un coup si tout a réussi. En cas d'échec, ne rien modifier.

---

## Priorité basse

### 9. ✅ Pas de détection des capacités couleur du terminal
- **Fichier** : `statusline-command.sh`
- **Problème** : les codes ANSI 256 couleurs sont utilisés sans vérifier le support du terminal. Certains terminaux SSH, Windows CMD, ou `TERM=dumb` ne les supportent pas.
- **Solution** : vérifier la variable `NO_COLOR` (convention standard) et `TERM`, avec fallback vers des couleurs ANSI basiques (8 couleurs).

### 10. ✅ Pas de vérification de git avant utilisation
- **Fichier** : `statusline-command.sh` (lignes 104-109)
- **Problème** : les commandes `git -C` sont exécutées sans vérifier que `git` est installé. Sur un système sans git, les erreurs sont supprimées mais le check est inutile.
- **Solution** : ajouter `command -v git &>/dev/null` avant le bloc git.

### 11. ✅ Section troubleshooting manquante dans le README
- **Fichier** : `README.md`
- **Problème** : pas de guide pour les problèmes courants (couleurs absentes, JSON parse error, statusline qui ne s'affiche pas, permissions).
- **Solution** : ajouter une section FAQ/Troubleshooting avec les cas les plus fréquents.

### 12. ✅ Nettoyage du fichier de brainstorming
- **Fichier** : `amelioration-statusline.md` (ce fichier)
- **Problème** : l'ancien contenu (scénarios de messages contextuels) est maintenant implémenté en v2.0.0. Les questions ouvertes sont résolues.
- **Statut** : ✅ Remplacé par cet audit.
