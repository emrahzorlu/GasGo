//
//  HomeInteractor.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import Foundation
import GoogleMaps

final class HomeInteractor: BaseInteractor {
  weak var output: HomeInteractorOutput?
  
  private var worker: HomeWorker?
  
  init(fetcher: HomeFetcherProtocol) {
    self.worker = HomeWorker(fetcher: fetcher)
  }
}

extension HomeInteractor: HomeInteractorInput {
  func getStations(at coordinate: CLLocationCoordinate2D) {
    let requestModel = NearbySearchRequestModel(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      radius: 4000,
      type: nil,
      keyword: "benzin"
    )
    
    do {
      if let stations = try worker?.getStations(requestModel: requestModel) {
        DispatchQueue.main.async {
          self.output?.gotStations(stations: stations)
        }
      }
    } catch {
      debugPrint("❌ İstasyonlar alınamadı: \(error)")
    }
  }
}
