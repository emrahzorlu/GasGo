//
//  StationDetailEndpoints.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import Foundation

final class StationDetailEndpoints: Remote.Endpoint {
  static let shared = StationDetailEndpoints()
  
  override init() {
    super.init()
    baseRequest.set(url: Config.googleApiUrl)
    baseRequest.set(decoder: MethodDecoder())
  }
  
  func getStationDetails(model: PlaceDetailRequestModel) throws -> GetStationDetails.Method.Response {
    return try GetStationDetails.Method(body: model).send(with: baseRequest)
  }
}
