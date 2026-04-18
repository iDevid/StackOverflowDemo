//
//  UserCellViewModelTests.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 18/04/26.
//

import Testing
import UIKit

@testable import StackOverflowDemo

@Suite final class UserCellViewModelTests {

    private let mockFollowRepository = MockFollowedUserRepository()

    @Test func initialFollowStateIsLoading() {
        let sut = getDefaultSut()
        #expect(sut.followState == .loading)
    }

    @Test func followStateBecomesFollowingWhenUserIsFollowed() async throws {
        mockFollowRepository.isFollowedResult = true
        let sut = getDefaultSut()

        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.followState == .following)
    }

    @Test func followStateBecomesNotFollowingWhenUserIsNotFollowed() async throws {
        mockFollowRepository.isFollowedResult = false
        let sut = getDefaultSut()

        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.followState == .notFollowing)
    }

    @Test func toggleFollowFromNotFollowingToFollowing() async throws {
        mockFollowRepository.isFollowedResult = false
        let sut = getDefaultSut()

        try await Task.sleep(for: .milliseconds(100))
        #expect(sut.followState == .notFollowing)

        try await sut.toggleFollow()

        #expect(sut.followState == .following)
        #expect(mockFollowRepository.setFollowedWasCalled)
        #expect(mockFollowRepository.lastSetFollowedValue == true)
    }

    @Test func toggleFollowFromFollowingToNotFollowing() async throws {
        mockFollowRepository.isFollowedResult = true
        let user = createMockUser(id: 1, name: "User 1")
        let sut = UserCellViewModel(user: user, followUserRepository: mockFollowRepository)

        try await Task.sleep(for: .milliseconds(100))
        #expect(sut.followState == .following)

        try await sut.toggleFollow()

        #expect(sut.followState == .notFollowing)
        #expect(mockFollowRepository.setFollowedWasCalled)
        #expect(mockFollowRepository.lastSetFollowedValue == false)
    }

    @Test func toggleFollowSetsStateToLoadingDuringOperation() async throws {
        mockFollowRepository.isFollowedResult = false
        mockFollowRepository.shouldDelaySetFollowed = true
        let sut = getDefaultSut()
        try await Task.sleep(for: .milliseconds(50))
        let toggleTask = Task {
            try await sut.toggleFollow()
        }
        try await Task.sleep(for: .milliseconds(50))
        #expect(sut.followState == .loading)

        try await toggleTask.value
    }

    @Test func toggleFollowRestoresPreviousStateOnError() async throws {
        mockFollowRepository.isFollowedResult = false
        mockFollowRepository.shouldThrowError = true

        let sut = getDefaultSut()

        try await Task.sleep(for: .milliseconds(100))
        let initialState = sut.followState

        await #expect(throws: MockFollowedUserRepositoryError.self) {
            try await sut.toggleFollow()
        }

        #expect(sut.followState == initialState)
    }

    @Test func followStateBecomesErrorOnInitializationFailure() async throws {
        mockFollowRepository.shouldThrowError = true
        let sut = getDefaultSut()

        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.followState == .error)
    }

    private func getDefaultSut() -> UserCellViewModel {
        let user = createMockUser(id: 1, name: "User 1")
        return UserCellViewModel(
            user: user,
            followUserRepository: mockFollowRepository
        )
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

