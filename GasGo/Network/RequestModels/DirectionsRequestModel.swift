//
//  DirectionsRequestModel.swift
//  GasGo
//
//  Created by Emrah Zorlu on 19.05.2025.
//

import Foundation

struct DirectionsRequestModel: Encodable {
  let origin: String
  let destination: String
  let key = Config.apiKey
}
