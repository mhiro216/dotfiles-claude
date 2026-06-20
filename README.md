# dotfiles-claude

Claude Code の個人資産(CLAUDE.md / skills / settings / memory / statusline)を
複数マシン間で同期するための private リポジトリ。

実体はこのリポジトリ1か所に置き、`~/.claude` 配下へはシンボリックリンクで配る。
これにより「片方だけ古い」が起きず、`git pull` だけで同期できる。

## 同期しているもの

| パス | `~/.claude` 上の配置 | 方式 |
|---|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | symlink |
| `statusline.sh` | `~/.claude/statusline.sh` | symlink |
| `settings.json` | `~/.claude/settings.json` | symlink |
| `settings.local.json` | `~/.claude/settings.local.json` | **コピー(マシン固有・初回のみ)** |
| `skills/*` | `~/.claude/skills/*` | スキルごとに symlink |
| `memory/` | `~/.claude/projects/<home>/memory/` | symlink |

`<home>` はホームパスのスラッシュをハイフンに変換した名前(例: `/Users/mhiro` → `-Users-mhiro`)。
`install.sh` が実行マシンのホームパスから自動生成するため、ユーザー名が違っても動く。

## 同期していないもの

履歴・セッション・キャッシュ・トークン類(`history.jsonl`, `sessions/`, `cache/`,
`*-cache.json` など)はマシン固有かつ秘匿のため対象外。`.gitignore` はホワイトリスト
方式(既定で全無視→必要なものだけ許可)で、誤コミットを構造的に防いでいる。

`grill-me` スキルは `~/.agents/skills/grill-me` への別管理リンクのため対象外。

## セットアップ(サブ機)

```bash
git clone https://github.com/mhiro216/dotfiles-claude.git
cd dotfiles-claude
./install.sh
```

`install.sh` は冪等。既存の実体ファイルは `*.bak.<日時>` に退避してからリンクする。

## 日々の運用

- **編集**: `~/.claude/CLAUDE.md` などを普通に編集すれば、実体はこのリポジトリなので
  そのまま差分になる。`git add -p && git commit && git push`。
- **取り込み**: 別マシンで変更したら、各マシンで `git pull`。リンク経由で即反映。
- スキルやメモリを新規追加したら、このリポジトリ側に置いて `./install.sh` を再実行
  すればリンクが張られる。
