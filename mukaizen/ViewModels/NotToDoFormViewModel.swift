import SwiftUI
import SwiftData

@Observable
@MainActor
final class NotToDoFormViewModel {
    var title: String = ""
    var recordType: RecordType = .money
    var selectedTags: Set<String> = []
    var itemDescription: String = ""

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func setup(from item: NotToDoItem) {
        title = item.title
        recordType = item.recordType
        selectedTags = Set(item.tags)
        itemDescription = item.itemDescription ?? ""
    }

    func save(editing item: NotToDoItem?, context: ModelContext) {
        if let item {
            item.title = title
            item.recordType = recordType
            item.tags = Array(selectedTags)
            item.itemDescription = itemDescription.isEmpty ? nil : itemDescription
            item.updatedAt = Date()
        } else {
            let newItem = NotToDoItem(
                title: title,
                recordType: recordType,
                tags: Array(selectedTags),
                itemDescription: itemDescription.isEmpty ? nil : itemDescription
            )
            context.insert(newItem)
        }
    }
}
