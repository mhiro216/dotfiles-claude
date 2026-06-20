---
name: nishika-asr-positioning
description: Nishikaの音声認識戦略とshirushiブランドの正確な定義。shirushi=ASRエンジン単体ではなく「校正まで含めて音声認識結果を届ける機構全体」のブランド。外部採用(ElevenLabs)はクラウドSMC側、オンプレSMはWhisper/Parakeetを自社FTで継続。PR/マーケ素材の表現方針に直結。
metadata: 
  node_type: memory
  type: project
  originSessionId: 60cd24f8-0b95-4158-b60c-e30b716a0808
---

NishikaのASR戦略と`shirushi`ブランドの定義。ASR関連の外向け文章を書く前に必ず参照すること。**「外部採用」を製品横断で一般化しないことが最重要**(旧版の誤りを2026-06-17に修正)。

## shirushiブランドの定義（ここが核心）
- **`shirushi` はASRエンジン単体の名前ではない**。**ASR + パーソナライズ校正を含む「ユーザーに音声認識結果を届ける機構全体」を指すブランド**。差別化ストーリーはこのブランド全体で語る。
- 外部向け呼称は、バックエンドのASR基盤ごとに枝番で統一:
  - **shirushi-e** = ElevenLabs ベース
  - **shirushi-p** = NVIDIA Parakeet ベース
  - **shirushi-w** = OpenAI Whisper ベース
- バージョンを上げる契機は2つ。①学習データを増やしてFT、②ElevenLabsのように全く新しいモデルを採用。**マーケティング目的も兼ねてver表記を更新**する運用。

## 自社開発 vs 外部採用（実態 — 製品で異なる）
- **Parakeet / Whisper（shirushi-p / shirushi-w）は自社でFTしている**＝自社開発の実体がある(スクラッチではないがFT)。
- **ElevenLabs（shirushi-e）は自社FTしていない**＝純粋な外部採用。
- **製品軸の分岐（重要）**:
  - **SMC（クラウド）**: 外部クラウドASR（shirushi-e/ElevenLabs）を採用可。
  - **SM（オンプレ）**: 顧客環境・閉域で動くため外部クラウドASRは原理的に使えない。**shirushi-p / shirushi-w をオンデバイスで自社FT・維持し続ける必要がある**。「外部APIに投げない」がオンプレの売り([[securememo-ai-model-stack-eccn]])なので、外部採用はむしろ方針に反する。
- 公表事実: `shirushi-1.5` = 「OpenAI Whisperのファインチューニング」。これと矛盾しない書き方を保つ。
- 競争優位の集約先は引き続き **ASR出力をユーザー修正履歴で校正する後段機構（パーソナライズ校正）**。LLM＋修正履歴の特許アルゴリズム、"使うほど賢くなる"。参考PR: https://prtimes.jp/main/html/rd/p/000000088.000052152.html

## Why（背景・動機）
ASR基盤モデルはコモディティ化が進み、クラウド側では外部の高性能基盤(ElevenLabs等)を採用する方が投資対効果が高い。一方オンプレは外部非依存が価値の源泉なので自社FTモデルを持ち続ける。いずれの製品でも「企業の会議を全てデータ化する」ビジョンは、ASR本体ではなく**ユーザー適応の校正レイヤー**で実現する戦略。

## How to apply（PR/マーケ素材を書くときの方針）
- **製品文脈を必ず確認してから書く**。「ASRは外部採用へ」と全社一般化しない。オンプレ(SM)の文脈では外部採用・「次世代基盤への刷新(=外部)」表現を使わず、**自社開発(FT)・外部非依存**を貫く。
- `shirushi` を「音声認識エンジン」と矮小化せず、**校正まで含む機構全体のブランド**として打ち出す。
- **バックエンドの第三者ベンダー名（ElevenLabs等）は対外公表しない**(2026年5月時点のCTO松田の意向)。記者・読者からの「ベースは？」想定問答を用意して納品。
- ASR単体を「100%自社スクラッチ開発」とは書かない（実態はFTまたは外部採用）。「自社開発のshirushiシリーズ」「自社で評価・選定・最適化」程度に留める。
- **「使うほど賢くなる」「修正履歴を学習」「パーソナライズ校正」**を軸に差別化ストーリーを寄せる。

関連: [[note-article-style]] [[securememo-ai-model-stack-eccn]] [[proofreading-three-layers]]
