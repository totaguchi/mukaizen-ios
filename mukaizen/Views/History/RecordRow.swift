import SwiftUI

struct RecordRow: View {
    let record: Record
    let showsItemInfo: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // アイテム名・タイプアイコン（履歴画面のみ表示）
            if showsItemInfo, let item = record.item {
                HStack(spacing: 6) {
                    Image(systemName: item.recordType.symbolName)
                        .font(.caption)
                        .foregroundStyle(Color.accentColor)
                    Text(item.title)
                        .font(.subheadline.bold())
                        .lineLimit(1)
                }
            }

            // 数値 + 日時
            HStack(alignment: .top) {
                Text(formattedValue)
                    .font(.title3.bold())
                    .foregroundStyle(Color.accentColor)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(record.recordedAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(record.recordedAt, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // メモ（任意）
            if let memo = record.memo, !memo.isEmpty {
                Text(memo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            // タグ（履歴画面のみ）
            if showsItemInfo, let item = record.item, !item.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(item.tags, id: \.self) { tag in
                            TagChip(name: tag)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(rowAccessibilityLabel)
    }

    private var formattedValue: String {
        guard let item = record.item else { return "\(Int(record.value))" }
        switch item.recordType {
        case .money: return "¥\(Int(record.value).formatted())"
        case .time:  return formatMinutes(Int(record.value))
        case .count: return "\(Int(record.value))回"
        }
    }

    private var rowAccessibilityLabel: String {
        var parts: [String] = []
        if showsItemInfo, let item = record.item {
            parts.append(item.title)
        }
        parts.append(formattedValue)
        parts.append(record.recordedAt.formatted(date: .abbreviated, time: .shortened))
        if let memo = record.memo, !memo.isEmpty {
            parts.append(memo)
        }
        if showsItemInfo, let item = record.item, !item.tags.isEmpty {
            parts.append(item.tags.joined(separator: "、"))
        }
        return parts.joined(separator: "、")
    }
}
