import SwiftUI

struct NotToDoCard: View {
    let item: NotToDoItem
    let onIconTap: () -> Void
    let onIconLongPress: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 上段: ピン留め + 記録タイプアイコン
            HStack(alignment: .top) {
                Image(systemName: "pin.fill")
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
                    .opacity(item.isPinned ? 1 : 0)

                Spacer()

                RecordTypeIcon(
                    type: item.recordType,
                    onTap: onIconTap,
                    onLongPress: onIconLongPress
                )
            }

            // タイトル（最大2行）
            Text(item.title)
                .font(.headline)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            // 累計値
            Text(formattedTotal)
                .font(.title2.bold())
                .foregroundStyle(Color.accentColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

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
    }

    private var formattedTotal: String {
        let total = item.records.reduce(0) { $0 + $1.value }
        switch item.recordType {
        case .money:
            return "¥\(Int(total).formatted())"
        case .time:
            let h = Int(total) / 60
            let m = Int(total) % 60
            return h > 0 ? "\(h)時間\(m)分" : "\(Int(total))分"
        case .count:
            return "\(Int(total))回"
        }
    }
}
