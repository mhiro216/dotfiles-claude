#!/usr/bin/env bash
#
# Claude Code の個人資産(CLAUDE.md / skills / settings / memory / statusline)を
# このリポジトリから ~/.claude へシンボリックリンクで配置する。
#
# 使い方:
#   git clone https://github.com/mhiro216/dotfiles-claude.git
#   cd dotfiles-claude && ./install.sh
#
# 何度実行しても安全(冪等)。既存の実体ファイルは .bak.<日時> に退避してからリンクする。
#
set -euo pipefail

# Windows の Git Bash では MSYS 未設定だと `ln -s` が実体コピーにフォールバックし、
# 同期の狙い(~/.claude 側はリンク)が壊れる。本物のシンボリックリンクを強制する。
# ※ native なリンク作成には Windows の「開発者モード」または管理者権限が必要。
#   非対応環境では link 作成時に明示的に失敗する(nativestrict のため黙ってコピーしない)。
export MSYS=winsymlinks:nativestrict

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$CLAUDE_DIR"

# $src を $dst にシンボリックリンク。既存リンクは張り替え、実体は .bak へ退避。
link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak.$STAMP"
    echo "  退避: $dst -> $dst.bak.$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "  link: $dst -> $src"
}

echo "[1/4] トップレベルファイル"
link "$REPO_DIR/CLAUDE.md"     "$CLAUDE_DIR/CLAUDE.md"
link "$REPO_DIR/statusline.sh" "$CLAUDE_DIR/statusline.sh"
link "$REPO_DIR/settings.json" "$CLAUDE_DIR/settings.json"

echo "[2/4] skills(各スキルを個別にリンク。リポジトリ外のローカルスキルは触らない)"
mkdir -p "$CLAUDE_DIR/skills"
for skill in "$REPO_DIR"/skills/*/; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  link "${skill%/}" "$CLAUDE_DIR/skills/$name"
done

echo "[3/4] memory(プロジェクトフォルダ名はホームパスから動的生成)"
# ~/.claude/projects/<HOMEをスラッシュ→ハイフン>/memory に配置される
PROJ_NAME="$(printf '%s' "$HOME" | sed 's#/#-#g')"
PROJ_DIR="$CLAUDE_DIR/projects/$PROJ_NAME"
mkdir -p "$PROJ_DIR"
link "$REPO_DIR/memory" "$PROJ_DIR/memory"

echo "[4/4] settings.local.json(マシン固有。シンボリックリンクせず、無ければコピーで初期配置)"
if [ -f "$REPO_DIR/settings.local.json" ] && [ ! -e "$CLAUDE_DIR/settings.local.json" ]; then
  cp "$REPO_DIR/settings.local.json" "$CLAUDE_DIR/settings.local.json"
  echo "  seed: $CLAUDE_DIR/settings.local.json(以後はマシンごとに自由編集)"
else
  echo "  skip: 既存の settings.local.json を尊重(または雛形なし)"
fi

cat <<'EOF'

完了。

補足:
- grill-me スキルは ~/.agents/skills/grill-me への別管理リンクのため、本リポジトリの対象外です。
  必要ならサブ機でそちらも別途用意してください。
- 以後は両マシンで `git pull` するだけで CLAUDE.md / skills / memory が同期されます
  (実体はこのリポジトリ1か所。~/.claude 側はリンク)。
EOF
