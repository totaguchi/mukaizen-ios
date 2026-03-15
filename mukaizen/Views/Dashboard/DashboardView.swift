import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Query private var items: [NotToDoItem]
    @State private var viewModel = DashboardViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 集計期間
                Picker("集計期間", selection: $viewModel.selectedPeriod) {
                    ForEach(DashboardViewModel.Period.allCases) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // 合計サマリー
                DashboardSummaryRow(
                    totalMoney: viewModel.totalMoney(from: items),
                    totalTime:  viewModel.totalTime(from: items),
                    totalCount: viewModel.totalCount(from: items)
                )
                .padding(.horizontal)

                // タグ別棒グラフ
                let breakdown = viewModel.tagBreakdown(from: items)
                if !breakdown.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("タグ別やらかし回数")
                            .font(.headline)
                            .padding(.horizontal)

                        Chart(breakdown) { tagTotal in
                            BarMark(
                                x: .value("タグ", tagTotal.tag),
                                y: .value("回数", tagTotal.count)
                            )
                            .foregroundStyle(Color.accentColor)
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                }

                // TOP3 ランキング
                let top3 = viewModel.top3Items(from: items)
                if !top3.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("やらかし TOP3")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 8) {
                            ForEach(top3) { ranked in
                                RankedItemRow(ranked: ranked)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                if items.isEmpty {
                    ContentUnavailableView(
                        "データがありません",
                        systemImage: "chart.bar",
                        description: Text("やらないことを追加して記録を始めましょう")
                    )
                    .padding(.top, 40)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("ダッシュボード")
    }
}

// MARK: - Summary Row

private struct DashboardSummaryRow: View {
    let totalMoney: Double
    let totalTime: Double
    let totalCount: Double

    var body: some View {
        HStack(spacing: 8) {
            DashboardCard(
                title: "無駄づかい",
                value: "¥\(Int(totalMoney).formatted())",
                symbolName: "yensign.circle.fill"
            )
            DashboardCard(
                title: "浪費時間",
                value: formatMinutes(Int(totalTime)),
                symbolName: "timer"
            )
            DashboardCard(
                title: "やらかし回数",
                value: "\(Int(totalCount))回",
                symbolName: "arrow.clockwise"
            )
        }
    }
}

private struct DashboardCard: View {
    let title: String
    let value: String
    let symbolName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: symbolName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.subheadline.bold())
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Ranked Item Row

private struct RankedItemRow: View {
    let ranked: RankedItem

    var body: some View {
        HStack(spacing: 12) {
            Text("\(ranked.rank)位")
                .font(.headline)
                .foregroundStyle(Color.accentColor)
                .frame(width: 40, alignment: .center)

            Image(systemName: ranked.item.recordType.symbolName)
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
                .frame(width: 20)

            Text(ranked.item.title)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()

            Text("\(ranked.count)回")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
    .modelContainer(for: [NotToDoItem.self, Record.self], inMemory: true)
}
