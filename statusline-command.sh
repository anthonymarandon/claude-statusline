#!/usr/bin/env bash
# Claude Code statusLine — custom theme v2

STATUSLINE_VERSION="2.0.0"

# Vérifier que jq est disponible
if ! command -v jq &>/dev/null; then
  case "$(uname -s)" in
    Darwin) install_cmd="brew install jq" ;;
    Linux)  install_cmd="sudo apt install jq" ;;
    MINGW*|MSYS*|CYGWIN*) install_cmd="winget install jqlang.jq" ;;
    *)      install_cmd="https://jqlang.github.io/jq/download/" ;;
  esac
  printf "\033[1;33m⚠ jq manquant — %s\033[0m" "$install_cmd"
  exit 0
fi

input=$(cat)

# Debug: sauvegarde le dernier JSON reçu
echo "$input" | jq '.' > /tmp/claude-statusline-input.json 2>/dev/null

eval "$(echo "$input" | jq -r '
  "model=" + (.model.display_name // "" | @sh),
  "cwd=" + (.workspace.current_dir // "" | @sh),
  "cost_usd=" + (.cost.total_cost_usd // 0 | tostring | @sh),
  "duration_ms=" + (.cost.total_duration_ms // 0 | tostring | @sh),
  "api_duration_ms=" + (.cost.total_api_duration_ms // 0 | tostring | @sh),
  "lines_added=" + (.cost.total_lines_added // 0 | tostring | @sh),
  "lines_removed=" + (.cost.total_lines_removed // 0 | tostring | @sh),
  "used_pct=" + (.context_window.used_percentage // 0 | tostring | @sh),
  "total_output=" + (.context_window.total_output_tokens // 0 | tostring | @sh),
  "exceeds_200k=" + (.exceeds_200k_tokens // false | tostring | @sh),
  "version=" + (.version // "" | @sh),
  "output_style=" + (.output_style.name // "" | @sh)
' 2>/dev/null)"

# -- Colors --
R="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
C_PATH="\033[1;36m"        # bold cyan
C_GIT="\033[1;35m"         # bold magenta
C_MODEL="\033[1;38;5;213m" # bold hot pink
C_ADD="\033[1;38;5;46m"    # bright neon green
C_DEL="\033[1;38;5;208m"   # orange
C_VER="\033[38;5;245m"     # gray
C_OUTPUT="\033[1;38;5;117m" # bold sky blue
C_UPDATE="\033[1;38;5;82m" # bright green for update notice
SEP="\033[38;5;99m │ ${R}"

# -- Update check (cache 2min, sync on stale/missing) --
UPDATE_CACHE="$HOME/.claude/.statusline-latest-version"
UPDATE_TTL=120  # 2 minutes en secondes (max ~30 req/h, GitHub autorise 60/h)
update_part=""

_check_update_remote() {
  local latest
  latest=$(curl -sf --max-time 5 "https://api.github.com/repos/anthonymarandon/claude-statusline/tags?per_page=1" \
    | jq -r '.[0].name // empty' 2>/dev/null)
  if [ -n "$latest" ]; then
    # Stocker version + timestamp
    echo "${latest#v}|$(date +%s)" > "$UPDATE_CACHE" 2>/dev/null
  fi
}

# Lire le cache s'il existe
if [ -f "$UPDATE_CACHE" ]; then
  IFS='|' read -r cached_version cached_ts < "$UPDATE_CACHE"
  now=$(date +%s)
  age=$(( now - ${cached_ts:-0} ))

  # Si le cache a expiré, check synchrone pour afficher dès le premier rendu
  if [ "$age" -ge "$UPDATE_TTL" ]; then
    _check_update_remote
    # Relire le cache mis à jour
    IFS='|' read -r cached_version cached_ts < "$UPDATE_CACHE" 2>/dev/null
  fi
else
  # Pas de cache : premier lancement, check synchrone
  cached_version=""
  _check_update_remote
  IFS='|' read -r cached_version cached_ts < "$UPDATE_CACHE" 2>/dev/null
fi

# Comparer les versions (sémantique simple a.b.c)
_ver_to_num() {
  echo "$1" | awk -F. '{ printf "%d%03d%03d", $1, $2, $3 }'
}

if [ -n "$cached_version" ] && [ -n "$STATUSLINE_VERSION" ]; then
  local_num=$(_ver_to_num "$STATUSLINE_VERSION")
  remote_num=$(_ver_to_num "$cached_version")
  if [ "$remote_num" -gt "$local_num" ] 2>/dev/null; then
    update_part=$(printf "${C_UPDATE}⬆ v%s${R}" "$cached_version")
  fi
fi

# -- Directory --
dir="${cwd/#$HOME/~}"

# -- Git branch --
git_branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null | head -1)" ]; then
    git_dirty=" \033[1;38;5;214m●${R}"
  fi
fi

if [ -n "$git_branch" ]; then
  path_part=$(printf "${C_PATH}%s${R} ${C_GIT} %s${R}%b" "$dir" "$git_branch" "${git_dirty:-}")
else
  path_part=$(printf "${C_PATH} %s${R}" "$dir")
fi

# -- Model + output style --
style_indicator=""
case "$output_style" in
  concise) style_indicator=$(printf " ${DIM}🏃 sprinter${R}") ;;
  verbose) style_indicator=$(printf " ${DIM}🤓 concentré${R}") ;;
esac
model_part=$(printf "${C_MODEL}🤖 %s${R}%s" "$model" "$style_indicator")

# -- Version CLI (dim) --
ver_part=$(printf "${C_VER}v%s${R}" "$version")

# -- Statusline version + update indicator --
statusline_part=$(printf "${C_VER}v%s${R}" "$STATUSLINE_VERSION")
if [ -n "$update_part" ]; then
  statusline_part+=$(printf " %b" "$update_part")
fi

# -- Cost with dynamic color --
cost_fmt=$(echo "$cost_usd" | LANG=C awk '{printf "%.4f", $1}')
cost_val=$(echo "$cost_usd" | LANG=C awk '{print $1+0}')
if [ "$(echo "$cost_val" | LANG=C awk '{print ($1 < 1)}')" = "1" ]; then
  C_COST="\033[1;38;5;46m"   # green < $1
elif [ "$(echo "$cost_val" | LANG=C awk '{print ($1 < 5)}')" = "1" ]; then
  C_COST="\033[1;38;5;226m"  # yellow $1-$5
else
  C_COST="\033[1;38;5;196m"  # red > $5
fi
cost_part=$(printf "${C_COST}\$%s${R}" "$cost_fmt")

# -- Lines --
lines_part=$(printf "${C_ADD}+%s${R} ${C_DEL}-%s${R}" "${lines_added:-0}" "${lines_removed:-0}")

# -- API ratio (temps Claude vs temps total) --
if [ "$duration_ms" -gt 0 ] 2>/dev/null && [ "$api_duration_ms" -gt 0 ] 2>/dev/null; then
  api_pct=$(( api_duration_ms * 100 / duration_ms ))
  if [ "$api_pct" -le 40 ]; then
    C_API="\033[38;5;78m"
    api_icon="🌿"
  elif [ "$api_pct" -le 70 ]; then
    C_API="\033[38;5;220m"
    api_icon="⚡"
  else
    C_API="\033[38;5;208m"
    api_icon="🔥"
  fi
  # Durée de session lisible
  total_sec=$(( duration_ms / 1000 ))
  if [ "$total_sec" -ge 3600 ]; then
    duration_fmt=$(printf "%dh%02dm" $(( total_sec / 3600 )) $(( (total_sec % 3600) / 60 )))
  elif [ "$total_sec" -ge 60 ]; then
    duration_fmt=$(printf "%dm%02ds" $(( total_sec / 60 )) $(( total_sec % 60 )))
  else
    duration_fmt=$(printf "%ds" "$total_sec")
  fi
  # Couleur durée selon le temps écoulé
  if [ "$total_sec" -ge 7200 ]; then
    C_DUR="\033[1;38;5;196m"   # rouge > 2h
  elif [ "$total_sec" -ge 3600 ]; then
    C_DUR="\033[1;38;5;208m"   # orange > 1h
  elif [ "$total_sec" -ge 1800 ]; then
    C_DUR="\033[1;38;5;220m"   # jaune > 30min
  else
    C_DUR="\033[38;5;78m"      # vert < 30min
  fi
  api_part=$(printf "${C_API}%s%s%%${R} ${SEP}${C_DUR}⏱ %s${R}" "$api_icon" "$api_pct" "$duration_fmt")
else
  api_part=""
fi

# -- Tokens output --
if [ "$total_output" -gt 0 ] 2>/dev/null; then
  if [ "$total_output" -ge 1000 ]; then
    out_k=$(echo "$total_output" | LANG=C awk '{printf "%.1f", $1/1000}')
    output_part=$(printf "${C_OUTPUT}✎ %sk${R}" "$out_k")
  else
    output_part=$(printf "${C_OUTPUT}✎ %s${R}" "$total_output")
  fi
else
  output_part=""
fi

# -- Context % --
pct="${used_pct%%.*}"
if [ "$pct" -le 33 ] 2>/dev/null; then
  C_CTX="\033[38;5;78m"
elif [ "$pct" -le 60 ] 2>/dev/null; then
  C_CTX="\033[38;5;220m"
elif [ "$pct" -le 80 ] 2>/dev/null; then
  C_CTX="\033[38;5;208m"
else
  C_CTX="\033[1;31m"
fi

# Progress bar (10 chars)
filled=$(( pct / 10 ))
empty=$(( 10 - filled ))
bar_filled=""
bar_empty=""
for ((i=0; i<filled; i++)); do bar_filled+="█"; done
for ((i=0; i<empty; i++)); do bar_empty+="░"; done

# Alert mode > 75%
if [ "$pct" -gt 75 ] 2>/dev/null; then
  ctx_part=$(printf "\033[1;41;97m %s%s %s%% \033[0m" "$bar_filled" "$bar_empty" "$pct")
else
  ctx_part=$(printf "${BOLD}${C_CTX}%s\033[0m\033[38;5;240m%s\033[0m ${BOLD}${C_CTX}%s%%${R}" "$bar_filled" "$bar_empty" "$pct")
fi

# -- Exceeds 200k --
warn=""
if [ "$exceeds_200k" = "true" ]; then
  warn=$(printf " \033[1;5;41;97m ⚠ >200k \033[0m")
fi

# -- Message contextuel (priorité décroissante) --
ctx_msg=""
C_MSG="\033[38;5;252m"  # light gray for messages

# Valeurs numériques pour les conditions combinées
_cost_val=$(echo "$cost_usd" | LANG=C awk '{print $1+0}')
_api_val=${api_pct:-0}
_dur_val=${total_sec:-0}
_lines_val=${lines_added:-0}
_has_dirty=""
if [ -n "$git_dirty" ]; then _has_dirty="true"; fi

# 1. Contexte critique (priorité max)
if [ "$exceeds_200k" = "true" ]; then
  ctx_msg="💥 Compression active — qualité dégradée"
elif [ "$pct" -gt 80 ] 2>/dev/null; then
  ctx_msg="🔴 Contexte critique — nouvelle session recommandée"
# 2. Session en surchauffe
elif [ "$(echo "$_cost_val $_api_val" | LANG=C awk '{print ($1>3 && $2>60)}')" = "1" ]; then
  ctx_msg="🔥 Session intensive — pensez à une nouvelle session"
# 3. Marathon sans commit
elif [ "$_dur_val" -ge 1800 ] 2>/dev/null && [ "$_has_dirty" = "true" ] && [ "$_lines_val" -gt 50 ] 2>/dev/null; then
  ctx_msg="💾 Beaucoup de modifs non commitées — pensez à sauvegarder"
# 4. Contexte chargé
elif [ "$pct" -gt 65 ] 2>/dev/null; then
  ctx_msg="⚠️  Contexte chargé — concluez bientôt"
# 5. Coût élevé
elif [ "$(echo "$_cost_val" | LANG=C awk '{print ($1>=5)}')" = "1" ]; then
  ctx_msg="🔴 Session coûteuse — nouvelle session recommandée"
elif [ "$(echo "$_cost_val" | LANG=C awk '{print ($1>=3)}')" = "1" ]; then
  ctx_msg="⚠️  Pensez à démarrer une nouvelle session bientôt"
# 6. Durée longue
elif [ "$_dur_val" -ge 7200 ] 2>/dev/null; then
  ctx_msg="🛑 +2h de session — nouvelle session conseillée"
elif [ "$_dur_val" -ge 3600 ] 2>/dev/null; then
  ctx_msg="⏰ Session longue — pause recommandée"
# 7. Session longue mais légère
elif [ "$_dur_val" -ge 1800 ] 2>/dev/null && [ "$(echo "$_cost_val" | LANG=C awk '{print ($1<0.5)}')" = "1" ] && [ "$_api_val" -lt 20 ] 2>/dev/null; then
  ctx_msg="🐢 Session longue mais peu active — tout va bien"
# 8. Session tranquille (peu d'activité)
elif [ "$_dur_val" -ge 600 ] 2>/dev/null && [ "$(echo "$_cost_val" | LANG=C awk '{print ($1<0.5)}')" = "1" ] && [ "$_api_val" -lt 20 ] 2>/dev/null && [ "$_lines_val" -lt 20 ] 2>/dev/null; then
  ctx_msg="😴 Session calme — peu d'activité pour le moment"
# 9. Session productive (positif)
elif [ "$_lines_val" -gt 100 ] 2>/dev/null && [ "$(echo "$_cost_val" | LANG=C awk '{print ($1<2)}')" = "1" ]; then
  ctx_msg="🚀 Très productif ! Bon ratio coût/code"
# 10. Session efficace (positif)
elif [ "$(echo "$_cost_val" | LANG=C awk '{print ($1<1)}')" = "1" ] && [ "$_api_val" -le 40 ] 2>/dev/null && [ "$_dur_val" -lt 900 ] 2>/dev/null; then
  ctx_msg="✨ Session efficace et économique"
# 11. Indicateurs simples par défaut
elif [ "$_dur_val" -ge 1800 ] 2>/dev/null; then
  ctx_msg="☕ Pensez à faire une pause"
elif [ "$(echo "$_cost_val $_api_val" | LANG=C awk '{print ($1>=1 && $2>50)}')" = "1" ]; then
  ctx_msg="💰 Session bien chargée"
elif [ "$_api_val" -gt 70 ] 2>/dev/null; then
  ctx_msg="🚨 Usage très intensif — laissez Claude respirer"
elif [ "$(echo "$_cost_val" | LANG=C awk '{print ($1<0.5)}')" = "1" ]; then
  ctx_msg="💚 Session très économique"
else
  ctx_msg="✅ Budget maîtrisé"
fi

# -- Labels --
C_LABEL="\033[38;5;245m"  # gray for labels

# -- Assemble (one element per line) --
printf "%b\n" "$(printf "${C_LABEL}📂 Dossier    ${R}")$path_part"
printf "%b\n" "$(printf "${C_LABEL}🤖 Modèle     ${R}")${model_part}"
printf "%b\n" "$(printf "${C_LABEL}💰 Coût       ${R}")$cost_part"
printf "%b\n" "$(printf "${C_LABEL}📝 Lignes     ${R}")$lines_part"
if [ -n "$api_part" ]; then
  printf "%b\n" "$(printf "${C_LABEL}⚡ API        ${R}")$api_part"
fi
if [ -n "$output_part" ]; then
  printf "%b\n" "$(printf "${C_LABEL}✎ Tokens     ${R}")$output_part"
fi
printf "%b\n" "$(printf "${C_LABEL}📡 Statusline ${R}")$statusline_part"
printf "%b\n" "$(printf "${C_LABEL}📊 Contexte   ${R}")${ctx_part}${warn}"
printf "%b" "$(printf "${C_LABEL}💬 Conseil    ${R}")${C_MSG}${ctx_msg}${R}"
