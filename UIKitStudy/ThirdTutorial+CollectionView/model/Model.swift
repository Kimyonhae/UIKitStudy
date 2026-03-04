import UIKit


nonisolated enum TestSection: Hashable {
    case first(Item?)
    case second(Item?)
    case third(Item?)
}

nonisolated struct Item: Hashable {
    let id: UUID = UUID()
    let color: UIColor
}
