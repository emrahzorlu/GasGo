//
//  DirectionsWorker.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//

import Foundation

final class DirectionsWorker {
  private let fetcher: DirectionsFetcherProtocol
  
  init(fetcher: DirectionsFetcherProtocol) {
    self.fetcher = fetcher
  }
  
  func getDurations(requestModel: DirectionsRequestModel) throws -> DirectionsEntity {
    try fetcher.getDirections(model: requestModel)
  }
}
