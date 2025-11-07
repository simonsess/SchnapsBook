import SwiftUI

struct VotedCardHelperView: View {
    @State var pickedSuite: Suit = .leaves
    @State var pickedValue: SuitValue = .ace
    
    @Binding var card: Card?
    
    var roundNo: Int
    var voter: String
    
    var body: some View {
        VStack {
            if let card {
                VStack(spacing: 0) {
                    card.suit.image
                        .resizable()
                        .scaledToFit()
                        .overlay(
                            Text(card.suitValue.title)
                                .font(.system(size: 50))
                                .fontWeight(.heavy)
                                .foregroundColor(.foregroundPrimary)
                                .offset(y: 15),
                            alignment: .bottom
                        )
                        .padding(.bottom, 10)
                    Spacer()
                    SBSecondaryButton(action: {
                        self.card = nil
                    }, title: "reset")
                }
            } else {
                VStack(spacing: 0) {
                    Text("\(voter) to vote")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("Round \(roundNo)")
                        .font(.subheadline)
                        .padding(.bottom, 10)
                    HStack {
                        Text("Suits")
                            .font(.subheadline)
                            .foregroundStyle(Color.foregroundSecondary)
                        Spacer()
                    }
                    ImageSegmentPicker(selection: $pickedSuite)
                    .padding(.top, 10)
                    
                    SBSeparator()
                        .padding(.bottom, 15)
                    
                    HStack {
                        Text("Card")
                            .font(.subheadline)
                            .foregroundStyle(Color.foregroundSecondary)
                        Spacer()
                    }
                    TextSegmentPicker(selection: $pickedValue)
                        .padding(.top, 10)
                    SBSeparator()
                        .padding(.bottom, 25)
                    
                    SBPrimaryButton(action: {
                        card = Card(suit: pickedSuite, suitValue: pickedValue)
                    }, title: "Set")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThickMaterial)
                .shadow(radius: 20)
        )
        .padding(.horizontal, 40)
    }
}

#Preview {
    VotedCardHelperView(card: .constant(Card(suit: .leaves, suitValue: .ace)), roundNo: 2, voter: "test player")
}

#Preview {
    VotedCardHelperView(card: .constant(nil), roundNo: 2, voter: "test player")
}
