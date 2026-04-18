//
//  MockFollowedUserRepository.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 18/04/26.
//

import PersistenceLayer

@testable import StackOverflowDemo

enum MockFollowedUserRepositoryError: Error {
    case standard
}

final class MockFollowedUserRepository: FollowedUserRepository {

    var isFollowedResult = false
    var shouldThrowError = false
    var shouldDelaySetFollowed = false

    private(set) var setFollowedWasCalled = false
    private(set) var lastSetFollowedValue: Bool?

    init() {}

    func isFollowed(userId: Int) async throws -> Bool {
        if shouldThrowError {
            throw MockFollowedUserRepositoryError.standard
        }
        return isFollowedResult
    }

    func setFollowed(_ followed: Bool, userId: Int) async throws {
        if shouldDelaySetFollowed {
            try await Task.sleep(for: .milliseconds(100))
        }
        if shouldThrowError {
            throw MockFollowedUserRepositoryError.standard
        }
        setFollowedWasCalled = true
        lastSetFollowedValue = followed
        isFollowedResult = followed
    }
}
