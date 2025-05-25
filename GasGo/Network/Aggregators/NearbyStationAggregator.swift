//
//  NearbyStationAggregator.swift
//  GasGo
//
//  Created by Emrah Zorlu on 24.05.2025.
//

import Foundation

final class NearbyStationAggregator {
  static func enrich(stations: [NearbyPlaceEntity], with directions: [NearbyPlaceEntity: DirectionsEntity]) -> [NearbyPlaceEntity] {
    stations.map { station in
      var enriched = station
      if let dir = directions[station] {
        enriched.drivingDistanceInMeters = dir.distanceValue
        enriched.drivingDistanceInMetersText = dir.distanceText
        enriched.drivingDurationInSeconds = dir.durationValue
        enriched.drivingDurationInSecondsText = dir.durationText
      }
      return enriched
    }
  }
}
