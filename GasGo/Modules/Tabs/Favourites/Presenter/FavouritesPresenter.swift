//
//  FavouritesPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import Foundation

final class FavouritesPresenter {
  weak var view: FavouritesView?
  var router: FavouritesWireframe!
  var interactor: FavouritesInteractorInput!
}

extension FavouritesPresenter: FavouritesPresentation {
  func viewDidAppear() {
    interactor.fetchFavourites()
  }
  
  func viewDidLoad() {
    view?.setupUI()
    
    interactor.fetchFavourites()
  }
  
  func removeFromFavourites(placeID: String) {
    interactor.removeFavourite(with: placeID)
  }

  func statinSelected(station: FavouriteStationEntity) {
    router.navigateToStationDetail(from: station)
  }
}

extension FavouritesPresenter: FavouritesInteractorOutput {
  func fetchedFavourites(_ favourites: [FavouriteStationEntity]) {
    view?.showFavourites(favourites)
  }
}
