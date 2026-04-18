//
//  AppCoordinator.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 19/04/26.
//

import ImageLoader
import NavigationLayer
import NetworkLayer
import PersistenceLayer
import UIKit

@MainActor
class AppCoordinator: Coordinator {

    var childCoordinator: [any Coordinator] = []
    var rootViewController: UIViewController?

    func start(on presenter: some ViewPresenter) {
        let persistenceStack = PersistenceStack()
        let followUserRepository = persistenceStack.followUserRepository
        let provider = NetworkProvider(StackOverflowAPI())
        let imageLoader = ImageLoader()

        let viewModel = UsersListViewModel(
            networkProvider: provider,
            imageLoader: imageLoader,
            followUserRepository: followUserRepository
        )
        let navigationController = UINavigationController(
            rootViewController: UsersListViewController(viewModel: viewModel)
        )
        navigationController.navigationBar.prefersLargeTitles = true
        presenter.present(navigationController, option: .setWindowRoot)
    }

    func navigate(to route: AppRoute) {
        assertionFailure("not implemented")
    }
}

enum AppRoute: Route {}
