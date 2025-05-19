//
//  NearbySearchRequestModel.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import Foundation
import GoogleMaps

struct NearbySearchRequestModel: Encodable {
  let latitude: Double
  let longitude: Double
  let radius: Int
  let type: String?
  let keyword: String?
  let key = Config.apiKey
  
  enum CodingKeys: String, CodingKey {
    case location
    case radius
    case type
    case keyword
    case key
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode("\(latitude),\(longitude)", forKey: .location)
    try container.encode(radius, forKey: .radius)
    try container.encode(key, forKey: .key)
    try container.encodeIfPresent(type, forKey: .type)
    try container.encodeIfPresent(keyword, forKey: .keyword)
  }
}
