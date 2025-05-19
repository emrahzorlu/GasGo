//
//  HomeContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation
import GoogleMaps

protocol HomeView: BaseView {
  func setupUI()
  
  func showMapAt(_ coordinate: CLLocationCoordinate2D)
  func addMapMarker(at coordinate: CLLocationCoordinate2D, title: String?, placeID: String, brand: GasStationBrand)
  
  func showStations(_ stations: [NearbyPlaceEntity])
}

protocol HomePresentation: AnyObject {
  func viewDidLoad()
  
  func notifyCurrentLocation(_ coordinate: CLLocationCoordinate2D)
  func detailButtonTapped(placeID: String)
}

protocol HomeInteractorInput: AnyObject {
  func getStations(at coordinate: CLLocationCoordinate2D)
}

protocol HomeInteractorOutput: AnyObject {
  func gotStations(stations: [NearbyPlaceEntity])
}

protocol HomeWireframe: AnyObject {
  func routeToStationDetail(with placeID: String)
}
