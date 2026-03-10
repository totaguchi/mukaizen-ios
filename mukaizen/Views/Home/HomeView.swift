import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("ホーム")
            .navigationTitle("やらないこと")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
