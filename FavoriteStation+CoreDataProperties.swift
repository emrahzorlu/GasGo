//
//  FavoriteStation+CoreDataProperties.swift
//
//
//  Created by Emrah Zorlu on 23.05.2025.
//
//

import Foundation
import CoreData


extension FavoriteStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteStation> {
        return NSFetchRequest<FavoriteStation>(entityName: "FavoriteStation")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var adress: String?
}
