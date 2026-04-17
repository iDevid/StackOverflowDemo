import Testing
@testable import NetworkLayer
import Foundation

@Suite struct URLRequestTransformableTests {

    @Test func requestURLConstruction() throws {
        let endpoint = SimpleTestEndpoint()
        let api = TestAPI()
        let request = try endpoint.getRequest(withAPI: api)

        #expect(request.url?.path == "/test")
        #expect(request.httpMethod == "GET")
    }

    @Test func postRequestWithBody() throws {
        let endpoint = PostEndpoint(body: .init(name: "John"))
        let api = TestAPI()
        let request = try endpoint.getRequest(withAPI: api)

        #expect(request.httpMethod == "POST")
        #expect(request.httpBody != nil)

        let decoded = try JSONDecoder().decode(PostBody.self, from: request.httpBody!)
        #expect(decoded.name == "John")
    }

    @Test func cachePolicy() throws {
        let endpoint = CachedEndpoint()
        let request = try endpoint.getRequest(withAPI: TestAPI())

        #expect(request.cachePolicy == .reloadIgnoringCacheData)
    }
}
