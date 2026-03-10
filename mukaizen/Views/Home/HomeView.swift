import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \NotToDoItem.createdAt, order: .reverse)
    private var items: [NotToDoItem]

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomeViewModel()

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]

    // ピン留めを先頭に、次に作成日時降順
    private var sortedItems: [NotToDoItem] {
        items.sorted {
            if $0.isPinned != $1.isPinned { return $0.isPinned }
            return $0.createdAt > $1.createdAt
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SummaryCardRow(
                    todayMoney: viewModel.todayTotal(type: .money, from: sortedItems),
                    todayTime:  viewModel.todayTotal(type: .time,  from: sortedItems),
                    todayCount: viewModel.todayTotal(type: .count, from: sortedItems)
                )
                .padding(.horizontal)

                if sortedItems.isEmpty {
                    emptyStateView
                } else {
                    LazyVGrid(columns: gridColumns, spacing: 12) {
                        ForEach(sortedItems) { item in
                            NavigationLink(value: item.id) {
                                NotToDoCard(
                                    item: item,
                                    onIconTap: {
                                        viewModel.handleIconTap(item: item, context: modelContext)
                                    },
                                    onIconLongPress: {
                                        viewModel.handleIconLongPress(item: item)
                                    }
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.deleteItem(item, context: modelContext)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("やらないこと")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showAddForm = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(for: UUID.self) { id in
            NotToDoDetailView(itemId: id)
        }
        .fullScreenCover(item: $viewModel.recordSheet) { sheet in
            switch sheet {
            case .money(let item): MoneyInputView(item: item)
            case .time(let item):  TimeInputView(item: item)
            case .count(let item): CountInputView(item: item)
            }
        }
        .sheet(isPresented: $viewModel.showAddForm) {
            NotToDoFormView(item: nil)
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "やらないことを追加してみましょう",
            systemImage: "plus.circle",
            description: Text("右上の「＋」ボタンからやらないことを登録できます")
        )
        .padding(.top, 40)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(for: [NotToDoItem.self, Record.self], inMemory: true)
}
