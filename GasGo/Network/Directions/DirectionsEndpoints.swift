//
//  DirectionsEndpoints.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//

import Foundation

final class DirectionsEndpoints: Remote.Endpoint {
  static let shared = DirectionsEndpoints()
  
  override init() {
    super.init()
    baseRequest.set(url: Config.googleDirectionsApiUrl)
    baseRequest.set(decoder: MethodDecoder())
  }
  
  func getDirections(model: DirectionsRequestModel) throws -> GetDirections.Method.Response {
    return try GetDirections.Method(body: model).send(with: baseRequest)
  }
  
}
