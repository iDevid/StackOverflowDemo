//
//  Coordinator.swift
//  NavigationLayer
//
//  Created by Davide Sibilio on 19/04/26.
//

import Foundation
import UIKit

/// Handles navigation flow for a section of the app.
@MainActor
public protocol Coordinator: AnyObject {

    /// The route type this coordinator handles
    associatedtype RouteType: Route

    /// Child coordinators managed by this coordinator.
    var childCoordinator: [any Coordinator] { get set }

    /// Initializes the coordinator and presents on given presenter
    func start(on presenter: some ViewPresenter)

    /// Handles navigation to a route.
    /// Called when the app needs to move to a different screen or change state.
    /// - Parameter route: The destination route.
    func navigate(to route: RouteType)
}
