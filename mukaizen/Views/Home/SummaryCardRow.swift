import SwiftUI

struct SummaryCardRow: View {
    let todayMoney: Double
    let todayTime: Double
    let todayCount: Double

    var body: some View {
        HStack(spacing: 8) {
            SummaryCard(
                title: "無駄づかい",
                value: formattedMoney,
                symbolName: "yensign.circle.fill"
            )
            SummaryCard(
                title: "浪費時間",
                value: formattedTime,
                symbolName: "timer"
            )
            SummaryCard(
                title: "やらかし",
                value: formattedCount,
                symbolName: "arrow.clockwise"
            )
        }
    }

    private var formattedMoney: String {
        let value = Int(todayMoney)
        return "¥\(value.formatted())"
    }

    private var formattedTime: String {
        formatMinutes(Int(todayTime))
    }

    private var formattedCount: String { "\(Int(todayCount))回" }
}

private struct SummaryCard: View {
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
