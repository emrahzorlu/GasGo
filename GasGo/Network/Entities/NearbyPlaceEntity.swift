//
//  NearbyPlaceEntity.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import Foundation
import GoogleMaps

struct NearbyPlaceEntity: Hashable {
  let id: String
  let name: String
  let latitude: Double
  let longitude: Double
  let address: String?
  let iconURL: URL?
  let rating: Double?
  let userRatingsTotal: Int?
  let isOpenNow: Bool?
  let distanceText: String?
  var drivingDistanceInMeters: Int?
  var drivingDurationInSeconds: Int?
  var drivingDistanceInMetersText: String?
  var drivingDurationInSecondsText: String?
  
  var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: NearbyPlaceEntity, rhs: NearbyPlaceEntity) -> Bool {
    return lhs.id == rhs.id
  }
}
