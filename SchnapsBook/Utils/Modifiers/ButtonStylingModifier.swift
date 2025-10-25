import SwiftUI

struct ButtonStylingModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.backgroundAction)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
            .padding()
            .buttonStyle(.bordered)
    }
}

extension View {
    func primaryButtonStyling() -> some View {
        self.modifier(ButtonStylingModifier())
    }
}
