//
//  ViewPresenter.swift
//  NavigationLayer
//
//  Created by Davide Sibilio on 19/04/26.
//

import UIKit

public protocol ViewPresenter {
    @MainActor
    func present(
        _ controller: UIViewController,
        option: ViewPresenterOption
    )
}
