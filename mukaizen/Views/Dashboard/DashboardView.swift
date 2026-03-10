import SwiftUI

struct DashboardView: View {
    var body: some View {
        Text("ダッシュボード")
            .navigationTitle("ダッシュボード")
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
