# 💬 Conseil — Configurations

> Un seul message affiché par rendu. Le premier match dans l'ordre de priorité l'emporte.

## Tous les messages par priorité

### Priorité 1 — Contexte critique

```
💬 Conseil     💥 Compression active — qualité dégradée
               Condition : exceeds_200k = true

💬 Conseil     🔴 Contexte critique — nouvelle session recommandée
               Condition : contexte > 80%
```

### Priorité 2 — Session en surchauffe

```
💬 Conseil     🔥 Session intensive — pensez à une nouvelle session
               Condition : coût > 3$ ET API > 60%
```

### Priorité 3 — Marathon sans commit

```
💬 Conseil     💾 Beaucoup de modifs non commitées — pensez à sauvegarder
               Condition : durée ≥ 30min ET dirty ET lignes > 50
```

### Priorité 4 — Contexte chargé

```
💬 Conseil     ⚠️  Contexte chargé — concluez bientôt
               Condition : contexte > 65%
```

### Priorité 5 — Coût élevé

```
💬 Conseil     🔴 Session coûteuse — nouvelle session recommandée
               Condition : coût ≥ 5$

💬 Conseil     ⚠️  Pensez à démarrer une nouvelle session bientôt
               Condition : coût ≥ 3$
```

### Priorité 6 — Durée longue

```
💬 Conseil     🛑 +2h de session — nouvelle session conseillée
               Condition : durée ≥ 2h

💬 Conseil     ⏰ Session longue — pause recommandée
               Condition : durée ≥ 1h
```

### Priorité 7 — Session longue mais légère

```
💬 Conseil     🐢 Session longue mais peu active — tout va bien
               Condition : durée ≥ 30min ET coût < 0.50$ ET API < 20%
```

### Priorité 8 — Session calme

```
💬 Conseil     😴 Session calme — peu d'activité pour le moment
               Condition : durée ≥ 10min ET coût < 0.50$ ET API < 20% ET lignes < 20
```

### Priorité 9 — Session productive

```
💬 Conseil     🚀 Très productif ! Bon ratio coût/code
               Condition : lignes > 100 ET coût < 2$
```

### Priorité 10 — Session efficace

```
💬 Conseil     ✨ Session efficace et économique
               Condition : coût < 1$ ET API ≤ 40% ET durée < 15min
```

### Priorité 11 — Indicateurs par défaut

```
💬 Conseil     ☕ Pensez à faire une pause
               Condition : durée ≥ 30min

💬 Conseil     💰 Session bien chargée
               Condition : coût ≥ 1$ ET API > 50%

💬 Conseil     🚨 Usage très intensif — laissez Claude respirer
               Condition : API > 70%

💬 Conseil     💚 Session très économique
               Condition : coût < 0.50$

💬 Conseil     ✅ Budget maîtrisé
               Condition : (aucune autre condition — fallback)
```

## Couleur

Tous les messages sont affichés en **gris clair** (`\033[38;5;252m`).

## Variables utilisées

| Variable | Source |
|---|---|
| `cost_cents` | Calculé depuis `cost.total_cost_usd` |
| `_api_val` | `api_pct` (ratio API) |
| `_dur_val` | `total_sec` (durée en secondes) |
| `_lines_val` | `lines_added` |
| `pct` | `context_window.used_percentage` |
| `exceeds_200k` | `exceeds_200k_tokens` |
| `_has_dirty` | Détecté via `git status` |
