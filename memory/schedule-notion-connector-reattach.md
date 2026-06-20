---
name: schedule-notion-connector-reattach
description: "/schedule routines lose Notion access when the baked-in connector_uuid goes stale — fix by re-attaching Notion in each routine's connector tab"
metadata: 
  node_type: memory
  type: project
  originSessionId: 47a80f65-324b-4776-8169-7d7c430f56f6
---

`/schedule` のリモートルーティン（CCRヘッドレス実行）がNotionページを更新しなくなる主因は、ルーティンJSONに焼き込まれた `mcp_connections` の `connector_uuid` が**失効**すること。失効すると無人実行時にNotionコネクタがアタッチされず、リモートエージェントのログに「Notion MCP connector is not available — only GitHub is connected」と出る（GitHubは環境がclone用にネイティブ供給するため別系統で生きている）。

**切り分けの確定事実:**
- `allowed_tools` は無関係。GitHubツールが許可リスト外でも使えていた＝allowed_toolsはMCPツールの可視性を絞っていない。
- connector_uuidはセッション側（Claude Code / `/schedule` スキル / `RemoteTrigger` API）からは**列挙も取得もできない**。`/schedule` のコネクタ一覧は0件表示になる。Notion MCPツール自体は対話セッションでは使える（このギャップが混乱の元）。

**直し方（唯一の有効手段）:** claude.ai のルーティン編集画面 → 「コネクター」タブで、Notionを × で外して再追加（貼り直し）。これで現行の有効なconnector_uuidに差し替わる。全ルーティン分やる必要がある。

実例: 失効 `ed47b08b-5803-40ac-b661-504b55380342` → 貼り直し後 `54d7175e-77eb-4e54-acfb-f3c383681e23`（2026-05-31、全10本）。NeMo Dependency Profile Refresh ルーティンで再実行→Notionページが当日付に全置換されることを実証済み。

検証手順: 再実行後、対象Notionページを `notion-fetch` し、`Last updated` が当日付＋テンプレ書式に変わったか確認する。
