import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
        }
        .backgroundStyle(.backgroundPrimary)
        .background(ignoresSafeAreaEdges: .all)
    }
}

#Preview {
    SettingsView()
}
