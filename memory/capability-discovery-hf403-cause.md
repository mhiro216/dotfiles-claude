---
name: capability-discovery-hf403-cause
description: Capability Discovery routineのHF 403=env egress allowlist欠落が真因(token/WAFではない)。2026-06-15解決済み
metadata:
  node_type: memory
  type: project
  originSessionId: 07659e4e-d5b0-4c7c-b954-5d5b9c1d632a
---

Capability Discovery Weekly Digest routine (`trig_01M6er5crjrg35yXtHSrExkZ`, 環境 `env_01JxFiRsUJBEwSVPrFWn7NNE` Default/anthropic_cloud) が毎回 HuggingFace を取得できず「HTTP 403」になっていた真因は、**CCR環境のネットワークegress許可リストに `huggingface.co` が無い**こと。プロキシ層が `Host not in allowlist` で全HFリクエストを弾いていた。token/WAFは無関係(HF_TOKEN 37字注入済みでも `whoami-v2` ごと403。ローカル住宅IPからは未認証でもHF API 200)。

**2026-06-15 解決済み:**
1. 環境設定 (claude.ai Code → カスタマイズ → クラウド環境「Default」) の **ネットワークアクセス** を `Trusted`→**`カスタム`** に変更し、許可ドメインに `huggingface.co` `api.github.com` `github.com` `raw.githubusercontent.com` を追加。`Trusted`はGitHub等の固定allowlistのみでHFは含まれない。`カスタム`はリストしたドメインだけ許可なので**GitHubも明示で足す必要**あり(共用環境=他routineのcurl保護)。`Full`でも可だが最小権限でカスタム採用。診断で `hf_model_api=200 / github_api=200` 確認済み。
2. routineプロンプト修正: HFセクションを「token任意・匿名200で動く・健全性チェックは公開エンドポイント `api/models?limit=1`・list APIが返す正確id厳守(slug推測禁止)」に変更し誤診断記述(WAF/token必須)を削除。さらにStep2に**ライセンスゲート**追加(商用可を実確認した候補のみ🔴、未確認は⚠️止まり、非商用は🟢除外)。Sortformerの🔴誤起票がこのガード新設の契機。

**注意点:** ネットワーク設定はドメイン単位の追加欄ではなく `なし/Trusted/Full/カスタム` のレベル選択。HF_TOKENは環境変数欄に入れれば使えるが必須ではない(runにより0/37字と不安定)。関連: [[schedule-notion-connector-reattach]]
