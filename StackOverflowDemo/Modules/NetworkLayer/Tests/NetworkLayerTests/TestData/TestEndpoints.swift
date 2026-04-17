import Foundation
@testable import NetworkLayer

struct SimpleTestEndpoint: Endpoint {
    typealias RequestType = EmptyRequest
    typealias ResponseType = TestResponse

    var path: String { "/test" }
    var method: HTTPMethod { .get }
    var request: EmptyRequest { EmptyRequest() }
    var requestEncoding: HTTPRequestEncoding { .query }
}

struct PostEndpoint: Endpoint {
    typealias RequestType = PostBody
    typealias ResponseType = TestResponse

    let request: PostBody

    init(body: PostBody) {
        self.request = body
    }

    var path: String { "/users" }
    var method: HTTPMethod { .post }
    var requestEncoding: HTTPRequestEncoding { .body }
}

struct CachedEndpoint: Endpoint {
    typealias RequestType = EmptyRequest
    typealias ResponseType = TestResponse

    var path: String { "/test" }
    var method: HTTPMethod { .get }
    var request: EmptyRequest { EmptyRequest() }
    var requestEncoding: HTTPRequestEncoding { .query }
    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringCacheData }
}
