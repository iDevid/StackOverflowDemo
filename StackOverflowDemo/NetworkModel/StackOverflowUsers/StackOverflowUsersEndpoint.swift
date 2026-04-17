//
//  StackOverflowUsersEndpoint.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation
import NetworkLayer

struct StackOverflowUsersEndpoint: Endpoint {

    let path = "users"
    let method: HTTPMethod = .get
    let requestEncoding: HTTPRequestEncoding = .query
    let request: StackOverflowUsersRequest

    typealias ResponseType = StackOverflowUsersResponse

    init(request: StackOverflowUsersRequest) {
        self.request = request
    }
}
