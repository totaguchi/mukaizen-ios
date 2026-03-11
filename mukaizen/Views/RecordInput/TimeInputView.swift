import SwiftUI
import SwiftData

struct TimeInputView: View {
    let item: NotToDoItem

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = TimeInputViewModel()

    private let presetRow1 = Array(TimeInputViewModel.presets.prefix(3))
    private let presetRow2 = Array(TimeInputViewModel.presets.dropFirst(3))

    var body: some View {
        VStack(spacing: 0) {
            RecordInputHeader(
                title: "時間を記録",
                subtitle: item.title,
                onDismiss: { dismiss() }
            )

            Divider()

            ScrollView {
                VStack(spacing: 28) {
                    // 時間表示
                    Text("\(viewModel.minutes) 分")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                        .animation(.snappy, value: viewModel.minutes)
                        .padding(.top, 24)

                    // ステッパーボタン
                    HStack(spacing: 64) {
                        StepperButton(systemName: "minus") {
                            withAnimation(.snappy) { viewModel.decrement() }
                        }
                        StepperButton(systemName: "plus") {
                            withAnimation(.snappy) { viewModel.increment() }
                        }
                    }

                    // クイック入力
                    VStack(alignment: .leading, spacing: 10) {
                        Text("クイック入力")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        presetRowView(presetRow1)
                        presetRowView(presetRow2)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)
            }

            Divider()

            // 詳細セクション
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
            .disabled(!viewModel.isValid)
            .padding([.horizontal, .bottom])
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

    private func presetRowView(_ presets: [Int]) -> some View {
        HStack(spacing: 8) {
            ForEach(presets, id: \.self) { minutes in
                Button {
                    withAnimation(.snappy) { viewModel.setPreset(minutes) }
                } label: {
                    Text("\(minutes)分")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.minutes == minutes
                                ? Color.accentColor
                                : Color(.secondarySystemBackground)
                        )
                        .foregroundStyle(
                            viewModel.minutes == minutes ? Color.white : Color.primary
                        )
                        .clipShape(.rect(cornerRadius: 10))
                        .animation(.easeInOut, value: viewModel.minutes)
                }
            }
        }
    }
}

// ステッパーボタン（TimeInputView / CountInputView で共用）
struct StepperButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title.weight(.medium))
                .frame(width: 80, height: 80)
                .background(Color(.secondarySystemBackground))
                .clipShape(.circle)
        }
    }
}
