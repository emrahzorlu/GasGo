//
//  FavouritesContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import Foundation

protocol FavouritesView: BaseView {
  func setupUI()
  
  func showFavourites(_ favourites: [FavouriteStationEntity])
}

protocol FavouritesPresentation: AnyObject {
  func viewDidLoad()
  func viewDidAppear()
  
  func removeFromFavourites(placeID: String)
  func statinSelected(station: FavouriteStationEntity)
}

protocol FavouritesInteractorInput: AnyObject {
  func fetchFavourites()
  func removeFavourite(with placeID: String)
}

protocol FavouritesInteractorOutput: AnyObject {
  func fetchedFavourites(_ favourites: [FavouriteStationEntity])
}

protocol FavouritesWireframe: AnyObject {
  func navigateToStationDetail(from station: FavouriteStationEntity)
}
