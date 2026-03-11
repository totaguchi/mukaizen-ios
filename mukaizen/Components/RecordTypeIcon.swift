import SwiftUI

struct RecordTypeIcon: View {
    let type: RecordType
    let onTap: () -> Void
    var onLongPress: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 44, height: 44)
            Image(systemName: type.symbolName)
                .font(.system(size: 18))
                .foregroundStyle(.white)
        }
        .contentShape(Circle())
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture(minimumDuration: 0.5, pressing: { _ in }, perform: {
            onLongPress?()
        })
    }
}
