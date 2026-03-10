import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(systemName: "hand.raised.slash.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.accentColor)
                .padding(.bottom, 32)

            VStack(spacing: 12) {
                Text("無改善")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("「やらないこと」を記録して\n無駄をなくしていこう")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 40)

            VStack(alignment: .leading, spacing: 14) {
                Label("無駄づかいを記録する", systemImage: "checkmark.circle.fill")
                Label("浪費した時間を可視化する", systemImage: "checkmark.circle.fill")
                Label("悪習慣の回数を把握する", systemImage: "checkmark.circle.fill")
            }
            .font(.callout)
            .foregroundStyle(.secondary)

            Spacer()

            Button {
                hasLaunchedBefore = true
                dismiss()
            } label: {
                Text("はじめる")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    OnboardingView()
}
