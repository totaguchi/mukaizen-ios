import Foundation
import SwiftData

@Observable
@MainActor
final class HistoryViewModel {

    enum Period: String, CaseIterable, Identifiable {
        case oneMonth    = "過去1ヶ月"
        case threeMonths = "過去3ヶ月"
        case sixMonths   = "過去6ヶ月"
        case oneYear     = "過去1年"

        var id: String { rawValue }

        var startDate: Date {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            switch self {
            case .oneMonth:    return calendar.date(byAdding: .month, value: -1, to: today)!
            case .threeMonths: return calendar.date(byAdding: .month, value: -3, to: today)!
            case .sixMonths:   return calendar.date(byAdding: .month, value: -6, to: today)!
            case .oneYear:     return calendar.date(byAdding: .year,  value: -1, to: today)!
            }
        }
    }

    var selectedPeriod: Period = .oneMonth
    var searchText: String = ""

    func filteredRecords(from records: [Record]) -> [Record] {
        let startDate = selectedPeriod.startDate
        return records.filter { record in
            guard record.recordedAt >= startDate else { return false }
            if searchText.isEmpty { return true }
            let title = record.item?.title ?? ""
            let memo  = record.memo ?? ""
            return title.localizedCaseInsensitiveContains(searchText)
                || memo.localizedCaseInsensitiveContains(searchText)
        }
    }

    func deleteRecord(_ record: Record, context: ModelContext) {
        if let item = record.item {
            item.updatedAt = Date()
        }
        context.delete(record)
    }
}
