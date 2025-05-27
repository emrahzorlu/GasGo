
//
//  HomePresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import Foundation
import GoogleMaps
import Network

final class HomePresenter {
  weak var view: HomeView?
  var router: HomeWireframe!
  var interactor: HomeInteractorInput!
  private var stations: [NearbyPlaceEntity] = []
  
  
  private func stationsChanged(from old: [NearbyPlaceEntity], to new: [NearbyPlaceEntity]) -> Bool {
    let oldIDs = old.map { $0.id }
    let newIDs = new.map { $0.id }
    return oldIDs != newIDs
  }
}

extension HomePresenter: HomePresentation {
  func viewDidLoad() {
    view?.setupUI()
    view?.startLoading()
  }
  
  func viewWillAppear() {
    if stations.isEmpty, let location = LocationManager.shared.currentLocation {
      notifyCurrentLocation(location)
    }
  }
  
  func notifyCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
    if stations.isEmpty {
      view?.showMapAt(coordinate)
    }
    
    interactor.getStations(at: coordinate)
  }
  
  func detailButtonTapped(placeID: String) {
    router.routeToStationDetail(with: placeID)
  }
  
  func emergencyButtonTapped() {
    router.routeToEmergency(with: stations)
  }
  
  
  func refreshStations() {
    if let location = LocationManager.shared.currentLocation {
      interactor.notifyCurrentLocation(location)
    }
  }
  
  func isInternetAvailable() -> Bool {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetCheck")
    var isConnected = true

    monitor.pathUpdateHandler = { path in
      isConnected = path.status == .satisfied
      monitor.cancel()
    }

    monitor.start(queue: queue)
    Thread.sleep(forTimeInterval: 0.1)
    return isConnected
  }
}

extension HomePresenter: HomeInteractorOutput {
  func gotStations(stations: [NearbyPlaceEntity]) {
    let sortedStations = stations.sorted { $0.coordinate.longitude < $1.coordinate.longitude }
    let hasChanged = stationsChanged(from: self.stations, to: sortedStations)
    if hasChanged {
      view?.startLoading()
    }
    sortedStations.forEach {
      let brand = GasStationBrand(matching: $0.name)
      debugPrint("GasStationBrand: \(brand)")
      view?.addMapMarker(at: $0.coordinate, title: $0.name, placeID: $0.id, brand: brand)
    }
    view?.showStations(sortedStations)
    if hasChanged {
      view?.stopLoading()
    }
    self.stations = sortedStations
  }
}
