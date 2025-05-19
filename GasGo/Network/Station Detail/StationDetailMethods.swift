//
//  StationDetailMethods.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import Foundation

extension StationDetailEndpoints {
  struct GetStationDetails {
    static let path = "details/json"
    
    struct Method {
      let body: PlaceDetailRequestModel
      
      struct Response: Decodable {
        let result: PlaceDetailItem?
      }
      
      struct PlaceDetailItem: Decodable {
        let placeID: String?
        let name: String?
        let formattedAddress: String?
        let formattedPhoneNumber: String?
        let rating: Double?
        let userRatingsTotal: Int?
        let website: String?
        let openingHours: OpeningHours?
        let geometry: Geometry?
        let types: [String]?
        let photos: [Photo]?
        
        enum CodingKeys: String, CodingKey {
          case placeID = "place_id"
          case name
          case formattedAddress = "formatted_address"
          case formattedPhoneNumber = "formatted_phone_number"
          case rating
          case userRatingsTotal = "user_ratings_total"
          case website
          case openingHours = "opening_hours"
          case geometry
          case types
          case photos
        }
      }
      
      struct OpeningHours: Decodable {
        let openNow: Bool?
        
        enum CodingKeys: String, CodingKey {
          case openNow = "open_now"
        }
      }
      
      struct Geometry: Decodable {
        let location: Location
      }
      
      struct Location: Decodable {
        let lat: Double
        let lng: Double
      }
      
      struct Photo: Decodable {
        let photoReference: String
        
        enum CodingKeys: String, CodingKey {
          case photoReference = "photo_reference"
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
