import SwiftUI

extension Text {
    @ViewBuilder func cellFontStyle(_ isVoter: Bool) -> some View {
        
        if isVoter {
            self
                .font(.title2)
                .fontWeight(.bold)
        } else {
            self
                .font(.title3)
                .fontWeight(.regular)
        }
    }
}
