//
//  DirectionsMethods.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//

import Foundation

extension DirectionsEndpoints {
  struct GetDirections {
    static let path = "json"
    
    struct Method {
      let body: DirectionsRequestModel
      
      struct Response: Decodable {
        let routes: [RouteItem]
      }
      
      struct RouteItem: Decodable {
        let legs: [Leg]
      }
      
      struct Leg: Decodable {
        let distance: Distance
        let duration: Duration
      }
      
      struct Distance: Decodable {
        let text: String
        let value: Int
      }
      
      struct Duration: Decodable {
        let text: String
        let value: Int
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
