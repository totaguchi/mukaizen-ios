import SwiftUI
import SwiftData
import Charts

struct NotToDoDetailView: View {
    let itemId: UUID

    @Query private var items: [NotToDoItem]
    @State private var viewModel = NotToDoDetailViewModel()

    init(itemId: UUID) {
        self.itemId = itemId
        _items = Query(filter: #Predicate<NotToDoItem> { $0.id == itemId })
    }

    private var item: NotToDoItem? { items.first }

    var body: some View {
        Group {
            if let item {
                DetailContentView(item: item, viewModel: viewModel)
            } else {
                ContentUnavailableView("見つかりません", systemImage: "exclamationmark.triangle")
            }
        }
        .navigationTitle(item?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let item {
                    HStack {
                        Button {
                            viewModel.togglePin(item: item)
                        } label: {
                            Image(systemName: item.isPinned ? "pin.fill" : "pin")
                        }
                        Button("編集") {
                            viewModel.showEditForm = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showEditForm) {
            if let item {
                NotToDoFormView(item: item)
            }
        }
    }
}

// MARK: - Detail Content

private struct DetailContentView: View {
    let item: NotToDoItem
    let viewModel: NotToDoDetailViewModel
    @Environment(\.modelContext) private var modelContext

    private var sortedRecords: [Record] {
        item.records.sorted { $0.recordedAt > $1.recordedAt }
    }

    var body: some View {
        List {
            Section {
                TotalSummaryView(item: item)
            }

            if !item.records.isEmpty {
                Section("過去30日間") {
                    DetailChartView(item: item, viewModel: viewModel)
                        .frame(height: 160)
                        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                }
            }

            Section("記録履歴") {
                if sortedRecords.isEmpty {
                    ContentUnavailableView(
                        "記録がありません",
                        systemImage: "clock",
                        description: Text("アイコンをタップして記録を追加しましょう")
                    )
                } else {
                    ForEach(sortedRecords) { record in
                        RecordRow(record: record, showsItemInfo: false)
                    }
                    .onDelete { offsets in
                        let records = sortedRecords
                        for index in offsets {
                            viewModel.deleteRecord(records[index], for: item, context: modelContext)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Total Summary

private struct TotalSummaryView: View {
    let item: NotToDoItem

    private var totalValue: Double {
        item.records.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("累計")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(formattedTotal)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.accentColor)
                    .contentTransition(.numericText())
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("記録回数")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(item.records.count)回")
                    .font(.title2.bold())
            }
        }
        .padding(.vertical, 8)
    }

    private var formattedTotal: String {
        switch item.recordType {
        case .money: return "¥\(Int(totalValue).formatted())"
        case .time:  return formatMinutes(Int(totalValue))
        case .count: return "\(Int(totalValue))回"
        }
    }
}

// MARK: - Chart

private struct DetailChartView: View {
    let item: NotToDoItem
    let viewModel: NotToDoDetailViewModel

    var body: some View {
        let data = viewModel.chartData(for: item)
        Chart(data) { day in
            BarMark(
                x: .value("日付", day.date, unit: .day),
                y: .value(item.recordType.unit, day.total)
            )
            .foregroundStyle(Color.accentColor)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 7)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.month(.defaultDigits).day())
                            .font(.caption2)
                    }
                }
                AxisGridLine()
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisGridLine()
                AxisValueLabel()
            }
        }
    }
}
