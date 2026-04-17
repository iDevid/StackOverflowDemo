//
//  Endpoint.swift
//  NetworkLayer
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation

public protocol Endpoint: URLRequestTransformable {

    associatedtype RequestType: Encodable
    associatedtype ResponseType: Decodable

    var path: String { get }
    var method: HTTPMethod { get }
    var request: RequestType { get }
    var requestEncoding: HTTPRequestEncoding { get }
    var decoder: JSONDecoder { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

public extension Endpoint {
    var decoder: JSONDecoder { .init() }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
}
