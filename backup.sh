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

git pull -q --rebase origin main || true

if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  echo "変更なし。push不要。"
  exit 0
fi

NOTE="${1:-}"
MSG="backup: $(date '+%Y-%m-%d %H:%M:%S')"
[ -n "$NOTE" ] && MSG="$MSG — $NOTE"

git add -A
git commit -q -m "$MSG"
git push -q origin main
echo "push 完了: $(git rev-parse --short HEAD) ($MSG)"
