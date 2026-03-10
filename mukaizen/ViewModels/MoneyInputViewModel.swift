import SwiftUI
import SwiftData

@Observable
@MainActor
final class MoneyInputViewModel {
    private(set) var inputDigits: String = ""
    var memo: String = ""
    var recordedAt: Date = Date()
    var showDetails: Bool = false

    var displayText: String {
        guard !inputDigits.isEmpty, let value = Int(inputDigits) else { return "¥ 0" }
        return "¥ \(value.formatted())"
    }

    var numericValue: Double { Double(inputDigits) ?? 0 }
    var isValid: Bool { numericValue > 0 }

    func appendDigit(_ digit: String) {
        guard inputDigits.count < 8 else { return }
        if inputDigits.isEmpty && digit == "0" { return }
        inputDigits += digit
    }

    func appendDoubleZero() {
        guard !inputDigits.isEmpty else { return }
        let appended = inputDigits + "00"
        guard appended.count <= 8 else { return }
        inputDigits = appended
    }

    func backspace() {
        guard !inputDigits.isEmpty else { return }
        inputDigits.removeLast()
    }

    func save(to item: NotToDoItem, context: ModelContext) {
        let record = Record(
            value: numericValue,
            memo: memo.isEmpty ? nil : memo,
            recordedAt: recordedAt
        )
        record.item = item
        item.records.append(record)
        item.updatedAt = Date()
        context.insert(record)
    }
}
