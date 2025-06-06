//
//  Config.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.04.2025.
//

import Foundation

class Config {
  static let apiKey = "You can use it by entering your own API Key"
  static let googleMapsApiUrl = URL(string: "https://maps.googleapis.com/maps/api/place/")!
  static let googleDirectionsApiUrl = URL(string: "https://maps.googleapis.com/maps/api/directions/")!
  
  static var selectedFavoriteBrand: String? {
    get { UserDefaults.standard.string(forKey: "selectedFavoriteBrand") }
    set {
      UserDefaults.standard.set(newValue, forKey: "selectedFavoriteBrand")
      NotificationCenter.default.post(name: .favoriteBrandChanged, object: nil)
    }
  }
  
  static var selectedAlternativeBrand1: String? {
    get { UserDefaults.standard.string(forKey: "selectedAlternativeBrand1") }
    set { UserDefaults.standard.set(newValue, forKey: "selectedAlternativeBrand1") }
  }
  
  static var selectedAlternativeBrand2: String? {
    get { UserDefaults.standard.string(forKey: "selectedAlternativeBrand2") }
    set { UserDefaults.standard.set(newValue, forKey: "selectedAlternativeBrand2") }
  }

  static var didFinishOnboarding: Bool {
    get { UserDefaults.standard.bool(forKey: "didFinishOnboarding") }
    set { UserDefaults.standard.set(newValue, forKey: "didFinishOnboarding") }
  }
}

extension Notification.Name {
  static let favoriteBrandChanged = Notification.Name("favoriteBrandChanged")
}
