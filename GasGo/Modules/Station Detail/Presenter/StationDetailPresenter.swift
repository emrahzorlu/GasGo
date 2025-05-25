//
//  StationDetailPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//
//

import Foundation
import GoogleMaps

final class StationDetailPresenter {
  weak var view: StationDetailView?
  var router: StationDetailWireframe!
  var interactor: StationDetailInteractorInput!
  private var stationDetails: [PlaceDetailEntity] = []
  private var directions: DirectionsEntity?
}

extension StationDetailPresenter: StationDetailPresentation {
  func viewDidLoad() {
    interactor.getDetails()
    
    view?.setupUI()
  }
  
  func getDirectionsButtonTapped() {
    guard let detail = stationDetails.first else { return }
    
    let coordinate = CLLocationCoordinate2D(latitude: detail.latitude, longitude: detail.longitude)
    LocationManager.shared.openNavigation(to: coordinate, withName: detail.name)
  }
  
  func gotDirections(_ directions: DirectionsEntity?) {
    self.directions = directions
    
    view?.updateDistanceText(directions)
  }
  
  func addCurrentStationToFavorites() {
    guard let station = stationDetails.first else { return }
    
    FavoritesManager.shared.addToFavorites(station: station)
  }

  func removeCurrentStationFromFavorites() {
    guard let station = stationDetails.first else { return }
    
    FavoritesManager.shared.removeFromFavorites(placeID: station.id)
  }

  func checkIfStationIsFavorite(id: String, completion: @escaping (Bool) -> Void) {
    let isFavorite = FavoritesManager.shared.isFavorite(placeID: id)
    
    completion(isFavorite)
  }
  
  func backButtonTapped() {
    router.pop()
  }
}

extension StationDetailPresenter: StationDetailInteractorOutput {
  func gotDetails(with details: [PlaceDetailEntity]) {
    self.stationDetails = details
    
    view?.displayStationDetails(details)
  }
}
