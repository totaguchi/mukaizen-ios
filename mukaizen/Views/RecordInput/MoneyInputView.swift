import SwiftUI
import SwiftData

struct MoneyInputView: View {
    let item: NotToDoItem

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = MoneyInputViewModel()

    @ScaledMetric private var keyHeight: CGFloat = 68

    var body: some View {
        VStack(spacing: 0) {
            RecordInputHeader(
                title: "金額を記録",
                subtitle: item.title,
                onDismiss: { dismiss() }
            )

            Divider()

            // 入力金額（右寄せ・大きく表示）
            Text(viewModel.displayText)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .contentTransition(.numericText())
                .animation(.snappy, value: viewModel.displayText)

            Divider()

            // 詳細セクション（折りたたみ）
            DisclosureGroup(
                isExpanded: $viewModel.showDetails,
                content: { detailsSection },
                label: {
                    Label("詳細を追加", systemImage: "chevron.down")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider()

            // カスタムキーパッド
            VStack(spacing: 4) {
                numpadRow(["7", "8", "9", "⌫"])
                numpadRow(["4", "5", "6", "00"])
                numpadRow(["1", "2", "3", ""])
                numpadLastRow
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
        .interactiveDismissDisabled()
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            DatePicker(
                "日時",
                selection: $viewModel.recordedAt,
                displayedComponents: [.date, .hourAndMinute]
            )
            TextField("ひとことメモ（任意）", text: $viewModel.memo)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.top, 8)
    }

    private func numpadRow(_ keys: [String]) -> some View {
        HStack(spacing: 4) {
            ForEach(Array(keys.enumerated()), id: \.offset) { _, key in
                numpadKey(key: key)
            }
        }
        .frame(height: keyHeight)
    }

    private var numpadLastRow: some View {
        HStack(spacing: 4) {
            // 空白スロット
            Color.clear.frame(maxWidth: .infinity, maxHeight: keyHeight)
            numpadKey(key: "0").frame(height: keyHeight)
            Color.clear.frame(maxWidth: .infinity, maxHeight: keyHeight)

            // 記録するボタン
            Button {
                viewModel.save(to: item, context: modelContext)
                dismiss()
            } label: {
                Text("記録する")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: keyHeight)
                    .background(viewModel.isValid ? Color.accentColor : Color(.systemGray3))
                    .clipShape(.rect(cornerRadius: 12))
            }
            .disabled(!viewModel.isValid)
        }
    }

    private func numpadKey(key: String) -> some View {
        Button {
            handleKey(key)
        } label: {
            Group {
                if key == "⌫" {
                    Image(systemName: "delete.left")
                        .font(.title2)
                } else if key.isEmpty {
                    Color.clear
                } else {
                    Text(key)
                        .font(.title2.weight(.medium))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(key.isEmpty ? Color.clear : Color(.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 12))
        }
        .disabled(key.isEmpty)
        .frame(maxWidth: .infinity)
    }

    private func handleKey(_ key: String) {
        switch key {
        case "⌫": viewModel.backspace()
        case "00": viewModel.appendDoubleZero()
        case "": break
        default:  viewModel.appendDigit(key)
        }
    }
}
