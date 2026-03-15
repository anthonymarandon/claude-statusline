# ✎ Tokens — Configurations

> Cette ligne n'apparaît que si `total_output > 0` OU `total_input > 0`.
> Elle combine sur une même ligne : tokens input, tokens output, et le taux de cache hit si disponible.

## Format général

```
✎ Tokens     ↓<input>  │  ↑<output>  │  💾 <cache%> (<lus>)
```

- `↓` = tokens **entrants** (input, non mis en cache) — violet doux
- `↑` = tokens **sortants** (output générés) — bleu ciel
- `│` = séparateur violet
- `💾 XX%` = taux de cache hit — coloré selon efficacité
- `(YYk lus)` = volume de tokens servis depuis le cache — gris dim

---

## Variantes tokens (input & output)

### Valeurs < 1000 (nombre brut)

```
✎ Tokens     ↓56  │  ↑312
✎ Tokens     ↓0   │  ↑999
```

### Valeurs ≥ 1000 (abrégé en k avec 1 décimale)

```
✎ Tokens     ↓1.2k  │  ↑8.3k
✎ Tokens     ↓108   │  ↑16.9k
✎ Tokens     ↓2.5k  │  ↑128.5k
```

### Format abrégé

| Valeur | Calcul | Résultat |
|---|---|---|
| 56 | `< 1000` → brut | `↓56` |
| 1200 | `1200/1000`=`1`, `(1200%1000)/100`=`2` | `↓1.2k` |
| 16900 | `16900/1000`=`16`, `(16900%1000)/100`=`9` | `↓16.9k` |

---

## Variantes cache hit rate

> Apparaît uniquement si `cache_read + cache_create > 0`.

### ≥ 75% — Cache très efficace

```
✎ Tokens     ↓108  │  ↑16.9k  │  💾 97% (37.7k lus)
                                       ╰──╯
                                       vert
```

### 40% – 75% — Cache modéré

```
✎ Tokens     ↓500  │  ↑8.3k   │  💾 62% (12.1k lus)
                                       ╰──╯
                                       jaune
```

### < 40% — Cache peu utilisé

```
✎ Tokens     ↓2.1k  │  ↑4.5k  │  💾 25% (1.8k lus)
                                       ╰──╯
                                       orange
```

### Sans données de cache

```
✎ Tokens     ↓108  │  ↑16.9k
(partie 💾 masquée)
```

---

## Combinaisons typiques

```
✎ Tokens     ↓56   │  ↑312          début de session, pas de cache encore
✎ Tokens     ↓108  │  ↑16.9k  │  💾 97% (37.7k lus)   session établie, cache très efficace
✎ Tokens     ↓2.1k │  ↑8.3k   │  💾 62% (12.1k lus)   cache modéré
✎ Tokens     ↓500  │  ↑4.5k   │  💾 25% (1.8k lus)    peu de réutilisation du cache
```

---

## Couleurs

| Élément | Code ANSI (256) | Code ANSI (8) | Couleur |
|---|---|---|---|
| Tokens input `↓` | `\033[1;38;5;147m` | `\033[1;34m` | Violet doux bold |
| Tokens output `↑` | `\033[1;38;5;117m` | `\033[1;36m` | Bleu ciel bold |
| Séparateur `│` | `\033[38;5;99m` | `\033[35m` | Violet |
| Cache % ≥ 75% | `\033[1;38;5;46m` | `\033[1;32m` | Vert bright |
| Cache % 40–75% | `\033[1;38;5;220m` | `\033[1;33m` | Jaune |
| Cache % < 40% | `\033[1;38;5;208m` | `\033[1;33m` | Orange |
| Tokens lus `(XXk lus)` | `\033[2m` | `\033[2m` | Dim |

---

## Variables source

| Variable | Champ JSON |
|---|---|
| `total_input` | `context_window.total_input_tokens` |
| `total_output` | `context_window.total_output_tokens` |
| `cache_read` | `context_window.current_usage.cache_read_input_tokens` |
| `cache_create` | `context_window.current_usage.cache_creation_input_tokens` |

### Calcul du taux de cache

```
_cache_total = cache_read + cache_create
cache_pct    = cache_read * 100 / _cache_total
```

> `cache_read` et `cache_create` proviennent de `current_usage` (dernier tour),
> tandis que `total_input` et `total_output` sont cumulatifs sur toute la session.
