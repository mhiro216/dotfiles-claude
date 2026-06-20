---
name: product-wiki-project
description: SecureMemoCloudのプロダクトWiki構想と実装場所、設計原則
metadata: 
  node_type: memory
  type: project
  originSessionId: 45424546-e4e3-42a0-b717-ce885cd61b57
---

プロダクト「Wiki」構想(DeepWikiのプロダクト版)の初版を2026-06-02に作成。場所: `/Users/mhiro/Projects/sales-qa-miner/wiki/`(README + 12ページのMarkdown)。

設計原則(ユーザーと合意済み):
- 第一読者は新人営業。品質基準は「商談で出た質問にWikiが答えられるか」
- 確度マーク: ✅資料記載 / 💬商談説明 / 🔮予定 を全記述に付与。出典は [資料pN] [QA:transcription_id] [site] [zendesk]
- 「制約・非対応」(05-limitations.md)を一級市民として扱う — 営業資料に書かれない最重要ページ
- 商談QA(`output/qa_list.csv`、[[sales-qa-miner]]の出力)を一次データとし、Wikiは再生成可能なパイプラインを志向

2026-06-02に3点完了: ①Notionミラー作成(https://www.notion.so/373da318eeda8044aee9ff8fcc675ddf、対応表は wiki/notion-map.json、マスターはMD側) ②qa_list→Wiki反映パイプライン(`/wiki-sync` プロジェクトスキル + wiki/.sync-state.json 台帳) ③汎用プレイブック `sales-qa-miner/PRODUCT_WIKI_PLAYBOOK.md`(別プロダクト横展開用の指示書)。

運用ルール: Notionだけ直接修正しない(MDマスター→Notionの順)。NotionテーブルはXML形式、引用マーカーはインラインコード表記。

2026-06-02に初回フル同期完了: 全106商談・QA1,023件を反映(新規950件→重複除外→新事実約110項目)。台帳=1,023キー。**要確認の矛盾9件は `wiki/SYNC_REPORT_2026-06-02.md` に記録**(最優先=音声のみ削除の可否、WS追加料金5,000円vs1,000円、トライアル延長ルール)。大規模同期の手順: カテゴリ群分割→並列エージェント分析→MD統合→Notion同期もエージェント分担。
未決事項: 外部公開版の是非、営業フィードバック反映後の改訂。
データソース: 営業資料v45 PDF、securememo-cloud.com、Zendesk、商談文字起こしCSV(いずれも sales-qa-miner ディレクトリ周辺)。

## 2026-06-09 補正: SecureMemo/LGWAN検討時の機能前提

- SecureMemoには**カスタム要約がある**。
- **パーソナライズ校正は今後入る**前提。
- **AIチャットはまだ実装着手していないが、入れることは可能**。
- LGWAN対応の難しさを説明するとき、これらの機能有無そのものを主因として扱わない。主因は、提供形態、閉域網制約、AI/推論基盤の配置、三層分離下のファイル投入運用、J-LIS/LGWAN-ASP手続き、運用保守の問題として分析する。
