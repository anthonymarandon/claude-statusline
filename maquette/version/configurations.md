# 📡 Statusline — Configurations

## Variantes

### Version à jour

```
📡 Statusline  v2.1.0
               ╰────╯
               gris
```

### Mise à jour disponible

```
📡 Statusline  v2.1.0 ⬆ v2.2.0
               ╰────╯ ╰──────╯
               gris   vert vif
```

## Mécanisme de vérification

- Cache local : `~/.claude/.statusline-latest-version`
- TTL : 120 secondes (2 minutes)
- Source : `api.github.com` (tags du repo)
- Comparaison sémantique `a.b.c` → `a*1000000 + b*1000 + c`
- L'indicateur `⬆` n'apparaît que si la version distante est strictement supérieure

## Couleurs

| Élément | Code ANSI | Couleur |
|---|---|---|
| Version actuelle | `\033[38;5;245m` | Gris |
| Indicateur `⬆ vX.Y.Z` | `\033[1;38;5;82m` | Vert vif bold |

## Variables source

| Variable | Source |
|---|---|
| `STATUSLINE_VERSION` | Hardcodée dans le script |
| `cached_version` | Cache GitHub (`~/.claude/.statusline-latest-version`) |
