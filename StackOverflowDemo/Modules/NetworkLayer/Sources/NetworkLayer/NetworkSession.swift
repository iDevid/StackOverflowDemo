//
//  NetworkSession.swift
//  NetworkLayer
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation

public protocol NetworkSession {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
