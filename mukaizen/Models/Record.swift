import Foundation
import SwiftData

@Model
final class Record {
    var id: UUID
    var value: Double       // 金額(円) / 時間(分) / 回数
    var memo: String?
    var recordedAt: Date    // ユーザー指定の記録日時
    var createdAt: Date     // 実際の入力日時

    var item: NotToDoItem?

    init(value: Double, memo: String? = nil, recordedAt: Date = Date()) {
        self.id = UUID()
        self.value = value
        self.memo = memo
        self.recordedAt = recordedAt
        self.createdAt = Date()
    }
}
