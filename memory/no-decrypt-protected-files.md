---
name: no-decrypt-protected-files
description: "When a file is password-protected/encrypted, don't try to decrypt or install cracking tools — ask the user for the content"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1b29dec0-e757-4d67-93dd-b5b1d9e07d67
---

暗号化・パスワード保護されたファイル（例: 暗号化された .xls）に遭遇したとき、復号ツール（msoffcrypto-tool 等）のインストールや解除を勝手に試みないこと。ユーザーが手作業でコピーした内容を提供してくれた事例があり、その方が望ましい。

**Why:** ユーザーは保護されたファイルの解除を自動で行われることを望まず、内容を自分で渡す運用を選んだ。

**How to apply:** ファイルが暗号化されていると分かったら、復号を試みる前に「内容を貼り付けてもらえますか」と確認する。
