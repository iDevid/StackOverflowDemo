//
//  StackOverflowAPI.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation
import NetworkLayer

struct StackOverflowAPI: API {
    let base: URL = URL(string: "https://api.stackexchange.com/2.2/")!
}
