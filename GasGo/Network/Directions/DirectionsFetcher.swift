//
//  DirectionsFetcher.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//

import Foundation

protocol DirectionsFetcherProtocol {
  func getDirections(model: DirectionsRequestModel) throws -> DirectionsEntity
}

final class DirectionsFetcher: DirectionsFetcherProtocol {
  static let shared = DirectionsFetcher()
  
  func getDirections(model: DirectionsRequestModel) throws -> DirectionsEntity {
    let response = try DirectionsEndpoints.shared.getDirections(model: model)
    guard let leg = response.routes.first?.legs.first else {
      throw NSError(domain: "com.gasgo.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No route data found"])
    }
    
    return DirectionsEntity(distanceText: leg.distance.text, durationText: leg.duration.text)
  }
}
