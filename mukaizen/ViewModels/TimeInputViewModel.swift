import SwiftUI
import SwiftData

@Observable
@MainActor
final class TimeInputViewModel {
    var minutes: Int = 0
    var memo: String = ""
    var recordedAt: Date = Date()
    var showDetails: Bool = false

    var isValid: Bool { minutes > 0 }

    static let presets = [5, 15, 30, 60, 90]

    func increment() { minutes += 1 }

    func decrement() {
        if minutes > 0 { minutes -= 1 }
    }

    func setPreset(_ value: Int) { minutes = value }

    func save(to item: NotToDoItem, context: ModelContext) {
        let record = Record(
            value: Double(minutes),
            memo: memo.isEmpty ? nil : memo,
            recordedAt: recordedAt
        )
        record.item = item
        item.records.append(record)
        item.updatedAt = Date()
        context.insert(record)
    }
}
