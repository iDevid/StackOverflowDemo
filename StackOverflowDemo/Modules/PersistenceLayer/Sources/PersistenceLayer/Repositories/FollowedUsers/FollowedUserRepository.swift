//
//  FollowedUserRepository.swift
//  PersistenceLayer
//
//  Created by Davide Sibilio on 18/04/26.
//

import Foundation
import CoreData

/// Protocol for managing followed users in persistent storage.
public protocol FollowedUserRepository: Sendable {
    /// Checks if a user is followed.
    /// - Parameter userId: The Stack Overflow user ID.
    /// - Returns: `true` if the user is in the followed list, `false` otherwise.
    func isFollowed(userId: Int) async throws -> Bool

    /// Updates the follow status of a user.
    /// - Parameters:
    ///   - followed: Whether to follow or unfollow.
    ///   - userId: The Stack Overflow user ID.
    func setFollowed(_ followed: Bool, userId: Int) async throws
}

/// Core Data-backed implementation of FollowedUserRepository.
/// Uses an actor to ensure all Core Data operations run serially on a background queue.
final actor ConcreteFollowedUserRepository: FollowedUserRepository {
    private let context: NSManagedObjectContext

    /// Initializes the repository with a managed object context.
    /// - Parameter context: The Core Data context to use for queries and updates.
    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// Checks if a user is currently followed by querying the FollowedUser entity
    /// - Parameter userId: The Stack Overflow user ID
    /// - Returns: `true` if at least one FollowedUser record has this ID
    /// - Throws: CoreData context errors
    public func isFollowed(userId: Int) async throws -> Bool {
        let request = FollowedUser.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", userId)
        let results = try context.fetch(request)
        return !results.isEmpty
    }

    /// Updates the follow status of a user.
    /// - Parameters:
    ///   - followed: Whether to add or remove the follow.
    ///   - userId: The Stack Overflow user ID.
    /// - Throws: CoreData context errors
    public func setFollowed(_ followed: Bool, userId: Int) async throws {
        if followed {
            let isAlreadyFollowed = try await isFollowed(userId: userId)
            guard !isAlreadyFollowed else { return }
            let followedUser = FollowedUser(context: context)
            followedUser.id = Int64(userId)
        } else {
            let request = FollowedUser.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", userId)
            let results = try context.fetch(request)
            for followedUser in results {
                context.delete(followedUser)
            }
        }

        try context.save()
    }
}
