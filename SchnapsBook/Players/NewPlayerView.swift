import SwiftUI

struct NewPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Player Information")) {
                        LabeledContent {
                            TextField("Enter your name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle()) // Optional styling
                        } label: {
                            Text("Name")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Spacer()
                Button(action: createPlayer) {
                    Text("Create")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(name.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(name.isEmpty)
                .padding()
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderless)
                .foregroundColor(.red)
                .padding()
            }
            .navigationTitle("New Player")
        }
    }
    
    
    private func createPlayer() {
        let newPlayer = SBPlayer(id: UUID(), name: name)
        modelContext.insert(newPlayer)
        dismiss()
    }
}

#Preview {
    NewPlayerView()
}
