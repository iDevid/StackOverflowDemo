//
//  NetworkProvider.swift
//  NetworkLayer
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation

/// Protocol for making HTTP requests to specific endpoints.
public protocol NetworkProdiving {
    /// Executes a request defined by an Endpoint.
    /// - Parameter endpoint: The endpoint describing the request and response type.
    /// - Returns: The decoded response.
    func request<E: Endpoint>(_ endpoint: E) async throws -> E.ResponseType
}

public class NetworkProvider: NetworkProdiving {

    private let api: NetworkBaseAPI
    private let session: NetworkSession

    /// Initializes the provider with an API configuration and optional URLSession.
    public init(_ api: NetworkBaseAPI, session: NetworkSession = URLSession.shared) {
        self.api = api
        self.session = session
    }

    /// Executes a request defined by an Endpoint.
    /// - Parameter endpoint: The endpoint describing the request and response type.
    /// - Returns: The decoded response.
    /// - Throws: `NetworkError` for HTTP errors, or `DecodingError` if JSON parsing fails.
    public func request<E: Endpoint>(_ endpoint: E) async throws -> E.ResponseType {
        let request = try endpoint.getRequest(withAPI: api)
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        let decoded = try endpoint.decoder.decode(E.ResponseType.self, from: data)
        return decoded
    }

    /// Validates the HTTP response status code.
    /// - Parameter response: The URL response to validate.
    /// - Throws: `NetworkError`
    func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400...499:
            throw NetworkError.clientError(httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.unknownStatusCode(httpResponse.statusCode)
        }
    }
}
