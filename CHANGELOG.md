# Changelog

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
