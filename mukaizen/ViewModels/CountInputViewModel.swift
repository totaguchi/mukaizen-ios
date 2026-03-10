import SwiftUI
import SwiftData

@Observable
@MainActor
final class CountInputViewModel {
    var count: Int = 1
    var memo: String = ""
    var recordedAt: Date = Date()
    var showDetails: Bool = false

    var isValid: Bool { count > 0 }

    func increment() { count += 1 }

    func decrement() {
        if count > 1 { count -= 1 }
    }

    func save(to item: NotToDoItem, context: ModelContext) {
        let record = Record(
            value: Double(count),
            memo: memo.isEmpty ? nil : memo,
            recordedAt: recordedAt
        )
        record.item = item
        item.records.append(record)
        item.updatedAt = Date()
        context.insert(record)
    }
}
