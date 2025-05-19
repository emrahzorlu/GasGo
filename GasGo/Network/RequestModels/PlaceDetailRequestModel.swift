//
//  PlaceDetailRequestModel.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import Foundation

struct PlaceDetailRequestModel: Encodable {
  let placeID: String
  let fields = "name,place_id,geometry,formatted_address,formatted_phone_number,rating,user_ratings_total,opening_hours,website,types,photos"
  let language: String? = nil
  let key = Config.apiKey
  
  enum CodingKeys: String, CodingKey {
    case placeID = "place_id"
    case fields
    case language
    case key
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(placeID, forKey: .placeID)
    try container.encode(fields, forKey: .fields)
    try container.encode(key, forKey: .key)
    try container.encodeIfPresent(language, forKey: .language)
  }
}
