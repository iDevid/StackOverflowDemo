//
//  MockNetworkProvider.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 18/04/26.
//

import NetworkLayer

@testable import StackOverflowDemo

class MockNetworkProvider: NetworkProdiving {
    var mockItems: [StackOverflowUser] = []
    var mockError: Error?
    var mockAwaitTime: Duration?

    func request<E: Endpoint>(_ endpoint: E) async throws -> E.ResponseType {
        if let error = mockError {
            throw error
        }
        if let mockAwaitTime {
            try await Task.sleep(for: mockAwaitTime)
        }
        let response = StackOverflowUsersResponse(items: mockItems)
        return response as! E.ResponseType
    }
}
