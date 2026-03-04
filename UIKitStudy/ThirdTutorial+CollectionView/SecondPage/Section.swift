import Foundation

// 1. 여기서 Hashable을 제거하고 Sendable만 남깁니다.
enum Section: Int {
    case header
    case list
}
