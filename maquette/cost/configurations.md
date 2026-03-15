# 💰 Coût — Configurations

## Variantes par seuil

### < 1$ — Vert (tout va bien)

```
💰 Coût        $0.0000        vert
💰 Coût        $0.0312        vert
💰 Coût        $0.2141        vert
💰 Coût        $0.9999        vert
```

### 1$ – 5$ — Jaune (ça commence à chiffrer)

```
💰 Coût        $1.0000        jaune
💰 Coût        $2.5430        jaune
💰 Coût        $4.9999        jaune
```

### > 5$ — Rouge (session coûteuse)

```
💰 Coût        $5.0001        rouge
💰 Coût        $7.8912        rouge
💰 Coût        $12.3456       rouge
```

## Seuils

| Seuil | Couleur | Code ANSI |
|---|---|---|
| < 1$ | 🟢 Vert | `\033[1;38;5;46m` |
| 1$ – 5$ | 🟡 Jaune | `\033[1;38;5;226m` |
| > 5$ | 🔴 Rouge | `\033[1;38;5;196m` |

## Format

- Toujours 4 décimales (`%.4f`)
- Préfixé par `$`
- `LANG=C awk` force le point comme séparateur décimal

## Variables source

| Variable | Champ JSON |
|---|---|
| `cost_usd` | `cost.total_cost_usd` |
