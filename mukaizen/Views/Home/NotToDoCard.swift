import SwiftUI

struct NotToDoCard: View {
    let item: NotToDoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 上段: ピン留め（アイコンはHomeViewのオーバーレイで表示）
            HStack(alignment: .top) {
                Image(systemName: "pin.fill")
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
                    .opacity(item.isPinned ? 1 : 0)

                Spacer()

                // RecordTypeIconと同サイズのスペースを確保
                Color.clear.frame(width: 44, height: 44)
            }

            // タイトル（最大2行）
            Text(item.title)
                .font(.headline)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            // 累計値（変化時にアニメーション）
            Text(formattedTotal)
                .font(.title2.bold())
                .foregroundStyle(Color.accentColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .contentTransition(.numericText())
                .animation(.spring, value: formattedTotal)

            // タグ
            if !item.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(item.tags, id: \.self) { tag in
                            TagChip(name: tag)
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 14))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(cardAccessibilityLabel)
    }

    private var formattedTotal: String {
        let total = item.records.reduce(0) { $0 + $1.value }
        switch item.recordType {
        case .money:
            return "¥\(Int(total).formatted())"
        case .time:
            return formatMinutes(Int(total))
        case .count:
            return "\(Int(total))回"
        }
    }

    private var cardAccessibilityLabel: String {
        var parts: [String] = [item.title]
        if item.isPinned { parts.append("ピン留め") }
        parts.append("累計 \(formattedTotal)")
        if !item.tags.isEmpty { parts.append(item.tags.joined(separator: "、")) }
        return parts.joined(separator: "、")
    }
}
