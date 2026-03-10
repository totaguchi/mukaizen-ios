import SwiftUI

struct RecordTypeIcon: View {
    let type: RecordType
    let onTap: () -> Void
    var onLongPress: (() -> Void)? = nil

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 44, height: 44)
                Image(systemName: type.symbolName)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
            }
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in onLongPress?() }
        )
    }
}
