import SwiftUI

struct NewPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(content: {
                        LabeledContent {
                            TextField("Enter your name", text: $name)
                                .foregroundStyle(Color.foregroundPrimary)
                        } label: {
                            Text("Name")
                                .foregroundStyle(.secondary)
                        }
                    }, header: {
                            Text("Player Information")
                            .foregroundStyle(Color.foregroundPrimary)
                        
                    })
                    .listRowBackground(Color.backgroundSecondary)
                }
                .formStyling()
                
                SBPrimaryButton(action: createPlayer, title: "Create")
                    .disabledStyling(isDisabled: name.isEmpty)
                
                SBSecondaryButton(action: {
                    dismiss()
                }, title: "Dismiss")
                
                /*
                Button(action: {
                    var newPlayer = SBPlayer(id: UUID(), name: "Simon")
                    modelContext.insert(newPlayer)
                    newPlayer = SBPlayer(id: UUID(), name: "Maty")
                   modelContext.insert(newPlayer)
                    newPlayer = SBPlayer(id: UUID(), name: "Sviro")
                   modelContext.insert(newPlayer)
                    newPlayer = SBPlayer(id: UUID(), name: "Mario")
                   modelContext.insert(newPlayer)
                    try? modelContext.save()
                }, label: {
                    Text("create 4 players")
                })
                */
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("New Player")
        }
    }
    
    
    private func createPlayer() {
        let newPlayer = SBPlayer(id: UUID(), name: name)
        modelContext.insert(newPlayer)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NewPlayerView()
}
