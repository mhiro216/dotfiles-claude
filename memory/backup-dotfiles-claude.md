---
name: backup-dotfiles-claude
description: 「メモリ/設定をバックアップして」と言われたら ~/dotfiles-claude を main へ直 push する
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1649548a-02b8-40ea-8cd2-22ca1f8aa672
---

ユーザーが「メモリをバックアップして」「設定を保存して」等(言い回しは曖昧でも趣旨が同じなら)と言ったら、`~/dotfiles-claude/backup.sh` を実行して main へ直接 push する。

**Why:** dotfiles-claude は完全な個人用リポジトリ。CLAUDE.md / skills / settings / memory / statusline の実体はこのリポジトリ1か所にあり、`~/.claude` 側は symlink。メモリは Claude が随時更新するため、明示指示でバックアップ(=push)したい。

**How to apply:**
- 実行は `cd ~/dotfiles-claude && ./backup.sh`(差分が無ければ何もしない冪等スクリプト。内部で pull --rebase → add -A → commit → push origin main)。
- **PRは作らない。main へ直 push。**
- push が先行で弾かれたら、勝手に force せず、まず fetch して `origin/main` の差分を確認(ユーザーがGitHub側で編集していることがある)→ rebase で取り込んでから push。
- `.gitignore` はホワイトリスト方式(`*` 無視→必要分だけ `!` 許可)。新規ファイルを追加したら許可行の追加を忘れない。
- コミット時の identity は設定済み mhiro216 を尊重([[git-commit-identity]])。
