# 📈 Usage Quota (abonnement) — Fonctionnalité non incluse

> Ce document explique pourquoi la fonctionnalité d'affichage des quotas d'abonnement
> (session 5 heures et semaine 7 jours) n'a **pas été incluse** dans la statusline.

## Description de la fonctionnalité proposée

La fonctionnalité proposait d'afficher la consommation de l'abonnement Claude (Pro/Max)
directement dans la statusline, sous la forme de deux indicateurs :

```
📈 Usage 5h   ██░░░░░░ 25%  reset 15 Mar 20h00
📅 Usage 7j   ██░░░░░░ 25%  reset 20 Mar 08h00
```

- **Session 5 heures** : pourcentage d'utilisation + heure de réinitialisation
- **Semaine 7 jours** : pourcentage d'utilisation + heure de réinitialisation
- Barre de progression colorée selon le niveau (vert → jaune → orange → rouge)
- Résultat mis en cache 60 secondes pour limiter les appels

## Implémentation technique proposée

L'implémentation reposait sur :

1. **Récupération du token OAuth** depuis `~/.claude/.credentials.json`
2. **Appel HTTP** vers `GET https://api.anthropic.com/api/oauth/usage`
3. **Headers requis** :
   - `Authorization: Bearer <token_oauth>`
   - `anthropic-beta: oauth-2025-04-20`
   - `User-Agent: claude-code/2.0.32` (usurpation de l'identité de Claude Code)
4. **Cache local** dans `~/.claude/.statusline-usage.json` (TTL 60s)

---

## Raisons du refus

### 1. Endpoint non documenté — API interne

L'endpoint `/api/oauth/usage` **n'apparaît dans aucune documentation officielle** d'Anthropic :

- Absent de la référence API : https://docs.anthropic.com/en/api
- Absent des guides développeur : https://platform.claude.com/docs
- Absent des changelogs et annonces officielles

Cet endpoint a été découvert par **reverse-engineering du trafic réseau** de Claude Code
(interception des requêtes HTTP via des outils comme Proxyman). Il s'agit d'une API interne
utilisée par Claude Code pour son propre fonctionnement, non destinée à un usage tiers.

### 2. Violation des Conditions Générales d'Utilisation

La page officielle [Legal and Compliance](https://code.claude.com/docs/en/legal-and-compliance)
d'Anthropic stipule explicitement :

> *"OAuth authentication (used with Free, Pro, and Max plans) is intended exclusively
> for Claude Code and Claude.ai. Using OAuth tokens obtained through Claude Free, Pro,
> or Max accounts in any other product, tool, or service — including the Agent SDK —
> is not permitted and constitutes a violation of the Consumer Terms of Service."*

L'utilisation du token OAuth dans un script tiers (comme la statusline) constitue
donc une **violation directe** de cette politique.

### 3. Reverse-engineering interdit par les CGU

Les [Consumer Terms of Service](https://www.anthropic.com/legal/consumer-terms) d'Anthropic
interdisent :

> *"To decompile, reverse engineer, disassemble, or otherwise reduce our Services
> to human-readable form, except when these restrictions are prohibited by applicable law."*

La découverte de cet endpoint par interception du trafic réseau de Claude Code relève
du reverse-engineering et contrevient à cette clause.

### 4. Accès automatisé non autorisé

Les CGU interdisent également :

> *"Except when you are accessing our Services via an Anthropic API Key or where we
> otherwise explicitly permit it, to access the Services through automated or non-human
> means, whether through a bot, script, or otherwise."*

Un script bash appelant l'API avec un token OAuth (et non une clé API officielle)
tombe directement sous cette interdiction.

### 5. Précédent d'application — Blocage de janvier 2026

En **janvier 2026**, Anthropic a déployé un blocage côté serveur empêchant tous les
outils tiers d'utiliser des tokens OAuth d'abonnement. Cette mesure a impacté de
nombreux projets :

- **OpenCode**, **OpenClaw** et d'autres outils ont été cassés du jour au lendemain
- Anthropic a envoyé des **demandes juridiques** à certains projets (notamment OpenCode)
  pour retirer le support des tokens OAuth Claude
- Un employé d'Anthropic (Thariq Shihipar) a confirmé que la voie supportée pour les
  outils tiers est l'API avec clé API, pas les tokens OAuth d'abonnement

Sources :
- https://awesomeagents.ai/news/claude-code-oauth-policy-third-party-crackdown/
- https://daveswift.com/claude-oauth-update/
- https://www.theregister.com/2026/02/20/anthropic_clarifies_ban_third_party_claude_access/

### 6. Throttling actif observé

En mars 2026, de nombreux outils communautaires utilisant cet endpoint signalent des
erreurs 429 (rate limit) persistantes, suggérant qu'Anthropic limite intentionnellement
les appels tiers à cet endpoint :

- GitHub Issue [#30930](https://github.com/anthropics/claude-code/issues/30930)
- GitHub Issue [#31021](https://github.com/anthropics/claude-code/issues/31021)

### 7. Header beta non documenté

Le header `anthropic-beta: oauth-2025-04-20` est un flag interne de Claude Code :

- **Non documenté** dans la référence des beta headers : https://docs.anthropic.com/en/api/beta-headers
- **Rejeté** par les backends Vertex AI et Bedrock avec l'erreur :
  `"Unexpected value(s) 'oauth-2025-04-20'"`
- **Ajouté automatiquement** par Claude Code >= 2.0.65 pour ses propres besoins

Voir : GitHub Issue [#13770](https://github.com/anthropics/claude-code/issues/13770)

### 8. Usurpation du User-Agent

L'implémentation proposée utilisait le header `User-Agent: claude-code/2.0.32`,
se faisant passer pour une version spécifique de Claude Code. Bien que nos tests
aient montré que ce header n'est pas nécessaire (l'API répond sans), son inclusion
constitue une usurpation d'identité du client officiel.

---

## Problèmes techniques additionnels identifiés

En plus des problèmes légaux, l'implémentation comportait des faiblesses techniques :

| Problème | Détail |
|---|---|
| Stockage des credentials | Le code cherchait le token dans `~/.claude/.credentials.json`, mais sur macOS les credentials sont stockées dans le Keychain — le script ne fonctionnait donc pas sur macOS |
| Permissions du cache | Le fichier cache `~/.claude/.statusline-usage.json` était créé en 644 (lisible par tous) au lieu de 600 |
| Appel synchrone bloquant | `curl --max-time 5` pouvait ajouter jusqu'à 5 secondes de latence au rafraîchissement de la statusline |
| Version figée | Le User-Agent hardcodé `claude-code/2.0.32` ne correspondait à aucune version réelle de l'installation |

---

## Alternatives légitimes

### Disponible maintenant

- **Commande `/status`** dans Claude Code : affiche la capacité restante directement
  dans le terminal
- **Headers de rate-limit** renvoyés dans chaque réponse API (pour les utilisateurs
  avec clé API) :
  - `anthropic-ratelimit-requests-remaining`
  - `anthropic-ratelimit-input-tokens-remaining`
  - `anthropic-ratelimit-output-tokens-remaining`

### Demandé à Anthropic (feature request)

La communauté a demandé qu'Anthropic expose les données de quota directement dans
le JSON fourni au statusLine, ce qui serait la solution propre et autorisée :

- GitHub Issue [#27915](https://github.com/anthropics/claude-code/issues/27915) —
  22 upvotes, 13+ issues dupliquées
- GitHub Issue [#13585](https://github.com/anthropics/claude-code/issues/13585) —
  demande originale

**Si Anthropic ajoute ces données au JSON statusLine, la fonctionnalité pourra
être réimplémentée sans aucun appel réseau externe ni violation des CGU.**

### Pour les organisations (Team/Enterprise)

L'Admin API officielle permet de consulter les rapports d'usage :
- `GET /v1/organizations/usage_report/claude_code` (nécessite une clé admin `sk-ant-admin-`)

---

## Conclusion

Cette fonctionnalité est une bonne idée sur le fond — connaître sa consommation
d'abonnement est utile. Mais la méthode d'implémentation (appel à une API interne
non documentée avec un token OAuth détourné) est contraire aux conditions d'utilisation
d'Anthropic et expose les utilisateurs à un risque juridique.

Pour consulter sa consommation d'abonnement, il suffit de taper la commande `/usage`
directement dans le CLI Claude Code. Cette commande affiche les informations de quota
(session 5 heures, semaine 7 jours) de manière native, instantanée et 100% conforme
aux conditions d'utilisation — sans aucun risque de ban.
