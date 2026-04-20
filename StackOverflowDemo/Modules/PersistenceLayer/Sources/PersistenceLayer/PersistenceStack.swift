//
//  PersistanceStack.swift
//  PersistanceLayer
//
//  Created by Davide Sibilio on 18/04/26.
//

import CoreData

/// Initializes and owns the Core Data stack.
public final class PersistenceStack {

    static let dbName = "Schema"

    public let container: NSPersistentContainer

    public init() {
        let modelURL = Bundle.module.url(forResource: Self.dbName, withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        container = NSPersistentContainer(name: Self.dbName, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData load failed: \(error)")
            }
        }
    }

    /// Returns a thread-safe repository for querying and managing followed users.
    public var followUserRepository: FollowedUserRepository {
        ConcreteFollowedUserRepository(context: container.viewContext)
    }
}
