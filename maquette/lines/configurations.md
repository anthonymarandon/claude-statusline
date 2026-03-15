# 📝 Lignes — Configurations

## Variantes

### Ajouts et suppressions

```
📝 Lignes      +40 -174
               ╰─╯ ╰──╯
               vert orange
```

### Uniquement des ajouts

```
📝 Lignes      +120 -0
               ╰──╯ ╰╯
               vert  orange
```

### Uniquement des suppressions

```
📝 Lignes      +0 -85
               ╰╯ ╰─╯
               vert orange
```

### Aucune modification

```
📝 Lignes      +0 -0
```

### Grosses modifications

```
📝 Lignes      +1523 -892
```

## Couleurs

| Élément | Code ANSI (256) | Code ANSI (8) | Couleur |
|---|---|---|---|
| `+N` ajoutées | `\033[1;38;5;46m` | `\033[1;32m` | Vert néon bold |
| `-N` supprimées | `\033[1;38;5;208m` | `\033[1;33m` | Orange bold |

## Variables source

| Variable | Champ JSON |
|---|---|
| `lines_added` | `cost.total_lines_added` |
| `lines_removed` | `cost.total_lines_removed` |
