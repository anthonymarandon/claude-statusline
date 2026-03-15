# 📊 Contexte — Configurations

## Variantes par seuil

### ≤ 33% — Vert

```
📊 Contexte    ░░░░░░░░░░ 0%          vert
📊 Contexte    ██░░░░░░░░ 2%          vert
📊 Contexte    ██░░░░░░░░ 15%         vert
📊 Contexte    ███░░░░░░░ 33%         vert
```

### 34% – 60% — Jaune

```
📊 Contexte    ████░░░░░░ 40%         jaune
📊 Contexte    █████░░░░░ 50%         jaune
📊 Contexte    ██████░░░░ 60%         jaune
```

### 61% – 75% — Orange (mode normal)

```
📊 Contexte    ██████░░░░ 65%         orange
📊 Contexte    ███████░░░ 70%         orange
📊 Contexte    ███████░░░ 75%         orange
```

### > 75% — Alerte (fond rouge, texte blanc)

```
📊 Contexte     ████████░░ 78%         FOND ROUGE + texte blanc
📊 Contexte     ████████░░ 80%         FOND ROUGE + texte blanc
📊 Contexte     █████████░ 90%         FOND ROUGE + texte blanc
```

> À partir de 76%, toute la barre et le pourcentage sont sur fond rouge avec texte blanc bold.

### Alerte > 200k tokens

```
📊 Contexte     █████████░ 92%  ⚠ >200k
                                ╰──────╯
                                fond rouge, texte blanc, CLIGNOTANT
```

> Le warning `⚠ >200k` n'apparaît que si `exceeds_200k_tokens` est `true`.
> Il est clignotant (`\033[5m`).

## Barre de progression

```
filled = pct / 10
empty  = 10 - filled

Exemples :
  2%  → ░░░░░░░░░░   (0 filled, 10 empty)
 15%  → █░░░░░░░░░   (1 filled, 9 empty)
 50%  → █████░░░░░   (5 filled, 5 empty)
 80%  → ████████░░   (8 filled, 2 empty)
100%  → ██████████   (10 filled, 0 empty)
```

## Couleurs

| Élément | Code ANSI | Couleur |
|---|---|---|
| Barre vide `░` | `\033[38;5;240m` | Gris foncé |
| Barre ≤ 33% | `\033[38;5;78m` | Vert |
| Barre 34–60% | `\033[38;5;220m` | Jaune |
| Barre 61–80% | `\033[38;5;208m` | Orange |
| Barre > 80% | `\033[1;31m` | Rouge bold |
| Alerte > 75% | `\033[1;41;97m` | Fond rouge, texte blanc bold |
| Warning > 200k | `\033[1;5;41;97m` | Fond rouge, texte blanc bold, clignotant |

## Variables source

| Variable | Champ JSON |
|---|---|
| `used_pct` | `context_window.used_percentage` |
| `exceeds_200k` | `exceeds_200k_tokens` |
