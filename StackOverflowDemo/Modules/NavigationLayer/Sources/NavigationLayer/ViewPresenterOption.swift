//
//  ViewPresenterOption.swift
//  NavigationLayer
//
//  Created by Davide Sibilio on 19/04/26.
//

import Foundation

public enum ViewPresenterOption {
    case setWindowRoot
    case push(animated: Bool)
    case present(animated: Bool)
}
