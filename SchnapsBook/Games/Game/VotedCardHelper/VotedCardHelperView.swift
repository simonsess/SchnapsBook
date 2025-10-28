import SwiftUI

struct VotedCardHelperView: View {
    @State var pickedSuite: Suit = .leaves
    @State var pickedValue: SuitValue = .ace
    
    @Binding var card: Card?
    
    var body: some View {
        VStack {
            if let card {
                VStack(spacing: 0) {
                    card.suit.image
                        .resizable()
                        .scaledToFit()
                        .overlay(
                            Text(card.suitValue.title)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.foregroundPrimary),
                            alignment: .bottom
                        )
                    Spacer()
                    SBSecondaryButton(action: {
                        self.card = nil
                    }, title: "reset")
                }
            } else {
                VStack(spacing: 0) {
                    Text("XY to vote")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("Round XY")
                        .font(.subheadline)
                        .padding(.bottom, 10)
                        HStack {
                            Text("Suits")
                                .font(.subheadline)
                                .foregroundStyle(Color.foregroundSecondary)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Picker("Suits", selection: $pickedSuite) {
                                ForEach(Suit.allCases, id: \.self) { suit in
                                    Text(String(describing: suit)).tag(suit)
                                }
                            }
                            .foregroundStyle(Color.foregroundPrimary)
                            .pickerStyle(.menu)
                        }
                        SBSeparator()
                        .padding(.bottom, 15)
                    
                    HStack {
                        Text("Suits")
                            .font(.subheadline)
                            .foregroundStyle(Color.foregroundSecondary)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Picker("Card", selection: $pickedValue) {
                            ForEach(SuitValue.allCases, id: \.self) { suit in
                                Text(String(describing: suit)).tag(suit)
                            }
                        }
                        .foregroundStyle(Color.foregroundPrimary)
                        .pickerStyle(.menu)
                    }
                    SBSeparator()
                        .padding(.bottom, 25)
                    
                    SBPrimaryButton(action: {
                        card = Card(suit: pickedSuite, suitValue: pickedValue)
                    }, title: "Set")
                }
            }
        }
        .frame(height: 380)
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
    //Card(suit: .leaves, suitValue: .X))
    //Binding(get: {nil}, set: {_ in })
    VotedCardHelperView(card: .constant(Card(suit: .leaves, suitValue: .X)))
    
}

#Preview {
    VotedCardHelperView(card: .constant(nil))
}
