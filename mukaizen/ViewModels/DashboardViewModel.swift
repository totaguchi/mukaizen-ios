import Foundation
import SwiftData

@Observable
@MainActor
final class DashboardViewModel {

    enum Period: String, CaseIterable, Identifiable {
        case weekly  = "週次"
        case monthly = "月次"

        var id: String { rawValue }

        var startDate: Date {
            let calendar = Calendar.current
            let now = Date()
            switch self {
            case .weekly:  return calendar.date(byAdding: .weekOfYear, value: -1, to: now)!
            case .monthly: return calendar.date(byAdding: .month, value: -1, to: now)!
            }
        }
    }

    var selectedPeriod: Period = .monthly

    // MARK: - Period Totals

    func totalMoney(from items: [NotToDoItem]) -> Double {
        periodRecords(type: .money, from: items).reduce(0) { $0 + $1.value }
    }

    func totalTime(from items: [NotToDoItem]) -> Double {
        periodRecords(type: .time, from: items).reduce(0) { $0 + $1.value }
    }

    func totalCount(from items: [NotToDoItem]) -> Double {
        periodRecords(type: .count, from: items).reduce(0) { $0 + $1.value }
    }

    // MARK: - Tag Breakdown

    func tagBreakdown(from items: [NotToDoItem]) -> [TagTotal] {
        let startDate = selectedPeriod.startDate
        var counts: [String: Int] = [:]
        for item in items {
            let count = item.records.filter { $0.recordedAt >= startDate }.count
            guard count > 0 else { continue }
            for tag in item.tags {
                counts[tag, default: 0] += count
            }
        }
        return counts
            .map { TagTotal(id: $0.key, tag: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    // MARK: - TOP3

    func top3Items(from items: [NotToDoItem]) -> [RankedItem] {
        let startDate = selectedPeriod.startDate
        let sorted = items
            .compactMap { item -> (item: NotToDoItem, count: Int)? in
                let count = item.records.filter { $0.recordedAt >= startDate }.count
                guard count > 0 else { return nil }
                return (item: item, count: count)
            }
            .sorted { $0.count > $1.count }
            .prefix(3)
        return sorted.enumerated().map { index, pair in
            RankedItem(rank: index + 1, item: pair.item, count: pair.count)
        }
    }

    // MARK: - Private

    private func periodRecords(type: RecordType, from items: [NotToDoItem]) -> [Record] {
        let startDate = selectedPeriod.startDate
        return items
            .filter { $0.recordType == type }
            .flatMap { $0.records }
            .filter { $0.recordedAt >= startDate }
    }
}

// MARK: - Data Models

struct TagTotal: Identifiable {
    let id: String
    let tag: String
    let count: Int
}

struct RankedItem: Identifiable {
    let id: UUID
    let rank: Int
    let item: NotToDoItem
    let count: Int

    init(rank: Int, item: NotToDoItem, count: Int) {
        self.id = item.id
        self.rank = rank
        self.item = item
        self.count = count
    }
}
