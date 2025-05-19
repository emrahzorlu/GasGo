//
//  StationDetailInteractor.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//  
//

import Foundation

final class StationDetailInteractor: BaseInteractor {
  weak var output: StationDetailInteractorOutput?
  
  private var worker: StationDetailWorker?
  
  var placeId: String?
  
  init(fetcher: StationDetailFetcherProtocol, placeId: String) {
    self.worker = StationDetailWorker(fetcher: fetcher)
    self.placeId = placeId
  }
}

extension StationDetailInteractor: StationDetailInteractorInput {
  func getDetails() {
    guard let placeId else { return }

    let requestModel = PlaceDetailRequestModel(placeID: placeId)
    
    do {
      if let details = try worker?.getDetails(requestModel: requestModel) {
        DispatchQueue.main.async {
          self.output?.gotDetails(with: details)
          print("details: \(details)")
        }
      }
    } catch {
      debugPrint("❌ Detaylar alınamadı: \(error)")
    }
  }
}
