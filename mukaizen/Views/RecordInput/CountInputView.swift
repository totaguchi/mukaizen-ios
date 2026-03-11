import SwiftUI
import SwiftData

struct CountInputView: View {
    let item: NotToDoItem

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CountInputViewModel()

    var body: some View {
        VStack(spacing: 0) {
            RecordInputHeader(
                title: "回数を記録",
                subtitle: item.title,
                onDismiss: { dismiss() }
            )

            Divider()

            VStack(spacing: 28) {
                // カウント表示 + ステッパー
                HStack(spacing: 40) {
                    StepperButton(systemName: "minus") {
                        withAnimation(.snappy) { viewModel.decrement() }
                    }

                    VStack(spacing: 4) {
                        Text("\(viewModel.count)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .contentTransition(.numericText())
                            .animation(.snappy, value: viewModel.count)
                        Text("回")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .frame(minWidth: 80)

                    StepperButton(systemName: "plus") {
                        withAnimation(.snappy) { viewModel.increment() }
                    }
                }
                .padding(.top, 32)

                // メモ欄（回数タイプは目立つ位置に配置）
                VStack(alignment: .leading, spacing: 6) {
                    Text("メモ")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("ひとことメモ（任意）", text: $viewModel.memo)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
            }

            Spacer()

            Divider()

            // 詳細セクション（日時のみ）
            DisclosureGroup(
                isExpanded: $viewModel.showDetails,
                content: {
                    DatePicker(
                        "日時",
                        selection: $viewModel.recordedAt,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .padding(.top, 8)
                },
                label: {
                    Label("詳細を追加", systemImage: "chevron.down")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider()

            Button {
                viewModel.save(to: item, context: modelContext)
                dismiss()
            } label: {
                Text("記録する")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])
        }
        .interactiveDismissDisabled()
    }
}
