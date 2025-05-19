//
//  HomeEndpoints.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import Foundation

final class HomeEndpoints: Remote.Endpoint {
  static let shared = HomeEndpoints()
  
  override init() {
    super.init()
    baseRequest.set(url: Config.googleApiUrl)
    baseRequest.set(decoder: MethodDecoder())
  }
  
  func getNearbyStations(model: NearbySearchRequestModel) throws -> GetNearbyStations.Method.Response {
    return try GetNearbyStations.Method(body: model).send(with: baseRequest)
  }
}
