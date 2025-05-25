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
  private var directionsWorker: DirectionsWorker?
  
  init(fetcher: HomeFetcherProtocol, directionsFetcher: DirectionsFetcherProtocol) {
    self.worker = HomeWorker(fetcher: fetcher)
    self.directionsWorker = DirectionsWorker(fetcher: directionsFetcher)
  }
}

extension HomeInteractor: HomeInteractorInput {
  func getStations(at coordinate: CLLocationCoordinate2D) {
    let requestModel = NearbySearchRequestModel(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      radius: 5000,
      type: nil,
      keyword: "benzin"
    )
    
    do {
      if let stations = try worker?.getStations(requestModel: requestModel) {
        
        var results: [NearbyPlaceEntity: DirectionsEntity] = [:]
        let group = DispatchGroup()
        
        for station in stations {
          guard let origin = LocationManager.shared.currentLocation else { continue }
          let destination = "\(station.latitude),\(station.longitude)"
          let originCoord = "\(origin.latitude),\(origin.longitude)"
          
          let requestModel = DirectionsRequestModel(origin: originCoord, destination: destination)
          
          group.enter()
          DispatchQueue.global().async {
            do {
              if let directions = try self.directionsWorker?.getDurations(requestModel: requestModel) {
                DispatchQueue.main.async {
                  results[station] = directions
                  debugPrint("🟢 \(station.name) - \(directions.distanceText)")
                }
              }
            } catch {
              debugPrint("❌ Directions alınamadı: \(error)")
            }
            group.leave()
          }
        }
        
        group.notify(queue: .main) {
          debugPrint("✅ Tüm Directions verileri alındı.")
          let enriched = NearbyStationAggregator.enrich(stations: stations, with: results)
          self.output?.gotStations(stations: enriched)
        }
      }
    } catch {
      debugPrint("❌ İstasyonlar alınamadı: \(error)")
    }
  }
  
  func notifyCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
    getStations(at: coordinate)
  }
}
