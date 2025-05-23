//
//  PlaceDetailEntity.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import Foundation

struct PlaceDetailEntity {
  let id: String
  let name: String
  let address: String?
  let phone: String?
  let rating: Double?
  let totalRatings: Int?
  let isOpenNow: Bool?
  let latitude: Double
  let longitude: Double
  let website: String?
  let photoReferences: [String]?
  let types: [String]?
  let hasNearbyFood: Bool?
  
  var hasSmartCharge: Bool {
    types?.contains("ev_charging_station") ?? false
  }
  var hasMarket: Bool {
//    types?.contains(where: { $0.contains("supermarket") || $0.contains("convenience_store") }) ?? false
    true
  }
  var hasCarWash: Bool {
    types?.contains("car_wash") ?? false
  }
}
