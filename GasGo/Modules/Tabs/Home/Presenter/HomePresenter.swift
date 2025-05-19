//
//  HomePresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import Foundation
import GoogleMaps

final class HomePresenter {
  weak var view: HomeView?
  var router: HomeWireframe!
  var interactor: HomeInteractorInput!
}

extension HomePresenter: HomePresentation {
  func viewDidLoad() {
    view?.setupUI()
  }
  
  func notifyCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
    view?.showMapAt(coordinate)
    
    interactor.getStations(at: coordinate)
  }
  
  func detailButtonTapped(placeID: String) {
    router.routeToStationDetail(with: placeID)
  }
}

extension HomePresenter: HomeInteractorOutput {
  func gotStations(stations: [NearbyPlaceEntity]) {
    let sortedStations = stations.sorted { $0.coordinate.longitude < $1.coordinate.longitude }
    
    sortedStations.forEach {
      let brand = GasStationBrand(matching: $0.name)
      view?.addMapMarker(at: $0.coordinate, title: $0.name, placeID: $0.id, brand: brand)
    }
    
    view?.showStations(sortedStations)
  }
}

