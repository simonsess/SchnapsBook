import SwiftUI

struct SBPopupCard<Content: View>: View {
    var content: () -> Content
    var dismiss: () -> Void
    
    public init(@ViewBuilder content: @escaping () -> Content, dismiss: @escaping () -> Void = {}) {
        self.content = content
        self.dismiss = dismiss
    }
    
    var body: some View {
        Color.black.opacity(0.4) // dim background
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(.spring()) {
                    dismiss()
                }
            }
        
        content()
        .transition(.scale.combined(with: .opacity))
        .zIndex(1)
    }
}

#Preview {
    SBPopupCard(content: {
        Text("Preview")
    })
}
