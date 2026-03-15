import SwiftUI

private struct OnboardingFeature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @Environment(\.dismiss) private var dismiss

    private let features: [OnboardingFeature] = [
        OnboardingFeature(title: "無駄づかいを記録", description: "衝動買いや不要な出費を金額で残す", systemImage: "yensign.circle.fill"),
        OnboardingFeature(title: "浪費時間を可視化", description: "ダラダラSNSや先延ばしを時間で記録", systemImage: "timer"),
        OnboardingFeature(title: "悪習慣の回数を把握", description: "繰り返す行動をカウントして傾向を掴む", systemImage: "arrow.clockwise"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // ヘッダー
            VStack(spacing: 16) {
                Image(systemName: "hand.raised.slash.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.accentColor)
                    .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text("無改善")
                        .font(.largeTitle.bold())

                    Text("「やらないこと」を記録して\n無駄をなくしていこう")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()

            // 機能説明カード
            VStack(spacing: 12) {
                ForEach(features) { feature in
                    OnboardingFeatureRow(
                        title: feature.title,
                        description: feature.description,
                        systemImage: feature.systemImage
                    )
                }
            }
            .padding(.horizontal)

            Spacer()

            // CTA ボタン
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

// MARK: - Feature Row

private struct OnboardingFeatureRow: View {
    let title: String
    let description: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 40)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 12))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title)。\(description)")
    }
}

#Preview {
    OnboardingView()
}
