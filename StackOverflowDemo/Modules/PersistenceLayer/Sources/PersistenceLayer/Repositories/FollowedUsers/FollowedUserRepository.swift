//
//  FollowedUserRepository.swift
//  PersistenceLayer
//
//  Created by Davide Sibilio on 18/04/26.
//

import Foundation
import CoreData

public protocol FollowedUserRepository: Sendable {
    func isFollowed(userId: Int) async throws -> Bool
    func setFollowed(_ followed: Bool, userId: Int) async throws
}

final actor ConcreteFollowedUserRepository: FollowedUserRepository {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func isFollowed(userId: Int) async throws -> Bool {
        let request = FollowedUser.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", userId)
        let results = try context.fetch(request)
        return !results.isEmpty
    }

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
