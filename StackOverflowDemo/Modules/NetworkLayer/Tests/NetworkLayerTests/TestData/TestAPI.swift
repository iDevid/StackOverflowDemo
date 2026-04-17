import Foundation
@testable import NetworkLayer

struct TestAPI: API {
    let base: URL = URL(string: "https://api.example.com")!
}
