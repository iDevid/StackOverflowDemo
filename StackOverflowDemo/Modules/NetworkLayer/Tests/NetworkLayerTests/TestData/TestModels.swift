import Foundation

struct EmptyRequest: Encodable {}

struct TestResponse: Decodable, Equatable {
    let id: Int
    let name: String
}

struct PostBody: Codable {
    let name: String
}
