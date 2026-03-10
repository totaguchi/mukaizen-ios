import SwiftUI

struct HistoryView: View {
    var body: some View {
        Text("履歴")
            .navigationTitle("履歴")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
