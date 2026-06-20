---
name: transcriber-diarizer
description: transcriberリポの話者認識(diarizer)アーキ地図。場所・3モード・非自明な設計判断。再探索の起点
metadata: 
  node_type: memory
  type: reference
  originSessionId: f6685ce1-084b-4221-b6c3-f1c02a07373e
---

`/Users/mhiro/Projects/transcriber` はモノレポ: `transcriber/`(文字起こし)・`diarizer/`(話者分離)・`shared/`。話者認識ロジックは全て `diarizer/src/diarizer/` にある。詳細はコード参照、これは再探索を省くための地図。

**前提**: 発話セグメント(start/end/text)はWhisper側で確定済み。diarizerは「誰が話したか」を埋めるだけ。

**共通パイプライン**: decode_audio(16kHz) → subsegment分割(window 3.0s/shift 1.5s, `subsegments.py`) → Silero VAD で無音除去 → 埋め込み抽出(`embedding/`, TitaNet ONNX=192次元が主軸, ReDimNet選択可) → クラスタリング(`clustering/`) → `resolve_subsegment_labels` の多数決でセグメント単位に集約 → `segment.speaker_name` に書込。声紋認証モードのみsubsegment分割せずグループ直接照合。

**3モード** (`models/`):
- `UnsupervisedDiarizer`: 声紋不要。話者数未指定→UMAP→HDBSCAN→PAHC(自動推定) / 指定→SpectralClustering(wespeaker由来)+任意のpost_merge事後統合
- `SemiSupervisedDiarizer`: 声紋あり話者となし話者の混在。話者数必須(声紋数以上)。SeededSpectralClustering→内部 `SemiSupervisedKMeans`(`kmeans.py`)が声紋をknown_dataとしてシード固定(alpha=0.6)。声紋由来クラスタは person_name、他は speaker_N
- `SupervisedDiarizer`: 登録話者のみ前提。クラスタリングせず声紋埋め込みとのcosine類似度argmaxで直接割当。filter_low_occurrence_speakersで誤検知声紋除外

**非自明な設計判断**:
- 声紋の複数音声: supervisedは連結せず個別保持(ロバスト性), semi-supervisedはmedianで集約
- 音量正規化(pyln)はファイル出力せず推論直前に実施(量子化劣化回避)
- post_merge時、声紋由来クラスタは `protected` にして別人誤統合を防止
- セグメント/声紋は `transcriber_lib` の Protocol で疎結合(本体DBモデル非依存)

エントリ: `uv run diarize`(`cli.py`)/ ライブラリAPI(diarizer/README.md)。

実モデル構成・輸出管理は [[securememo-ai-model-stack-eccn]]、校正層は [[proofreading-three-layers]] 参照。
