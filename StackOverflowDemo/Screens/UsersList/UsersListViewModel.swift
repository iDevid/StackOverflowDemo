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

enum LoadState: Equatable {
    case idle
    case loading
    case success
    case error(ErrorPlaceholderViewModel)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError === rhsError
        case (.idle, _), (.loading, _), (.success, _), (.error, _):
            return false
        }
    }
}

typealias UserSnapshot = NSDiffableDataSourceSnapshot<UserListSection, UserCellViewModel>

@Observable
class UsersListViewModel {

    enum Constants {
        static let pageSize: Int = 20
    }

    private let networkProvider: NetworkProdiving
    private let imageLoader: ImageLoading
    private let followUserRepository: FollowedUserRepository

    var currentPage: Int = 1
    var snapshot: UserSnapshot = UserSnapshot()
    var loadState: LoadState = .idle

    init(
        networkProvider: NetworkProdiving,
        imageLoader: ImageLoading,
        followUserRepository: FollowedUserRepository
    ) {
        self.networkProvider = networkProvider
        self.imageLoader = imageLoader
        self.followUserRepository = followUserRepository
        self.snapshot = UserSnapshot()
    }

    func loadData() async throws {
        loadState = .loading
        do {
            try await fetchUsersForCurrentPage()
            loadState = .success
        } catch {
            loadState = .error(.init(
                message: error.localizedDescription,
                buttonTitle: "Try Again",
                onAction: { [weak self] in
                    self?.reloadData()
                }
            ))
            throw error
        }
    }

    private func reloadData() {
        Task { try await loadData() }
    }

    func notifyWillDisplayCell(at indexPath: IndexPath) {
        let viewModel = snapshot.itemIdentifiers[indexPath.row]
        viewModel.loadImageIfNeeded(imageLoader)
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
