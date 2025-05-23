//
//  StationDetailContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//  
//

import Foundation

protocol StationDetailView: BaseView {
  func setupUI()
  
  func displayStationDetails(_ details: [PlaceDetailEntity])
  func updateDistanceText(_ directions: DirectionsEntity?)
}

protocol StationDetailPresentation: AnyObject {
  func viewDidLoad()
  
  func getDirectionsButtonTapped()
  func addCurrentStationToFavorites()
  func removeCurrentStationFromFavorites()
  func checkIfStationIsFavorite(id: String, completion: @escaping (Bool) -> Void)
}

protocol StationDetailInteractorInput: AnyObject {
  func getDetails()
}

protocol StationDetailInteractorOutput: AnyObject {
  func gotDetails(with details: [PlaceDetailEntity])
  func gotDirections(_ directions: DirectionsEntity?)
}

protocol StationDetailWireframe: AnyObject {
  
}
