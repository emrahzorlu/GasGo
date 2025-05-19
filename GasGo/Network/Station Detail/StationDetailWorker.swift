//
//  StationDetailWorker.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import Foundation

final class StationDetailWorker {
  private let fetcher: StationDetailFetcherProtocol
  
  init(fetcher: StationDetailFetcherProtocol) {
    self.fetcher = fetcher
  }
  
  func getDetails(requestModel: PlaceDetailRequestModel) throws -> [PlaceDetailEntity] {
    try fetcher.getStationDetails(model: requestModel)
  }
}
