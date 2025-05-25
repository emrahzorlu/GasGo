//
//  StationDetailFetcher.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import Foundation

protocol StationDetailFetcherProtocol {
  func getStationDetails(model: PlaceDetailRequestModel) throws -> [PlaceDetailEntity]
  
  func hasNearbyRestaurants(lat: Double, lng: Double, radius: Int) throws -> Bool
}

final class StationDetailFetcher: StationDetailFetcherProtocol {
  static let shared = StationDetailFetcher()
  
  func getStationDetails(model: PlaceDetailRequestModel) throws -> [PlaceDetailEntity] {
    let response = try StationDetailEndpoints.shared.getStationDetails(model: model)
    
    var details = [PlaceDetailEntity]()
    
    if let item = response.result {
      let hasFood = try hasNearbyRestaurants(
        lat: item.geometry?.location.lat ?? 0,
        lng: item.geometry?.location.lng ?? 0
      )
      
      details.append(PlaceDetailEntity(id: item.placeID ?? "",
                                       name: item.name ?? "",
                                       address: item.formattedAddress,
                                       phone: item.formattedPhoneNumber,
                                       rating: item.rating,
                                       totalRatings: item.userRatingsTotal,
                                       isOpenNow: item.openingHours?.openNow,
                                       latitude: item.geometry?.location.lat ?? 0,
                                       longitude: item.geometry?.location.lng ?? 0,
                                       website: item.website,
                                       photoReferences: item.photos?.map(\.photoReference) ?? [],
                                       types: item.types,
                                       hasNearbyFood: hasFood))
    }
    return details
  }
  
  func hasNearbyRestaurants(lat: Double, lng: Double, radius: Int = 500) throws -> Bool {
    let model = NearbySearchRequestModel(
      latitude: lat,
      longitude: lng,
      radius: Double(radius),
      type: "restaurant",
      keyword: nil
    )
    let response = try  HomeEndpoints.shared.getNearbyStations(model: model)
    return !(response.results?.isEmpty ?? true)
  }
}
