//
//  NetworkProvider.swift
//  NetworkLayer
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation

public protocol NetworkProdiving {
    func request<E: Endpoint>(_ endpoint: E) async throws -> E.ResponseType
}

public class NetworkProvider: NetworkProdiving {

    private let api: API
    private let session: NetworkSession

    public init(_ api: API, session: NetworkSession = URLSession.shared) {
        self.api = api
        self.session = session
    }

    public func request<E: Endpoint>(_ endpoint: E) async throws -> E.ResponseType {
        let request = try endpoint.getRequest(withAPI: api)
        let (data, response) = try await session.data(for: request)
        try validateResponse(response)
        let decoded = try endpoint.decoder.decode(E.ResponseType.self, from: data)
        return decoded
    }

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
