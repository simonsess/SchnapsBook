import SwiftUI

struct SBPrimaryButton: View {
    var action: () -> Void
    var title: String
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .foregroundColor(Color.foregroundAction)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
        }
        .primaryButtonStyling()
    }
}

struct SBSecondaryButton: View {
    var action: () -> Void
    var title: String
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.foregroundError)
                .font(.title2)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    VStack {
        SBPrimaryButton(action: {}, title: "Primary")
        SBSecondaryButton(action: {}, title: "Secondary")
    }
}
