#!/usr/bin/env bash
# Claude Code statusline: モデル / ディレクトリ / git / コンテキスト使用率 / プラン使用量(5h・7d)
# サブスク利用のためドル課金額は表示しない。
# プラン使用量(レート上限に対する消費率)は rate_limits フィールドから取得する
#   (Claude.ai Pro/Max のみ、セッション内で最初のAPI応答後に出現。各枠は独立して欠落しうる)。
# コンテキスト使用率は圧縮/上限が近いかの目安。
input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
cur_dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir_name=$(basename "$cur_dir")
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // ""')

# git: ブランチ + dirty状態(±N) + ahead/behind(↑↓)
branch=""
if git -C "$cur_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  b=$(git -C "$cur_dir" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -n "$b" ]; then
    branch=" \033[33m⎇ ${b}\033[0m"

    # dirty: 変更のあるファイル数(staged/unstaged/untracked すべて)
    dirty=$(git -C "$cur_dir" --no-optional-locks status --porcelain 2>/dev/null | grep -c '')
    [ "$dirty" -gt 0 ] 2>/dev/null && branch="${branch} \033[31m±${dirty}\033[0m"

    # ahead/behind: 上流ブランチがある場合のみ
    if upstream=$(git -C "$cur_dir" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null); then
      counts=$(git -C "$cur_dir" rev-list --left-right --count "${upstream}...HEAD" 2>/dev/null)
      behind=$(printf '%s' "$counts" | awk '{print $1}')
      ahead=$(printf '%s' "$counts" | awk '{print $2}')
      [ "${ahead:-0}" -gt 0 ] 2>/dev/null && branch="${branch} \033[32m↑${ahead}\033[0m"
      [ "${behind:-0}" -gt 0 ] 2>/dev/null && branch="${branch} \033[36m↓${behind}\033[0m"
    fi
  fi
fi

# コンテキスト使用率: 直近の usage(input + cache_creation + cache_read)を 200k に対する割合で
ctx=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  tok=$(jq -s 'map(select(.message.usage != null)) | last | .message.usage
        | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0))' \
        "$transcript" 2>/dev/null)
  if [ -n "$tok" ] && [ "$tok" != "null" ] && [ "$tok" -gt 0 ] 2>/dev/null; then
    pct=$(( tok * 100 / 200000 ))
    k=$(( tok / 1000 ))
    # 50%未満=緑, 50-79%=黄, 80%以上=赤
    if (( pct >= 80 )); then col=31; elif (( pct >= 50 )); then col=33; else col=32; fi
    ctx=$(printf "  \033[%sm⛁ %d%% (%dk)\033[0m" "$col" "$pct" "$k")
  fi
fi

# プラン使用量: 5時間枠 / 7日枠 のレート上限消費率 (rate_limits、サブスクのみ)
# 各枠は欠落しうるので "// empty" で安全に取り出す。少数は整数に丸める。
usage=""
now=$(date +%s)
fmt_left() { # $1=resets_at(epoch秒) -> " ⟳NhNm" / " ⟳Nm" (過去/欠落なら空)
  local r=$1 d
  [ -z "$r" ] && return
  d=$(( r - now ))
  (( d <= 0 )) && return
  if (( d >= 3600 )); then printf " ⟳%dh%dm" $(( d / 3600 )) $(( (d % 3600) / 60 ))
  else printf " ⟳%dm" $(( d / 60 )); fi
}
fmt_lim() { # $1=ラベル $2=使用率(%) $3=resets_at -> 色付き " ラベル NN% ⟳残り時間"
  local label=$1 v=$2 reset=$3 p col
  [ -z "$v" ] && return
  p=${v%.*}; [ -z "$p" ] && p=0
  if   (( p >= 90 )); then col=31   # 90%以上=赤
  elif (( p >= 70 )); then col=33   # 70-89%=黄
  else col=32; fi                   # 70%未満=緑
  printf "  \033[%sm%s %d%%%s\033[0m" "$col" "$label" "$p" "$(fmt_left "$reset")"
}
five=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_r=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_r=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
usage="${usage}$(fmt_lim "5h" "$five" "$five_r")"
usage="${usage}$(fmt_lim "7d" "$week" "$week_r")"

printf "\033[36m%s\033[0m \033[34m%s\033[0m%b%b%b" \
  "$model" "$dir_name" "$branch" "$ctx" "$usage"
