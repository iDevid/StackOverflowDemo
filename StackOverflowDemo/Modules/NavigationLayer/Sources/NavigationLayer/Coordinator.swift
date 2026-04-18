//
//  Coordinator.swift
//  NavigationLayer
//
//  Created by Davide Sibilio on 19/04/26.
//

import Foundation
import UIKit

@MainActor
public protocol Coordinator: AnyObject {

    associatedtype RouteType: Route

    var childCoordinator: [any Coordinator] { get set }

    func start(on presenter: some ViewPresenter)
    func navigate(to route: RouteType)
}
