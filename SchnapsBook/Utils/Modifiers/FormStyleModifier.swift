import SwiftUI

struct FormStyleModifier: ViewModifier {
    var bgColor: Color
    
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(bgColor)
            .foregroundStyle(Color.foregroundPrimary)
    }
}

extension Form {
    func formStyling(backgroundColor: Color = Color.backgroundPrimary) -> some View {
        self.modifier(FormStyleModifier(bgColor: backgroundColor))
    }
}

