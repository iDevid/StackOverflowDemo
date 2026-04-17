//
//  StackOverflowUser.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation

struct StackOverflowUser: Codable {
    let id: Int
    let image: String
    let name: String
    let reputation: Int

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case image = "profile_image"
        case name = "display_name"
        case reputation
    }
}
