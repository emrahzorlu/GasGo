//
//  HomeFetcher.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import Foundation
import GoogleMaps

protocol HomeFetcherProtocol {
  func getNearbyStations(model: NearbySearchRequestModel) throws -> [NearbyPlaceEntity]
}

final class HomeFetcher: HomeFetcherProtocol {
  static let shared = HomeFetcher()
  
  func getNearbyStations(model: NearbySearchRequestModel) throws -> [NearbyPlaceEntity] {
    let response = try HomeEndpoints.shared.getNearbyStations(model: model)
    
    var stations = [NearbyPlaceEntity]()
    
    let userLocation = LocationManager.shared.currentLocation

    for item in response.results ?? [] {
      let lat = item.geometry?.location?.lat ?? 0
      let lng = item.geometry?.location?.lng ?? 0
      var distanceText: String? = nil
      
      if let userLocation = userLocation {
        let stationLocation = CLLocation(latitude: lat, longitude: lng)
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let meters = userCLLocation.distance(from: stationLocation)
        distanceText = String(format: "%.1f km", meters / 1000)
      }

      stations.append(NearbyPlaceEntity(id: item.placeID ?? "",
                                        name: item.name,
                                        latitude: lat,
                                        longitude: lng,
                                        address: item.vicinity,
                                        iconURL: nil,
                                        rating: item.rating,
                                        userRatingsTotal: item.userRatingsTotal,
                                        isOpenNow: item.openingHours?.openNow,
                                        distanceText: distanceText))
    }
        
    return stations
  }
}
