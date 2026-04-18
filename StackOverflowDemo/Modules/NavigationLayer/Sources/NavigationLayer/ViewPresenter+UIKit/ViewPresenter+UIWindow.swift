//
//  ViewPresenter+UIWindow.swift
//  NavigationLayer
//
//  Created by Davide Sibilio on 19/04/26.
//

import UIKit

extension UIWindow: ViewPresenter {

    public func present(
        _ controller: UIViewController,
        option: ViewPresenterOption
    ) {
        switch option {
        case .setWindowRoot:
            rootViewController = controller
            makeKeyAndVisible()
        default:
            assertionFailure("option not allowed")
        }
    }
}
