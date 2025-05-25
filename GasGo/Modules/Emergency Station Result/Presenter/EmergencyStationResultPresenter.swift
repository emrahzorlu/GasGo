//
//  EmergencyStationResultPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//
//

import Foundation
import CoreLocation

enum StationSection {
  case favorite([NearbyPlaceEntity])
  case alternative([NearbyPlaceEntity])
}

final class EmergencyStationResultPresenter {
  weak var view: EmergencyStationResultView?
  var router: EmergencyStationResultWireframe!
  var interactor: EmergencyStationResultInteractorInput!
  
  var stations: [NearbyPlaceEntity] = []
  var value: Double = 0
}

extension EmergencyStationResultPresenter: EmergencyStationResultPresentation {
  func viewDidLoad() {
    view?.setupUI()
    
    buildSections()
  }
  
  private func buildSections() {
    let filteredStations = stations.filter {
      if let distance = $0.drivingDistanceInMeters {
        return distance <= Int(value * 1000)
      }
      return false
    }
        
    guard
      let favoriteRaw = Config.selectedFavoriteBrand?.lowercased(),
      let alt1Raw = Config.selectedAlternativeBrand1?.lowercased(),
      let alt2Raw = Config.selectedAlternativeBrand2?.lowercased()
    else {
      view?.displaySections([])
      return
    }
    
    print(favoriteRaw)
    print(alt1Raw)
    print(alt2Raw)
    
    let favoriteStations = filteredStations.filter {
      $0.name.lowercased().contains(favoriteRaw)
    }
    
    let alternativeStations = filteredStations.filter {
      let name = $0.name.lowercased()
      return name.contains(alt1Raw) || name.contains(alt2Raw)
    }
    
    let sections: [StationSection] = [
      .favorite(favoriteStations),
      .alternative(alternativeStations)
    ]
    
    view?.displaySections(sections)
  }
  
  func didSelectStation(with placeID: String) {
    router.navigateToStationDetail(with: placeID)
  }
}

extension EmergencyStationResultPresenter: EmergencyStationResultInteractorOutput {
  func gotStations(_ stations: [NearbyPlaceEntity]) {
    
  }
}
