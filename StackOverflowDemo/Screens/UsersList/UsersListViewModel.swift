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

enum UsersListState: Equatable {
    case idle
    case loading
    case list(UserSnapshot)
    case error(ErrorPlaceholderViewModel, UserSnapshot?)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.list, .list):
            return true
        case (.error(let lhsError, _), .error(let rhsError, _)):
            return lhsError === rhsError
        case (.idle, _), (.loading, _), (.list, _), (.error, _):
            return false
        }
    }

    var snapshot: UserSnapshot? {
        switch self {
        case .list(let snapshot):
            return snapshot
        case .error(_, let snapshot):
            return snapshot
        default:
            return nil
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

    @ObservationIgnored var currentPage: Int = 1

    var state: UsersListState = .idle

    init(
        networkProvider: NetworkProdiving,
        imageLoader: ImageLoading,
        followUserRepository: FollowedUserRepository
    ) {
        self.networkProvider = networkProvider
        self.imageLoader = imageLoader
        self.followUserRepository = followUserRepository
    }

    func reloadData() {
        guard state != .loading else { return }
        currentPage = 1
        Task { try await loadData(isReloading: true) }
    }

    func notifyViewWillAppear() {
        guard state == .idle else { return }
        Task { try await loadData(isReloading: false) }
    }

    func notifyWillDisplayCell(at indexPath: IndexPath) {
        let viewModel = state.snapshot?.itemIdentifiers[indexPath.row]
        viewModel?.loadImageIfNeeded(imageLoader)
    }

    private func loadData(isReloading: Bool) async throws {
        guard state != .loading else { return }
        let currentSnapshot = isReloading ? UserSnapshot() : state.snapshot
        state = .loading
        do {
            let snapshot = try await loadSnapshot(current: currentSnapshot)
            state = .list(snapshot)
        } catch {
            let erroViewModel = ErrorPlaceholderViewModel(
                message: String(localized: .Localization.usersListErrorTitle(
                    message: error.localizedDescription
                )),
                buttonTitle: String(localized: .Localization.usersListErrorRetry),
                onAction: { [weak self] in
                    self?.reloadData()
                }
            )
            state = .error(
                erroViewModel,
                UserSnapshot()
            )
            throw error
        }
    }

    private func loadSnapshot(current: UserSnapshot?) async throws -> UserSnapshot {
        let viewModels = try await fetchUsersPage(currentPage)
        var snapshot: UserSnapshot = current ?? UserSnapshot()
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(viewModels, toSection: .main)
        return snapshot
    }

    private func fetchUsersPage(_ page: Int) async throws -> [UserCellViewModel] {
        let endpoint = StackOverflowUsersEndpoint(
            request: .init(page: page, pageSize: Constants.pageSize)
        )
        let response = try await networkProvider.request(endpoint)
        let users = response.items
        return users.map {
            UserCellViewModel(user: $0, followUserRepository: followUserRepository)
        }
    }
}
