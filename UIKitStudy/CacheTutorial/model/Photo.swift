import Foundation

struct Photo: Codable {
    let id: UUID = UUID()
    let content: String
    let nickname: String
    let profileImage: [URL]
}
