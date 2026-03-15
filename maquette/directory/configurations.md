# 📂 Dossier — Configurations

## Variantes

### Avec branche git (clean)

```
📂 Dossier     ~/Desktop/claude-statusline   main
               ╰── cyan bold ──────────────╯ ╰─ magenta ─╯
```

### Avec branche git (dirty — modifications non commitées)

```
📂 Dossier     ~/Desktop/claude-statusline   main ●
               ╰── cyan bold ──────────────╯ ╰magenta╯╰orange╯
```

### Sans dépôt git

```
📂 Dossier      ~/Documents/projet
                ╰── cyan bold ────╯
```

### Chemin long

```
📂 Dossier     ~/projets/client/app-mobile/src
               ╰── cyan bold ────────────────╯
```

> `$HOME` est toujours remplacé par `~`

## Couleurs

| Élément | Code ANSI | Couleur |
|---|---|---|
| Chemin | `\033[1;36m` | Cyan bold |
| Branche git | `\033[1;35m` | Magenta bold |
| Dirty indicator `●` | `\033[1;38;5;214m` | Orange bold |

## Variables source

| Variable | Champ JSON |
|---|---|
| `cwd` | `workspace.current_dir` |
| `git_branch` | Détecté via `git symbolic-ref` |
| `git_dirty` | Détecté via `git status --porcelain` |
