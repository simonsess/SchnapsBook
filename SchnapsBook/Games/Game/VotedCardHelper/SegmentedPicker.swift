import SwiftUI

struct SegmentedPicker <T: Hashable & CaseIterable, Content: View>: View {
    @Binding var selected: T
    @Namespace private var ns
    @State var columnsPerRow: Int
    
    let content: (T) -> Content
    let color: Color
    
    public init(selection: Binding<T>, color: Color, @ViewBuilder content: @escaping (T) -> Content) {
        self._selected = selection
        self.color = color
        self.content = content
        columnsPerRow = T.allCases.count > 4 ? 3 : 4
    }
    
    var body: some View {
        LazyVStack(spacing: 5) {
            ForEach(Array(T.allCases).chunked(into: columnsPerRow), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row, id: \.self) { item in
                        ZStack {
                            Rectangle()
                                .fill(color.opacity(0.2))
                            
                            Rectangle()
                                .fill(color)
                                .cornerRadius(20)
                                .padding(2)
                                .opacity(selected == item ? 1 : 0.01)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring()) {
                                        selected = item
                                    }
                                }
                        }
                        .overlay(
                            content(item)
                                .frame(width: 30, height: 30)
                        )
                        .frame(height: 50)
                    }
                }
                .cornerRadius(20)
            }
        }
    }
}

struct ImageSegmentPicker<T: Hashable & CaseIterable & EnumImageType>: View {
    @Binding var selected: T
    let color: Color
    
    public init(selection: Binding<T>, color: Color = Color.backgroundAction) {
        self._selected = selection
        self.color = color
    }
    
    var body: some View {
        SegmentedPicker(selection: $selected, color: color, content: { item in
            item.image
                .resizable()
                .scaledToFit()
        })
    }
}

struct TextSegmentPicker<T: Hashable & CaseIterable & EnumTitleType>: View {
    @Binding var selected: T
    let color: Color
    
    public init(selection: Binding<T>, color: Color = Color.backgroundAction) {
        self._selected = selection
        self.color = color
    }
    
    var body: some View {
        SegmentedPicker(selection: $selected, color: color, content: { item in
            Text(item.title)
                .font(.title2)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        })
    }
}

#Preview {
    ImageSegmentPicker(selection: .constant(Suit.hearts))
        .padding()
}

#Preview {
    TextSegmentPicker(selection: .constant(SuitValue.king))
        .padding()
}
