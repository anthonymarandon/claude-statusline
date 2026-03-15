# ⚡ API — Configurations

> Cette ligne n'apparaît que si `duration_ms > 0` ET `api_duration_ms > 0`.

## Variantes du ratio API

### ≤ 40% — Session économe

```
⚡ API         🌿12%  │  ⏱ 5m30s
               ╰────╯
               vert + icône 🌿
```

### 40% – 70% — Échange actif

```
⚡ API         ⚡55%  │  ⏱ 18m42s
               ╰───╯
               jaune + icône ⚡
```

### > 70% — Claude travaille en continu

```
⚡ API         🔥82%  │  ⏱ 45m10s
               ╰────╯
               orange + icône 🔥
```

## Variantes de la durée de session

### < 30 min — Vert

```
⚡ API         🌿28%  │  ⏱ 2m57s          vert
⚡ API         ⚡55%  │  ⏱ 22m10s         vert
```

### 30 min – 1h — Jaune

```
⚡ API         🌿35%  │  ⏱ 35m12s         jaune
⚡ API         ⚡60%  │  ⏱ 55m00s         jaune
```

### 1h – 2h — Orange

```
⚡ API         ⚡48%  │  ⏱ 1h23m          orange
⚡ API         🔥75%  │  ⏱ 1h58m          orange
```

### > 2h — Rouge

```
⚡ API         ⚡48%  │  ⏱ 2h30m          rouge
⚡ API         🔥85%  │  ⏱ 3h15m          rouge
```

## Combinaisons typiques

```
⚡ API         🌿28%  │  ⏱ 2m57s       ratio vert,  durée vert     (début de session)
⚡ API         ⚡55%  │  ⏱ 35m12s      ratio jaune, durée jaune    (session active)
⚡ API         🔥82%  │  ⏱ 1h45m       ratio orange, durée orange  (session intensive)
⚡ API         ⚡48%  │  ⏱ 2h30m       ratio jaune, durée rouge    (marathon modéré)
```

## Format de la durée

| Durée | Format | Exemple |
|---|---|---|
| < 60s | `Xs` | `45s` |
| 1 min – 1h | `XmYYs` | `2m57s` |
| ≥ 1h | `XhYYm` | `1h23m` |

## Couleurs

### Ratio API

| Seuil | Icône | Code ANSI | Couleur |
|---|---|---|---|
| ≤ 40% | 🌿 | `\033[38;5;78m` | Vert |
| 40–70% | ⚡ | `\033[38;5;220m` | Jaune |
| > 70% | 🔥 | `\033[38;5;208m` | Orange |

### Durée de session

| Seuil | Code ANSI | Couleur |
|---|---|---|
| < 30 min | `\033[38;5;78m` | Vert |
| 30 min – 1h | `\033[1;38;5;220m` | Jaune bold |
| 1h – 2h | `\033[1;38;5;208m` | Orange bold |
| > 2h | `\033[1;38;5;196m` | Rouge bold |

### Séparateur

Le `│` utilise `\033[38;5;99m` (violet).

## Variables source

| Variable | Champ JSON |
|---|---|
| `api_duration_ms` | `cost.total_api_duration_ms` |
| `duration_ms` | `cost.total_duration_ms` |
