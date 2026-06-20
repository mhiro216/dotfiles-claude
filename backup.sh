#!/usr/bin/env bash
#
# dotfiles-claude(CLAUDE.md / skills / settings / memory / statusline)の現状を
# main へ直接 push する個人用バックアップ。PRは作らない。
#
# 使い方: ./backup.sh ["任意のメモ"]
# 差分が無ければ何もしない(冪等)。
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  echo "ローカル変更なし。リモート取り込みのみ実施。"
  git pull -q --rebase origin main
  echo "最新: $(git rev-parse --short HEAD)"
  exit 0
fi

NOTE="${1:-}"
MSG="backup: $(date '+%Y-%m-%d %H:%M:%S')"
[ -n "$NOTE" ] && MSG="$MSG — $NOTE"

# 先にローカル変更を commit してから rebase で取り込む(unstaged 競合を避ける)
git add -A
git commit -q -m "$MSG"
git pull -q --rebase origin main
git push -q origin main
echo "push 完了: $(git rev-parse --short HEAD) ($MSG)"
