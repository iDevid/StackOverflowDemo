//
//  ViewPresenter+UINavigationController.swift
//  NavigationLayer
//
//  Created by Davide Sibilio on 19/04/26.
//

import UIKit

extension UINavigationController: ViewPresenter {

    public func present(
        _ controller: UIViewController,
        option: ViewPresenterOption
    ) {
        switch option {
        case .present(let animated):
            present(controller, animated: animated)
        case .push(let animated):
            pushViewController(controller, animated: animated)
        default:
            assertionFailure("option not allowed")
        }
    }
}
