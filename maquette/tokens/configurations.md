# ✎ Tokens — Configurations

> Cette ligne n'apparaît que si `total_output > 0`.

## Variantes

### Tokens < 1000 (nombre brut)

```
✎ Tokens      ✎ 56           bleu ciel
✎ Tokens      ✎ 312          bleu ciel
✎ Tokens      ✎ 999          bleu ciel
```

### Tokens ≥ 1000 (abrégé en k)

```
✎ Tokens      ✎ 1.0k         bleu ciel
✎ Tokens      ✎ 2.1k         bleu ciel
✎ Tokens      ✎ 15.3k        bleu ciel
✎ Tokens      ✎ 128.5k       bleu ciel
```

### Pas de tokens (début de session)

```
(ligne masquée)
```

## Format

| Valeur | Calcul | Résultat |
|---|---|---|
| 56 | `< 1000` → brut | `✎ 56` |
| 2100 | `2100 / 1000` = `2`, `(2100 % 1000) / 100` = `1` | `✎ 2.1k` |
| 15300 | `15300 / 1000` = `15`, `(15300 % 1000) / 100` = `3` | `✎ 15.3k` |

## Couleurs

| Élément | Code ANSI (256) | Code ANSI (8) | Couleur |
|---|---|---|---|
| Valeur tokens | `\033[1;38;5;117m` | `\033[1;36m` | Bleu ciel bold / Cyan bold |

## Variables source

| Variable | Champ JSON |
|---|---|
| `total_output` | `context_window.total_output_tokens` |
