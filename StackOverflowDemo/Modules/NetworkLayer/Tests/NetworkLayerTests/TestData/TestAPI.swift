import Foundation
@testable import NetworkLayer

struct TestAPI: NetworkBaseAPI {
    let base: URL = URL(string: "https://api.example.com")!
}
