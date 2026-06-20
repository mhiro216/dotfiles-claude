---
name: smc-context-feature-wedge
description: SMCの「企業コンテキスト抽出」初手は営業ウェッジ(切り返し集)。決定台帳は精度の土台ができた後。
metadata: 
  node_type: memory
  type: project
  originSessionId: d2c573b0-72ca-4838-b2c0-b9c89dcae2c2
---

SecureMemoCloudに「企業のコンテキスト情報」抽出機能を載せる方針。裏側は網羅抽出(企業コンテキストグラフ)で共通化し、出口(見せる機能)は1つに絞る。

初手の出口は**営業ウェッジ＝商談プレイブック自動生成(勝ちパターン切り返し集)**に決定(2026-06-16)。

**Why:** 決定台帳(決定/未決/宿題/担当)は誤りのコストが非対称で危険——commission error(誤って言い切る)が致命的で、日本の会議は「空気で決まる」ため明示音声に出ず構造的に外しやすい。第一印象の下限が低い。営業はomission error中心で許容され(取りこぼしてもライブラリが小さいだけ)、抽出対象(顧客の質問/懸念/切り返し)が明示的発話で日本語でも拾いやすく、話者構成も明確で精度の下限が高い。

**How to apply:** 初手は営業に絞る(買い手=営業部長/CRO、ROI=受注率・新人立ち上がり)。決定台帳は信頼の土台ができた後に後置。橋渡しとして商談後ネクストアクションのみ安全な部分集合として先行検証可。既存資産 [[product-wiki-project]] の sales-qa-miner / sales-realtime-advisor をSMC本体に組み込む方向。関連: [[securememocloud-product]] [[nishika-asr-positioning]]
