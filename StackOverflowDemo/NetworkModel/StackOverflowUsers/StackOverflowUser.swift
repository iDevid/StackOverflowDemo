import Foundation

struct StackOverflowUser: Codable {
    let id: Int
    let image: String
    @HTMLDecoded var name: String
    let reputation: Int

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case image = "profile_image"
        case name = "display_name"
        case reputation
    }
}
