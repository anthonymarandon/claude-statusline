---
name: statusline-uninstall
description: Désinstalle complètement la statusline Claude Code et supprime tous les fichiers associés
---

# Désinstallation de la statusline

Tu dois désinstaller la statusline en exécutant le script de désinstallation.

## Ce que tu fais

1. Lance la commande suivante :

```bash
bash ~/.claude/uninstall.sh
```

2. Lis la sortie du script et informe l'utilisateur du résultat :
   - Si la désinstallation a réussi : confirme que tout a été nettoyé et rappelle de relancer Claude Code
   - Si une erreur s'est produite : explique le problème et propose une solution
   - Si la statusline n'était pas installée : informe l'utilisateur qu'il n'y a rien à désinstaller

## Ton

Direct et concis. L'utilisateur veut juste que ça se désinstalle proprement.
