#!/usr/bin/env bash
# Claude Code statusLine — custom theme v2

STATUSLINE_VERSION="1.4.1"

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
C_DEL="\033[1;38;5;196m"   # bright neon red
C_VER="\033[38;5;245m"     # gray
C_OUTPUT="\033[1;38;5;117m" # bold sky blue
C_UPDATE="\033[1;38;5;82m" # bright green for update notice
SEP="\033[38;5;99m │ ${R}"

# -- Update check (cache 1h, async) --
UPDATE_CACHE="$HOME/.claude/.statusline-latest-version"
UPDATE_TTL=3600  # 1 heure en secondes
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

  # Si le cache a expiré, relancer un check en arrière-plan
  if [ "$age" -ge "$UPDATE_TTL" ]; then
    _check_update_remote &
    disown 2>/dev/null
  fi
else
  # Pas de cache : premier lancement, check en arrière-plan
  cached_version=""
  _check_update_remote &
  disown 2>/dev/null
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
fi

if [ -n "$git_branch" ]; then
  path_part=$(printf "${C_PATH}%s${R} ${C_GIT} %s${R}" "$dir" "$git_branch")
else
  path_part=$(printf "${C_PATH} %s${R}" "$dir")
fi

# -- Model --
model_part=$(printf "${C_MODEL}🤖 %s${R}" "$model")

# -- Version (dim) + update indicator --
ver_part=$(printf "${C_VER}v%s${R}" "$version")
if [ -n "$update_part" ]; then
  ver_part+=$(printf " %b" "$update_part")
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
  api_part=$(printf "${C_API}%s%s%%${R}" "$api_icon" "$api_pct")
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

# -- Assemble (3 lines) --
# Line 1: Path | Model v.X
line1="$path_part"
line1+=$(printf "%b" "$SEP")
line1+="$model_part "
line1+="$ver_part"

# Line 2: $cost | +N -N | ⚡API% | ✎ output | context bar
line2="$cost_part"
line2+=$(printf "%b" "$SEP")
line2+="$lines_part"

if [ -n "$api_part" ]; then
  line2+=$(printf "%b" "$SEP")
  line2+="$api_part"
fi

if [ -n "$output_part" ]; then
  line2+=$(printf "%b" "$SEP")
  line2+="$output_part"
fi

line2+=$(printf "%b" "$SEP")
line2+="$ctx_part"
line2+="$warn"

printf "%b\n" "$line1"
printf "%b" "$line2"
