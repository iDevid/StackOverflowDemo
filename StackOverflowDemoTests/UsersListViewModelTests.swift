//
//  UsersListViewModelTests.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 18/04/26.
//

import NetworkLayer
import ImageLoader
import PersistenceLayer
import Testing
import UIKit

@testable import StackOverflowDemo

@Suite final class UsersListViewModelTests {

    private let mockNetworkProvider = MockNetworkProvider()
    private let mockImageLoader = MockImageLoader()
    private let mockFollowRepository = MockFollowedUserRepository()

    private lazy var sut = UsersListViewModel(
        networkProvider: mockNetworkProvider,
        imageLoader: mockImageLoader,
        followUserRepository: mockFollowRepository
    )

    @Test func initialState() {
        #expect(sut.loadState == .idle)
        #expect(sut.currentPage == 1)
        #expect(sut.snapshot.numberOfItems == 0)
    }

    @Test func loadDataSuccessSetsLoadStateToSuccess() async throws {
        let mockUsers = [
            createMockUser(id: 1, name: "User 1"),
            createMockUser(id: 2, name: "User 2"),
        ]
        mockNetworkProvider.mockItems = mockUsers

        #expect(sut.loadState == .idle)

        try await sut.loadData()

        #expect(sut.loadState == .success)
        #expect(sut.snapshot.numberOfItems == 2)
    }

    @Test func loadDataCreatesUserCellViewModels() async throws {
        let mockUsers = [
            createMockUser(id: 1, name: "Alice"),
            createMockUser(id: 2, name: "Bob"),
        ]
        mockNetworkProvider.mockItems = mockUsers

        try await sut.loadData()

        let items = sut.snapshot.itemIdentifiers
        #expect(items.count == 2)
        #expect(items[0].name == "Alice")
        #expect(items[1].name == "Bob")
    }

    @Test func loadDataFailureSetsLoadStateToError() async throws {
        let testError = NSError(
            domain: "Test",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
        mockNetworkProvider.mockError = testError

        await #expect(throws: NSError.self) {
            try await sut.loadData()
        }

        if case .error(let errorViewModel) = sut.loadState {
            #expect(errorViewModel.message == "Network error")
        } else {
            #expect(Bool(false), "Expected loadState to be .error with viewModel")
        }
    }

    @Test func loadDataSetsLoadStateToLoading() async throws {
        let mockUsers = [createMockUser(id: 1, name: "User 1")]
        mockNetworkProvider.mockItems = mockUsers
        mockNetworkProvider.mockAwaitTime = .seconds(1)

        let task = Task { try await sut.loadData() }
        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.loadState == .loading)
        try await task.value
    }

    @Test func notifyWillDisplayCellLoadsImage() async throws {
        let user = createMockUser(id: 1, name: "Test User")
        mockNetworkProvider.mockItems = [user]

        try await sut.loadData()

        let indexPath = IndexPath(row: 0, section: 0)
        sut.notifyWillDisplayCell(at: indexPath)

        try await Task.sleep(for: .milliseconds(100))

        #expect(mockImageLoader.loadImageCallCount == 1)
    }

    private func createMockUser(id: Int, name: String) -> StackOverflowUser {
        StackOverflowUser(
            id: id,
            image: "https://example.com/image.jpg",
            name: name,
            reputation: 1000
        )
    }
}
