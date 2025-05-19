//
//  HomeWorker.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import Foundation

final class HomeWorker {
  private let fetcher: HomeFetcherProtocol
  
  init(fetcher: HomeFetcherProtocol) {
    self.fetcher = fetcher
  }
  
  func getStations(requestModel: NearbySearchRequestModel) throws -> [NearbyPlaceEntity] {
    try fetcher.getNearbyStations(model: requestModel)
  }
}
