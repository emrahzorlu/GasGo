//
//  FavoriteStation+CoreDataProperties.swift
//  
//
//  Created by Emrah Zorlu on 25.05.2025.
//
//

import Foundation
import CoreData


extension FavoriteStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteStation> {
        return NSFetchRequest<FavoriteStation>(entityName: "FavoriteStation")
    }

    @NSManaged public var id: NSObject?
    @NSManaged public var name: NSObject?
    @NSManaged public var address: NSObject?

}
