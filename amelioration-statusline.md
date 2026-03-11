# Amélioration Statusline — Messages contextuels

## Concept

Remplacer le skill "coach humoristique" (`/session-info`) par des **messages contextuels courts** affichés directement dans la statusline. Le message s'adapte automatiquement en fonction de l'activité de la session (coût, API, durée, lignes, contexte).

Une seule ligne de message, visible en permanence, sans avoir à invoquer un skill.

---

## Données disponibles

| Variable        | Description                        |
|-----------------|------------------------------------|
| `cost_usd`      | Coût total de la session en $      |
| `api_pct`        | Ratio API (temps Claude / total)   |
| `total_sec`      | Durée totale de la session         |
| `lines_added`    | Lignes ajoutées                    |
| `lines_removed`  | Lignes supprimées                  |
| `pct`            | Contexte utilisé (%)               |
| `exceeds_200k`   | Tokens > 200k (compression)        |
| `git_dirty`      | Modifications non commitées        |

---

## Scénarios proposés

### 1. Coût de la session

| Condition           | Message                                                |
|---------------------|--------------------------------------------------------|
| cost < 0.50$        | `💚 Session très économique`                           |
| 0.50$ <= cost < 1$  | `✅ Budget maîtrisé`                                   |
| 1$ <= cost < 3$     | `💰 Session bien chargée`                              |
| 3$ <= cost < 5$     | `⚠️ Pensez à démarrer une nouvelle session bientôt`    |
| cost >= 5$          | `🔴 Session coûteuse — nouvelle session recommandée`   |

### 2. Ratio API (intensité d'utilisation)

| Condition           | Message                                                |
|---------------------|--------------------------------------------------------|
| api_pct <= 30%      | `🌿 Utilisation tranquille`                            |
| 30% < api_pct <= 50%| `⚡ Rythme soutenu`                                    |
| 50% < api_pct <= 70%| `🔥 Claude est au charbon`                             |
| api_pct > 70%       | `🚨 Usage très intensif — laissez Claude respirer`     |

### 3. Durée de session

| Condition              | Message                                             |
|------------------------|-----------------------------------------------------|
| durée < 10 min         | `🟢 Session fraîche`                                |
| 10 min <= durée < 30m  | `👍 Bon rythme de travail`                          |
| 30 min <= durée < 1h   | `☕ Pensez à faire une pause`                       |
| 1h <= durée < 2h       | `⏰ Session longue — pause recommandée`             |
| durée >= 2h            | `🛑 +2h de session — nouvelle session conseillée`   |

### 4. Contexte (fenêtre de tokens)

| Condition           | Message                                                |
|---------------------|--------------------------------------------------------|
| pct <= 40%          | `📦 Contexte large, tout va bien`                      |
| 40% < pct <= 65%    | `📊 Contexte en cours de remplissage`                  |
| 65% < pct <= 80%    | `⚠️ Contexte chargé — concluez bientôt`               |
| pct > 80%           | `🔴 Contexte critique — nouvelle session recommandée`  |
| exceeds_200k        | `💥 Compression active — qualité dégradée`             |

---

## Scénarios combinés (prioritaires)

L'idée est de combiner les facteurs pour générer un message **plus pertinent** qu'un seul indicateur.

### Session efficace (priorité basse — message positif)
- **Conditions** : cost < 1$ ET api_pct <= 40% ET durée < 15 min
- **Message** : `✨ Session efficace et économique`

### Session tranquille (peu d'activité)
- **Conditions** : durée > 10 min ET cost < 0.50$ ET api_pct < 20% ET lines_added < 20
- **Message** : `😴 Session calme — peu d'activité pour le moment`

### Session productive
- **Conditions** : lines_added > 100 ET cost < 2$
- **Message** : `🚀 Très productif ! Bon ratio coût/code`

### Session en surchauffe
- **Conditions** : cost > 3$ ET api_pct > 60%
- **Message** : `🔥 Session intensive — pensez à une nouvelle session`

### Contexte en danger
- **Conditions** : pct > 75% ET cost > 2$
- **Message** : `⛔ Contexte saturé + coût élevé — nouvelle session fortement conseillée`

### Marathon sans commit
- **Conditions** : durée > 30 min ET git_dirty == true ET lines_added > 50
- **Message** : `💾 Beaucoup de modifs non commitées — pensez à sauvegarder`

### Session longue mais légère
- **Conditions** : durée > 30 min ET cost < 0.50$ ET api_pct < 20%
- **Message** : `🐢 Session longue mais peu active — tout va bien`

---

## Priorité d'affichage

Si plusieurs conditions sont remplies, quelle règle afficher ? Proposition d'ordre de priorité (du plus urgent au moins urgent) :

1. **Contexte critique** (pct > 80% ou exceeds_200k)
2. **Session en surchauffe** (coût + API élevés)
3. **Marathon sans commit** (git dirty + temps + lignes)
4. **Coût élevé seul** (cost >= 3$)
5. **Durée longue seule** (>= 1h)
6. **Scénarios combinés positifs** (efficace, productif)
7. **Scénarios par défaut** (indicateur simple le plus pertinent)

---

## Questions ouvertes

- [ ] Faut-il afficher le message sur une ligne séparée ou intégré dans la statusline existante ?
- [ ] Faut-il un emoji ou garder un style sobre ?
- [ ] Limiter à un seul message ou empiler 2 messages max ?
- [ ] Ajouter un seuil "lignes supprimées" ? (ex: > 100 lignes supprimées = "gros refactoring en cours")
- [ ] Faut-il un message par défaut quand tout est normal, ou ne rien afficher ?
