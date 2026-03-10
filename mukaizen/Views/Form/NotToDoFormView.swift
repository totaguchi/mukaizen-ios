import SwiftUI
import SwiftData

struct NotToDoFormView: View {
    let item: NotToDoItem?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = NotToDoFormViewModel()

    private var isEditing: Bool { item != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("やらないこと") {
                    TextField(
                        "例：コンビニで余計な買い物をする",
                        text: $viewModel.title
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                }

                Section("記録の種類") {
                    Picker("記録の種類", selection: $viewModel.recordType) {
                        ForEach(RecordType.allCases, id: \.self) { type in
                            Text(type.label).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("カテゴリ") {
                    TagSelectionGrid(selectedTags: $viewModel.selectedTags)
                }

                Section("説明（任意）") {
                    TextField(
                        "メモ",
                        text: $viewModel.itemDescription,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }
            }
            .navigationTitle(isEditing ? "編集" : "やらないことを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        viewModel.save(editing: item, context: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .onAppear {
                if let item { viewModel.setup(from: item) }
            }
        }
    }
}

// タグ選択グリッド - 別 struct に切り出してパフォーマンスを確保
private struct TagSelectionGrid: View {
    @Binding var selectedTags: Set<String>

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Tag.defaults, id: \.name) { tag in
                TagToggleButton(
                    tag: tag,
                    isSelected: selectedTags.contains(tag.name)
                ) {
                    if selectedTags.contains(tag.name) {
                        selectedTags.remove(tag.name)
                    } else {
                        selectedTags.insert(tag.name)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private struct TagToggleButton: View {
    let tag: Tag
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 6) {
                Image(systemName: tag.symbolName)
                    .font(.subheadline)
                Text(tag.name)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(.systemFill))
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .clipShape(.rect(cornerRadius: 10))
            .animation(.easeInOut, value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
