//
//  NearbyPlaceEntity.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import Foundation
import GoogleMaps

struct NearbyPlaceEntity {
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
  
  var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
