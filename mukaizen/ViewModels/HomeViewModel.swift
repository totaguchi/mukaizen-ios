import SwiftUI
import SwiftData

@Observable
@MainActor
final class HomeViewModel {

    // MARK: - Sheet Management

    enum RecordSheet: Identifiable {
        case money(NotToDoItem)
        case time(NotToDoItem)
        case count(NotToDoItem)

        var id: String {
            switch self {
            case .money(let item): "money-\(item.id)"
            case .time(let item):  "time-\(item.id)"
            case .count(let item): "count-\(item.id)"
            }
        }
    }

    var recordSheet: RecordSheet?
    var showAddForm = false

    // MARK: - Actions

    func handleIconTap(item: NotToDoItem, context: ModelContext) {
        switch item.recordType {
        case .money: recordSheet = .money(item)
        case .time:  recordSheet = .time(item)
        case .count: addImmediateCount(to: item, context: context)
        }
    }

    func handleIconLongPress(item: NotToDoItem) {
        guard item.recordType == .count else { return }
        recordSheet = .count(item)
    }

    func deleteItem(_ item: NotToDoItem, context: ModelContext) {
        context.delete(item)
    }

    // MARK: - Today's Summary

    func todayTotal(type: RecordType, from items: [NotToDoItem]) -> Double {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return items
            .filter { $0.recordType == type }
            .flatMap { $0.records }
            .filter { $0.recordedAt >= startOfDay }
            .reduce(0) { $0 + $1.value }
    }

    // MARK: - Private

    private func addImmediateCount(to item: NotToDoItem, context: ModelContext) {
        let record = Record(value: 1)
        record.item = item
        item.records.append(record)
        item.updatedAt = Date()
        context.insert(record)
    }
}
