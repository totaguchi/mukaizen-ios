import Foundation
import SwiftData

@Observable
@MainActor
final class NotToDoDetailViewModel {

    var showEditForm = false

    // MARK: - Chart Data（過去30日間の日別合計）

    func chartData(for item: NotToDoItem) -> [DailyRecord] {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now))!

        let grouped = Dictionary(
            grouping: item.records.filter { $0.recordedAt >= startDate }
        ) {
            calendar.startOfDay(for: $0.recordedAt)
        }

        return (0..<30).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate)!
            let total = grouped[date]?.reduce(0) { $0 + $1.value } ?? 0
            return DailyRecord(id: date, date: date, total: total)
        }
    }

    // MARK: - Actions

    func deleteRecord(_ record: Record, context: ModelContext) {
        context.delete(record)
    }

    func togglePin(item: NotToDoItem) {
        item.isPinned.toggle()
        item.updatedAt = Date()
    }
}

// MARK: - Chart Data Model

struct DailyRecord: Identifiable {
    let id: Date
    let date: Date
    let total: Double
}
