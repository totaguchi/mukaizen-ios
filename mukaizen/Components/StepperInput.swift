import SwiftUI

/// Time/Count 入力画面で共用するステッパーボタン
struct StepperButton: View {
    let systemName: String
    let action: () -> Void

    @ScaledMetric private var size = 80.0

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title.weight(.medium))
                .frame(width: size, height: size)
                .background(Color(.secondarySystemBackground))
                .clipShape(.circle)
        }
        .accessibilityLabel(systemName == "plus" ? "増やす" : "減らす")
    }
}
