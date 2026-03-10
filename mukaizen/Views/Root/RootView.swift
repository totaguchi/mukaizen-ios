import SwiftUI

struct RootView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("ホーム", systemImage: "house.fill")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("履歴", systemImage: "clock.fill")
            }

            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("ダッシュボード", systemImage: "chart.bar.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("設定", systemImage: "gearshape.fill")
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !hasLaunchedBefore },
            set: { _ in }
        )) {
            OnboardingView()
        }
    }
}

#Preview {
    RootView()
}
