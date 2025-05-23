//
//  FavoritesManager.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//

import Foundation
import CoreData
import UIKit

final class FavoritesManager {
  
  static let shared = FavoritesManager()
  private let context = CoreDataStack.shared.context
  
  private init() {}
  
  func addToFavorites(station: PlaceDetailEntity) {
    let favorite = FavoriteStation(context: context)
    favorite.id = station.id
    favorite.name = station.name
    favorite.adress = station.address

    saveContext()
    print("✅ Added to favorites: \(station.name)")
  }
  
  func removeFromFavorites(placeID: String) {
    let fetchRequest: NSFetchRequest<FavoriteStation> = FavoriteStation.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", placeID)
    
    if let result = try? context.fetch(fetchRequest), let objectToDelete = result.first {
      context.delete(objectToDelete)
      saveContext()
      print("❌ Removed from favorites: \(placeID)")
    }
  }
  
  func isFavorite(placeID: String) -> Bool {
    let fetchRequest: NSFetchRequest<FavoriteStation> = FavoriteStation.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", placeID)
    let count = (try? context.count(for: fetchRequest)) ?? 0
    print("🔍 Is favorite check for \(placeID): \(count > 0)")
    return count > 0
  }
  
  func fetchFavorites() -> [FavoriteStation] {
    let fetchRequest: NSFetchRequest<FavoriteStation> = FavoriteStation.fetchRequest()
    let favorites = (try? context.fetch(fetchRequest)) ?? []
    print("📦 Fetched \(favorites.count) favorites")
    return favorites
  }
  
  private func saveContext() {
    CoreDataStack.shared.saveContext()
  }
}
