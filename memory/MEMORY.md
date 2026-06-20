# Memory Index

- [Backup dotfiles-claude](backup-dotfiles-claude.md) — 「メモリ/設定をバックアップして」で ~/dotfiles-claude を main へ直 push(backup.sh)

- [X post from article](x-post-from-article.md) — how to summarize a given article into a CTO-voice X post for AI engineers
- [No decrypt protected files](no-decrypt-protected-files.md) — don't auto-decrypt encrypted files; ask the user for the content
- [Note article style](note-article-style.md) — style/tone guide for drafting note.com articles in the user's (Nishika CTO) voice
- [Nishika ASR positioning](nishika-asr-positioning.md) — shirushi=校正含む機構全体のブランド(shirushi-e/p/w)。外部採用はクラウドSMC、オンプレSMはWhisper/Parakeetを自社FT継続。PR表現方針に影響
- [Schedule Notion connector reattach](schedule-notion-connector-reattach.md) — /scheduleルーティンがNotion更新しない時は焼き込みconnector_uuid失効が主因。claude.aiのコネクタ画面で貼り直す
- [Product Wiki project](product-wiki-project.md) — SecureMemoCloudプロダクトWiki初版は sales-qa-miner/wiki/ に作成済み。設計原則と未決事項
- [SecureMemo (オンプレ) product](securememo-onprem-product.md) — オンプレ版の公式スペック・料金(クラサバ120万円/年〜・3ライセンス体系)・形態。資料v80由来
- [SecureMemoCloud product](securememocloud-product.md) — クラウド版の公式プラン(チーム/プロ/ビジネス/EP)・セキュリティ(Pマーク/ISMS/国内保管)。資料v45由来
- [Git commit identity](git-commit-identity.md) — コミット時にauthor/committerを-cで上書きしない。設定済みidentity(mhiro216)を尊重
- [Proofreading three layers](proofreading-three-layers.md) — SM/SMCの校正3層(汎用・単語・パーソナライズ)の仕組み・制約・切り返し順・製品差
- [SecureMemo AI model stack & ECCN](securememo-ai-model-stack-eccn.md) — 実モデル構成(Whisper/Parakeet/TitaNet/Gemma、Wiki記載は誤り)と全モデルEAR99の輸出管理判定根拠
- [Capability Discovery HF403 cause](capability-discovery-hf403-cause.md) — routineのHF403真因はenv egress allowlist欠落(token/WAFではない)。2026-06-15にカスタムallowlist＋プロンプト修正で解決済み
- [SMC context feature wedge](smc-context-feature-wedge.md) — SMC企業コンテキスト抽出の初手は営業ウェッジ(切り返し集)。決定台帳は誤りコスト非対称で後回し
- [Transcriber diarizer](transcriber-diarizer.md) — 話者認識(diarizer)アーキ地図: 場所・3モード(unsup/semi/sup)・非自明な設計判断。再探索の起点