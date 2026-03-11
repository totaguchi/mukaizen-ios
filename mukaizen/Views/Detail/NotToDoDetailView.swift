import SwiftUI
import SwiftData

// Phase 3 で完全実装予定
struct NotToDoDetailView: View {
    let itemId: UUID

    @Query private var items: [NotToDoItem]

    init(itemId: UUID) {
        self.itemId = itemId
        _items = Query(filter: #Predicate<NotToDoItem> { $0.id == itemId })
    }

    private var item: NotToDoItem? {
        items.first
    }

    var body: some View {
        Group {
            if let item {
                ContentUnavailableView(
                    item.title,
                    systemImage: "chart.bar",
                    description: Text("Phase 3 で実装予定")
                )
            } else {
                ContentUnavailableView("見つかりません", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle(item?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
