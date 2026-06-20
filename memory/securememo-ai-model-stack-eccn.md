---
name: securememo-ai-model-stack-eccn
description: SecureMemoの実際のAIモデル構成(Wikiの記述は誤り)と、輸出管理上のECCN=EAR99判定根拠
metadata: 
  node_type: memory
  type: reference
  originSessionId: c937fe37-2027-4673-b233-fe7dee48fe77
---

SecureMemoの実装上のAIモデル構成(prd-securememo-v2-be で裏取り済み):
- 音声認識(高精度): **OpenAI Whisper large-v2(FT)** — `faster-whisper`
- 音声認識(RT): **NVIDIA Parakeet TDT-CTC(FT)** — 具体的には `parakeet-tdt_ctc-0.6b-ja`(FastConformerエンコーダ + TDT/CTCハイブリッドデコーダ。精度重視=TDT/低遅延=CTCを1モデル内で使い分け可)
- 話者認識: **NVIDIA TitaNet**(`titanet_l.nemo`)
- 議事録生成LLM: **Google Gemma-4-E2B**(`llama-cpp-python` でローカルGGUF推論)

**重要**: 営業Wiki([[product-wiki-project]] の 03-features.md / 04-strengths.md)は生成AIを「OpenAI系GPT APIを利用」と記載しているが、実態はローカルのGemma。オンプレ/セキュリティ訴求(外部APIに投げない)ではむしろ強い差別化材料。Wiki修正候補。

**輸出管理(EAR/外為法)該非判定**: 4モデルすべて米国原産のオープン公開モデル → **全てECCN=EAR99**。
- AIモデル直接規制の新ECCN 4E091 は「クローズドウェイト & 学習計算量10^26ops超」のみ対象。全モデルがオープン公開かつ閾値未満で対象外。さらに4E091を新設したAI Diffusion Ruleは2025/5/13に撤回済み。
- FT(ファインチューニング)してもベースがEAR99公開モデルのためde minimis上もEAR99のまま。
- ベンダーは個別モデルのECCN証明を公表しておらず自己分類が基本。確実性が要るならBIS CCATS取得か弁護士意見書。暗号(5D002)はモデルでなくSecureMemo製品全体側で別途確認。本筋は日本の外為法該非判定で、EARは米国原産OSS搭載ゆえの補完チェック。
- 防衛省等への販売・該非判定書の文脈。モデル変更のたびに再判定が必要。

関連: [[nishika-asr-positioning]] [[proofreading-three-layers]]
