import Foundation

extension Collection {
    func chunked(into size: Int) -> [[Element]] {
        var result: [[Element]] = []
        var current: [Element] = []
        current.reserveCapacity(size)
        for x in self {
            current.append(x)
            if current.count == size {
                result.append(current)
                current.removeAll(keepingCapacity: true)
            }
        }
        if current.isEmpty == false { result.append(current) }
        return result
    }
}
