import Foundation
@testable import NetworkLayer

struct MockNetworkSession: NetworkSession {
    var data: Data
    var response: URLResponse

    func data(for: URLRequest) async throws -> (Data, URLResponse) {
        (data, response)
    }
}
