import SwiftUI

struct SBSeparator: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .padding()
            .opacity(0.2)
    }
}

#Preview {
    SBSeparator()
}
