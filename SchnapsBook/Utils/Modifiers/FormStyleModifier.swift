import SwiftUI

struct FormStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(.backgroundPrimary)
            .foregroundStyle(Color.foregroundPrimary)
    }
}

extension Form {
    func formStyling() -> some View {
        self.modifier(FormStyleModifier())
    }
}

