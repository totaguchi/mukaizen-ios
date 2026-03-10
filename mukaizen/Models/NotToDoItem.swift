import Foundation
import SwiftData

@Model
final class NotToDoItem {
    var id: UUID
    var title: String
    var recordType: RecordType
    var tags: [String]
    var itemDescription: String?
    var isPinned: Bool
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade)
    var records: [Record]

    init(
        title: String,
        recordType: RecordType,
        tags: [String] = [],
        itemDescription: String? = nil,
        isPinned: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.recordType = recordType
        self.tags = tags
        self.itemDescription = itemDescription
        self.isPinned = isPinned
        self.createdAt = Date()
        self.updatedAt = Date()
        self.records = []
    }
}
