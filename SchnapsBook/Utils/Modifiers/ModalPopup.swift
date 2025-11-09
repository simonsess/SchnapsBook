import SwiftUI

struct ModalPopupModifier<ContentView: View>: ViewModifier {
    var bodyContent: () -> ContentView
    var dismiss: () -> Void
    var showPopup: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if showPopup {
                SBPopupCard(content: bodyContent, dismiss: dismiss)
            }
        }
    }
}

extension View {
    func modalPopup<ContentView: View>(showPopup: Bool, @ViewBuilder content: @escaping () -> ContentView, dismiss: @escaping () -> Void) -> some View {
        self.modifier(ModalPopupModifier(bodyContent: content, dismiss: dismiss, showPopup: showPopup))
    }
}
