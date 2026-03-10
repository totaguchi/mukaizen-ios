import SwiftUI

struct SettingsView: View {
    var body: some View {
        Text("設定")
            .navigationTitle("設定")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
