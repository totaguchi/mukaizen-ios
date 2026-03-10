import SwiftUI
import SwiftData

// Phase 3 で完全実装予定
struct NotToDoDetailView: View {
    let itemId: UUID

    @Query private var items: [NotToDoItem]

    private var item: NotToDoItem? {
        items.first { $0.id == itemId }
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
