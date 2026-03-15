# 🤖 Modèle — Configurations

## Variantes

### Modèle standard (pas de style spécifique)

```
🤖 Modèle      🤖 Opus 4.6 (1M context)
                  ╰── rose bold ──────────╯
```

### Modèle avec style concise (sprinter)

```
🤖 Modèle      🤖 Opus 4.6 (1M context) 🏃 sprinter
                  ╰── rose bold ──────────╯ ╰── dim ──╯
```

### Modèle avec style verbose (concentré)

```
🤖 Modèle      🤖 Opus 4.6 (1M context) 🤓 concentré
                  ╰── rose bold ──────────╯ ╰── dim ───╯
```

### Autres modèles

```
🤖 Modèle      🤖 Sonnet 4.6
🤖 Modèle      🤖 Haiku 4.5
```

## Couleurs

| Élément | Code ANSI (256) | Code ANSI (8) | Couleur |
|---|---|---|---|
| Nom du modèle | `\033[1;38;5;213m` | `\033[1;35m` | Rose (hot pink) / Magenta |
| Style indicator | `\033[2m` | `\033[2m` | Dim (atténué) |

## Variables source

| Variable | Champ JSON |
|---|---|
| `model` | `model.display_name` |
| `output_style` | `output_style.name` |
