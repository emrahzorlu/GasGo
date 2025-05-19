//
//  HomeMethods.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import Foundation

extension HomeEndpoints {
  struct GetNearbyStations {
    static let path = "nearbysearch/json"
    
    struct Method {
      let body: NearbySearchRequestModel
      
      struct Response: Decodable {
        let results: [NearbyPlaceResult]?
        let status: String?
      }
      
      struct NearbyPlaceResult: Decodable {
        let businessStatus: String?
        let geometry: Geometry?
        let icon: String?
        let name: String
        let openingHours: OpeningHours?
        let placeID: String?
        let rating: Double?
        let userRatingsTotal: Int?
        let vicinity: String?
        
        enum CodingKeys: String, CodingKey {
          case businessStatus = "business_status"
          case geometry
          case icon
          case name
          case openingHours = "opening_hours"
          case placeID = "place_id"
          case rating
          case userRatingsTotal = "user_ratings_total"
          case vicinity
        }
      }
      
      struct Geometry: Decodable {
        let location: Location?
      }
      
      struct Location: Decodable {
        let lat: Double?
        let lng: Double?
      }
      
      struct OpeningHours: Decodable {
        let openNow: Bool?
        
        enum CodingKeys: String, CodingKey {
          case openNow = "open_now"
        }
      }
      
      func send(with request: Remote.Request) throws -> Response {
        return try Remote.Request(with: request)
          .set(method: .get)
          .set(url: request.url?.appendingPathComponent(path), query: body)
          .send()
      }
    }
  }
}
