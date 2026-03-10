import Foundation

enum RecordType: String, Codable, CaseIterable {
    case money
    case time
    case count

    var label: String {
        switch self {
        case .money: "金額"
        case .time:  "時間"
        case .count: "回数"
        }
    }

    var unit: String {
        switch self {
        case .money: "円"
        case .time:  "分"
        case .count: "回"
        }
    }

    var symbolName: String {
        switch self {
        case .money: "yensign.circle.fill"
        case .time:  "timer"
        case .count: "arrow.clockwise"
        }
    }
}
