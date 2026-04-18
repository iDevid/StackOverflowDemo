//
//  UsersListViewModel.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 17/04/26.
//

import ImageLoader
import NetworkLayer
import PersistenceLayer
import UIKit

enum UserListSection: Hashable {
    case main
}

typealias UserSnapshot = NSDiffableDataSourceSnapshot<UserListSection, UserCellViewModel>

@Observable
class UsersListViewModel {

    enum Constants {
        static let pageSize: Int = 20
    }

    private let networkProvider: NetworkProvider
    private let imageLoader: ImageLoading
    private let followUserRepository: FollowedUserRepository

    var currentPage: Int = 1
    var snapshot: UserSnapshot = UserSnapshot()

    init(
        networkProvider: NetworkProvider,
        imageLoader: ImageLoading,
        followUserRepository: FollowedUserRepository
    ) {
        self.networkProvider = networkProvider
        self.imageLoader = imageLoader
        self.followUserRepository = followUserRepository
        self.snapshot = UserSnapshot()
    }

    func loadData() async throws {
        try await fetchUsersForCurrentPage()
    }

    func notifyWillDisplayCell(at indexPath: IndexPath) {
        let viewModel = snapshot.itemIdentifiers[indexPath.row]
        viewModel.loadImage(imageLoader)
    }

    private func fetchUsersForCurrentPage() async throws {
        let endpoint = StackOverflowUsersEndpoint(
            request: .init(page: currentPage, pageSize: Constants.pageSize)
        )
        let response = try await networkProvider.request(endpoint)
        let users = response.items
        let viewModels = users.map {
            UserCellViewModel(user: $0, followUserRepository: followUserRepository)
        }
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(viewModels, toSection: .main)
    }
}
