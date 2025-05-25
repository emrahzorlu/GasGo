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
  private var stations: [NearbyPlaceEntity] = []
}

extension HomePresenter: HomePresentation {
  func viewDidLoad() {
    view?.setupUI()
    view?.startLoading()
  }
  
  func notifyCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
    view?.showMapAt(coordinate)
    
    interactor.getStations(at: coordinate)
  }
  
  func detailButtonTapped(placeID: String) {
    router.routeToStationDetail(with: placeID)
  }
  
  func emergencyButtonTapped() {
    router.routeToEmergency(with: stations)
  }
  
  
  func refreshStations() {
    view?.startLoading()
    if let location = LocationManager.shared.currentLocation {
      interactor.notifyCurrentLocation(location)
    }
  }
}

extension HomePresenter: HomeInteractorOutput {
  func gotStations(stations: [NearbyPlaceEntity]) {
    let sortedStations = stations.sorted { $0.coordinate.longitude < $1.coordinate.longitude }
    self.stations = sortedStations
    
    sortedStations.forEach {
      let brand = GasStationBrand(matching: $0.name)
      view?.addMapMarker(at: $0.coordinate, title: $0.name, placeID: $0.id, brand: brand)
    }
    
    view?.showStations(sortedStations)
    view?.stopLoading()
  }
}
