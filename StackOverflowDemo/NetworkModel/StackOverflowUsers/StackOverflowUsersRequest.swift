//
//  StackOverflowUsersRequest.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation
import NetworkLayer

struct StackOverflowUsersRequest: Codable {

    enum Order: String, Codable {
        case asc
        case desc
    }

    enum Sort: String, Codable {
        case reputation
    }

    enum Site: String, Codable {
        case stackoverflow
    }

    let page: Int
    let pageSize: Int
    let order: Order
    let sort: Sort
    let site: Site

    enum CodingKeys: String, CodingKey {
        case page
        case pageSize = "pagesize"
        case order
        case sort
        case site
    }

    init(
        page: Int,
        pageSize: Int,
        order: Order = .desc,
        sort: Sort = .reputation,
        site: Site = .stackoverflow
    ) {
        self.page = page
        self.pageSize = pageSize
        self.order = order
        self.sort = sort
        self.site = site
    }
}
