//
//  ViewPresenter.swift
//  NavigationLayer
//
//  Created by Davide Sibilio on 19/04/26.
//

import UIKit

/// Abstracts the presentation mechanism
public protocol ViewPresenter {

    /// Presents a view controller using the specified option.
    /// - Parameter controller: The view controller to present.
    /// - Parameter option: How to present the controller.
    @MainActor
    func present(
        _ controller: UIViewController,
        option: ViewPresenterOption
    )
}
