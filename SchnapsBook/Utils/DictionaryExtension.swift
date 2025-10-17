import Foundation

extension Dictionary where Key == Int, Value == UUID {
    func key(for value: UUID) -> Int? {
        first(where: { $0.value == value })?.key
    }
    
    func contains(value: UUID) -> Bool {
        values.contains(value)
    }
    
    mutating func removeEntry(for value: UUID) {
        guard let key = key(for: value) else {
            return
        }
        removeValue(forKey: key)
    }
    
    mutating func addNewEntry(for key: Int, value: UUID) {
        self[key] = value
    }
}

extension Dictionary where Key == Int {
    mutating func appendLast(_ element: Value) {
        self[self.count] = element
    }
}

extension Array where Element: Identifiable {
    func sorted(byOrder order: [Int: Element.ID]) -> [Element] {
        let lookup = Dictionary(uniqueKeysWithValues: order.map { ($0.value, $0.key) })
        return sorted {
            (lookup[$0.id] ?? Int.max) < (lookup[$1.id] ?? Int.max)
        }
    }
}
