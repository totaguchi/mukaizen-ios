import Foundation
import SwiftData

final class LocalNotToDoRepository: NotToDoRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addItem(_ item: NotToDoItem) {
        modelContext.insert(item)
    }

    func updateItem(_ item: NotToDoItem) {
        item.updatedAt = Date()
    }

    func deleteItem(_ item: NotToDoItem) {
        modelContext.delete(item)
    }

    func addRecord(_ record: Record, to item: NotToDoItem) {
        record.item = item
        item.records.append(record)
        item.updatedAt = Date()
        modelContext.insert(record)
    }

    func deleteRecord(_ record: Record) {
        if let item = record.item {
            item.updatedAt = Date()
        }
        modelContext.delete(record)
    }
}
