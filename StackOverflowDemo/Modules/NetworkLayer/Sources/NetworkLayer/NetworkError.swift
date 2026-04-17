//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Davide Sibilio on 17/04/26.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidResponse
    case clientError(Int)
    case serverError(Int)
    case unknownStatusCode(Int)
}
