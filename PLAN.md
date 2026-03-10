# Mukaizen iOS 実装プラン

## 現状

Xcode プロジェクトはテンプレート状態（`ContentView.swift` + `Item.swift` のみ）。
デザインは Stitch プロジェクト（ID: `12670318902360013807`）で確定済み。

---

## Stitch 画面 → 実装対象マッピング

| Stitch スクリーンID | ラベル | 実装ファイル |
|---|---|---|
| `941b82e77703488f9186baa2f1a1d9d3` | オンボーディング | `OnboardingView.swift` |
| `f65bc0ae06eb4d3e8f1d3569d31ad91a` | ホーム | `HomeView.swift` |
| `fa2fb9cff0e74ef491d84f8a30cc0292` | やらないこと追加画面 | `NotToDoFormView.swift` |
| `3f2659e523ac4b8cb0ad580f3a2059b2` | やらないこと詳細画面 | `NotToDoDetailView.swift` |
| `2eb705ff83c341c78277334860264d39` | 金額入力画面 | `MoneyInputView.swift` |
| `dd63ce0629bb43258665656758a4d03d` | 時間入力画面 | `TimeInputView.swift` |
| `79f044252f9f40919c60982d63e5dc5d` | 回数入力画面 | `CountInputView.swift` |
| `1593b8694aa646b2bb06a6327dd3f367` | 履歴画面 | `HistoryView.swift` |
| `c535f283cb9447348c8b5f134a94b4b8` | ダッシュボード画面 | `DashboardView.swift` |

---

## ディレクトリ構成

```
mukaizen/
├── mukaizenApp.swift
├── Models/
│   ├── NotToDoItem.swift       # @Model
│   ├── Record.swift            # @Model
│   └── RecordType.swift        # enum
├── Repositories/
│   ├── NotToDoRepository.swift # Protocol
│   └── LocalNotToDoRepository.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── NotToDoFormViewModel.swift
│   ├── RecordInputViewModel.swift
│   ├── NotToDoDetailViewModel.swift
│   ├── HistoryViewModel.swift
│   └── DashboardViewModel.swift
├── Views/
│   ├── Root/
│   │   ├── RootView.swift          # TabView ルート
│   │   └── OnboardingView.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── NotToDoCard.swift
│   │   └── SummaryCardRow.swift
│   ├── RecordInput/
│   │   ├── MoneyInputView.swift
│   │   ├── TimeInputView.swift
│   │   └── CountInputView.swift
│   ├── Detail/
│   │   └── NotToDoDetailView.swift
│   ├── Form/
│   │   └── NotToDoFormView.swift
│   ├── History/
│   │   ├── HistoryView.swift
│   │   └── RecordRow.swift         # 履歴・詳細で共有
│   └── Dashboard/
│       └── DashboardView.swift
└── Components/
    ├── TagChip.swift
    ├── RecordTypeIcon.swift
    └── StepperInput.swift
```

---

## データモデル

```swift
// Models/NotToDoItem.swift
@Model
final class NotToDoItem {
    var id: UUID
    var title: String
    var recordType: RecordType
    var tags: [String]
    var itemDescription: String?
    var isPinned: Bool
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade)
    var records: [Record]
}

// Models/Record.swift
@Model
final class Record {
    var id: UUID
    var value: Double       // 金額(円) / 時間(分) / 回数
    var memo: String?
    var recordedAt: Date    // ユーザー指定日時
    var createdAt: Date     // 実際の入力日時

    var item: NotToDoItem?
}

// Models/RecordType.swift
enum RecordType: String, Codable {
    case money  // 円
    case time   // 分
    case count  // 回
}
```

`ModelContainer` は `NotToDoItem` + `Record` に変更する（`Item.swift` は削除）。

---

## アーキテクチャ

```
View（SwiftUI）
  └── ViewModel（@Observable）
        └── Repository（Protocol）
              └── LocalNotToDoRepository（SwiftData）
```

- `@Observable` マクロ（iOS 17+）で ViewModel を定義
- Repository Protocol でデータ層を抽象化（将来の Supabase 等への切り替えに備える）

---

## 実装フェーズ

### Phase 1 — 骨格・データ層（最初に実装）

- [ ] `Item.swift` を削除し `NotToDoItem.swift` / `Record.swift` / `RecordType.swift` を作成
- [ ] `mukaizenApp.swift` の `ModelContainer` を更新
- [ ] `NotToDoRepository` プロトコルと `LocalNotToDoRepository` を実装
- [ ] `RootView.swift`（TabView: ホーム / 履歴 / ダッシュボード / 設定）を作成
- [ ] オンボーディング表示ロジック（`@AppStorage("hasLaunchedBefore")`）

### Phase 2 — ホーム画面・記録入力（コア機能）

- [ ] `HomeView.swift`：2カラムグリッド + サマリーカード
  - `NotToDoCard.swift`：カード本体タップ→詳細、アイコンタップ→入力シート
  - `SummaryCardRow.swift`：今日の合計（金額 / 時間 / 回数）
- [ ] `NotToDoFormView.swift`：アイテム追加 / 編集フォーム
- [ ] `MoneyInputView.swift`：カスタムキーボード（数値キー + 00キー）
- [ ] `TimeInputView.swift`：ステッパー + プリセット（5/15/30/60/90分）
- [ ] `CountInputView.swift`：ステッパー + メモ欄（ロングタップから開く）

### Phase 3 — 詳細・履歴・ダッシュボード

- [ ] `RecordRow.swift`：`showsItemInfo: Bool` で表示項目を切り替える共有コンポーネント
- [ ] `NotToDoDetailView.swift`：累計サマリー + Swift Charts 棒グラフ + 履歴リスト
- [ ] `HistoryView.swift`：全記録一覧（デフォルト過去1ヶ月、最大1年）+ 検索 + フィルタ
- [ ] `DashboardView.swift`：週次/月次集計 + タグ別棒グラフ + TOP3ランキング

### Phase 4 — 仕上げ

- [ ] `OnboardingView.swift`：初回起動時のみ表示
- [ ] `TagChip.swift` / `RecordTypeIcon.swift` / `StepperInput.swift`（共通コンポーネント整理）
- [ ] ライト / ダークモード対応確認（セマンティックカラー使用）
- [ ] ハプティクス（回数タイプのカウントアップ時）
- [ ] アニメーション（カード累計数値の更新アニメーション）
- [ ] アクセシビリティ（VoiceOver ラベル）

---

## UIデザイン仕様（要点）

- **カラー**：`systemBackground` / `secondarySystemBackground` / `label` / `secondaryLabel`（セマンティックカラー）
- **アクセントカラー**：コーラルレッド `#FF5A5A`（`AccentColor` に設定）
- **フォント**：San Francisco（システムフォント、Dynamic Type 対応）
- **角丸**：`cornerRadius: 12〜16pt`
- **グリッド基準**：8pt
- **最小タップ領域**：44×44pt
- **言語**：UI文言はすべて日本語

---

## 技術スタック

| 要素 | 採用技術 |
|---|---|
| UI | SwiftUI（iOS 17+） |
| 状態管理 | `@Observable`（iOS 17+） |
| DB | SwiftData（`@Model` / `@Query`） |
| グラフ | Swift Charts（iOS 16+） |
| 画面遷移 | `NavigationStack` + `TabView` |
| 入力シート | `.fullScreenCover` |
| 最低対応OS | iOS 17 |

---

## 参考リンク

- Stitch プロジェクト ID: `12670318902360013807`
- 要件詳細: `files/PLAN.md`
- デザイン仕様: `files/DESIGN_BRIEF.md`
