---
name: git-commit-identity
description: コミット時は設定済みのgit identityを尊重し、author/committerを-cで上書きしない
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5edb6646-9e84-4a94-a180-c9aa7db15464
---

`git commit` で author/committer を `-c user.name=... -c user.email=...` で上書きしないこと。リポジトリ/グローバルに設定済みの identity をそのまま使う。ユーザーのグローバル設定は `mhiro216 <mhiro216@gmail.com>`。

**Why:** 以前 `-c user.name="mhiro" -c user.email="h1-matsuda@nishika.com"` と勝手に上書きしてコミットし、push実行者(mhiro216)とコミット著者が食い違った。全コミットを書き換えてforce pushする羽目になった。設定は元から正しかったので、上書きしなければ起きなかった。

**How to apply:** コミットは素の `git commit` で行う(Co-Authored-By トレーラーはメッセージ本文に入れるのはOK)。identity を変える必要があると思ったら、勝手に判断せずユーザーに確認する。work用に別identityが要る repo では `git config user.email` がリポジトリ単位で設定されている前提で、その設定を尊重する。
