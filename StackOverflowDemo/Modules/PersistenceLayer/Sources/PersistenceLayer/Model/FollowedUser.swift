//
//  FollowedUser.swift
//  PersistanceLayer
//
//  Created by Davide Sibilio on 18/04/26.
//

import CoreData

@objc(FollowedUser)
public class FollowedUser: NSManagedObject {
    @NSManaged public var id: Int64

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FollowedUser> {
        NSFetchRequest<FollowedUser>(entityName: "FollowedUser")
    }
}
