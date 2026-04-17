//
//  UsersListViewModel.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import NetworkLayer
import UIKit

@Observable
class UsersListViewModel {
    private let networkProvider: NetworkProvider

    init(_ networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}
