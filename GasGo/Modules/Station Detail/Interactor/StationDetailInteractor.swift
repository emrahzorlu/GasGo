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
  private var directionsWorker: DirectionsWorker?
  
  var placeId: String?
  
  init(fetcher: StationDetailFetcherProtocol, directionsFetcher: DirectionsFetcherProtocol, placeId: String) {
    self.worker = StationDetailWorker(fetcher: fetcher)
    self.directionsWorker = DirectionsWorker(fetcher: directionsFetcher)
    self.placeId = placeId
  }
}

extension StationDetailInteractor: StationDetailInteractorInput {
  func getDetails() {
    guard let placeId else { return }
    
    let requestModel = PlaceDetailRequestModel(placeID: placeId)
    
    do {
      if let details = try worker?.getDetails(requestModel: requestModel).first {
        guard let origin = LocationManager.shared.currentLocation else { return }
        let destination = "\(details.latitude),\(details.longitude)"
        let originCoord = "\(origin.latitude),\(origin.longitude)"
        
        let directionsRequest = DirectionsRequestModel(origin: originCoord, destination: destination)
        
        let directions = try? directionsWorker?.getDurations(requestModel: directionsRequest)
        print("📍 directions: \(String(describing: directions))")
        
        DispatchQueue.main.async {
          self.output?.gotDetails(with: [details])
          if let directions = directions {
            self.output?.gotDirections(directions)
          }
          print("details: \(details)")
        }
      }
    } catch {
      debugPrint("❌ Detaylar alınamadı: \(error)")
    }
  }
}
