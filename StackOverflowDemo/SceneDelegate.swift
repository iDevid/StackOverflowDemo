//
//  SceneDelegate.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import ImageLoader
import NetworkLayer
import PersistenceLayer
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var persistenceStack: PersistenceStack?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let persistenceStack = PersistenceStack()
        let followUserRepository = persistenceStack.followUserRepository
        self.persistenceStack = persistenceStack
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
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

