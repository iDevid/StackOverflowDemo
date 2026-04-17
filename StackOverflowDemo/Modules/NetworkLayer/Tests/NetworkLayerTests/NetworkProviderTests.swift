import Testing
@testable import NetworkLayer
import Foundation

@Suite struct NetworkProviderTests {
    
    @Test func successResponse() async throws {
        let json = #"{"id": 1, "name": "Test"}"#
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com/test")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let session = MockNetworkSession(data: json.data(using: .utf8)!, response: response)
        let provider = NetworkProvider(TestAPI(), session: session)
        
        let result = try await provider.request(SimpleTestEndpoint())
        #expect(result.id == 1)
        #expect(result.name == "Test")
    }
    
    @Test func statusCode404() async throws {
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com/test")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let session = MockNetworkSession(data: Data(), response: response)
        let provider = NetworkProvider(TestAPI(), session: session)
        
        await #expect(throws: NetworkError.clientError(404)) {
            try await provider.request(SimpleTestEndpoint())
        }
    }
    
    @Test func statusCode500() async throws {
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com/test")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
        let session = MockNetworkSession(data: Data(), response: response)
        let provider = NetworkProvider(TestAPI(), session: session)
        
        await #expect(throws: NetworkError.serverError(500)) {
            try await provider.request(SimpleTestEndpoint())
        }
    }
    
    @Test func invalidResponse() async throws {
        let response = URLResponse(url: URL(string: "https://api.example.com/test")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let session = MockNetworkSession(data: Data(), response: response)
        let provider = NetworkProvider(TestAPI(), session: session)
        
        await #expect(throws: NetworkError.invalidResponse) {
            try await provider.request(SimpleTestEndpoint())
        }
    }
    
    @Test func decodeFailure() async throws {
        let response = HTTPURLResponse(url: URL(string: "https://api.example.com/test")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let session = MockNetworkSession(data: "invalid json".data(using: .utf8)!, response: response)
        let provider = NetworkProvider(TestAPI(), session: session)
        
        await #expect(throws: Error.self) {
            try await provider.request(SimpleTestEndpoint())
        }
    }
}
