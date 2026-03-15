import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query private var records: [Record]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HistoryViewModel()

    init() {
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        _records = Query(
            filter: #Predicate<Record> { $0.recordedAt >= oneYearAgo },
            sort: \Record.recordedAt,
            order: .reverse
        )
    }

    private var filteredRecords: [Record] {
        viewModel.filteredRecords(from: records)
    }

    var body: some View {
        List {
            ForEach(filteredRecords) { record in
                RecordRow(record: record, showsItemInfo: true)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteRecord(record, context: modelContext)
                        } label: {
                            Label("削除", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .navigationTitle("履歴")
        .searchable(text: $viewModel.searchText, prompt: "アイテム名・メモで検索")
        .overlay {
            if filteredRecords.isEmpty {
                if viewModel.searchText.isEmpty {
                    ContentUnavailableView(
                        "記録がありません",
                        systemImage: "clock",
                        description: Text("選択した期間に記録はありません")
                    )
                } else {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Picker("期間", selection: $viewModel.selectedPeriod) {
                    ForEach(HistoryViewModel.Period.allCases) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .modelContainer(for: [NotToDoItem.self, Record.self], inMemory: true)
}
