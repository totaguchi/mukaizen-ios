import SwiftUI

struct TagChip: View {
    let name: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: Tag.symbolName(for: name))
                .font(.caption2)
            Text(name)
                .font(.caption2)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemFill))
        .clipShape(.capsule)
    }
}
