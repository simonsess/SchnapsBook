import SwiftUI

struct DisabledStylingModifier: ViewModifier {
    var isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.4 : 1.0)
            .saturation(isDisabled ? 0.4 : 1.0)
    }
}

extension View {
    func disabledStyling(isDisabled: Bool) -> some View {
        self.modifier(DisabledStylingModifier(isDisabled: isDisabled))
    }
}
