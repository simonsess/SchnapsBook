import SwiftUI

struct FormTextLabelRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.foregroundSecondary)
            Text(value)
                .foregroundStyle(Color.foregroundPrimary)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    FormTextLabelRow(label: "label", value: "value")
}
