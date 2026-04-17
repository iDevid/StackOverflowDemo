//
//  URLRequestTransformable.swift
//  NetworkLayer
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation

public protocol URLRequestTransformable {
    func getRequest(withAPI api: API) throws -> URLRequest
}

public enum URLRequestTransformableError: Error {
    case baseURLNotValid
    case resultURLNotValid
}

public extension Endpoint {
    func getRequest(withAPI api: API) throws -> URLRequest {
        let url = try getURL(withAPI: api)
        var request = URLRequest(url: url, cachePolicy: self.cachePolicy)
        request.httpMethod = self.method.rawValue
        if case .body = self.requestEncoding {
            request.httpBody = try JSONEncoder().encode(self.request)
        }
        return request
    }

    func getURL(withAPI api: API) throws -> URL {
        guard var components = URLComponents(url: api.base, resolvingAgainstBaseURL: true) else {
            throw URLRequestTransformableError.baseURLNotValid
        }
        if case .query = self.requestEncoding {
            components.queryItems = self.request.queryItems
        }
        components.path = self.path

        guard let url = components.url else {
            throw URLRequestTransformableError.resultURLNotValid
        }
        return url
    }
}

fileprivate extension Encodable {
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dictionary ?? [:]
    }

    var queryItems: [URLQueryItem] {
        dictionary.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
    }
}
