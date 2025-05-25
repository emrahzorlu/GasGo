//
//  FavouritesInteractor.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import Foundation
import CoreData

final class FavouritesInteractor: BaseInteractor {
  weak var output: FavouritesInteractorOutput?
}

extension FavouritesInteractor {
  func removeFavourite(with placeID: String) {
    let context = CoreDataStack.shared.context
    let request: NSFetchRequest<FavoriteStation> = FavoriteStation.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", placeID)
    
    do {
      let results = try context.fetch(request)
      results.forEach { context.delete($0) }
      try context.save()
    } catch {
      print("Failed to delete favorite with id \(placeID): \(error.localizedDescription)")
    }
  }
}

extension FavouritesInteractor: FavouritesInteractorInput {
  func fetchFavourites() {
    let context = CoreDataStack.shared.context
    let request: NSFetchRequest<FavoriteStation> = FavoriteStation.fetchRequest()
    
    do {
      let results = try context.fetch(request)
      let favourites = results.map {
        FavouriteStationEntity(
          id: $0.id ?? "",
          name: $0.name ?? "",
          address: $0.address
        )
      }
      output?.fetchedFavourites(favourites)
    } catch {
      print("Failed to fetch favorites: \(error.localizedDescription)")
      output?.fetchedFavourites([])
    }
  }
}
