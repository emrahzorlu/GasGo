//
//  Config.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.04.2025.
//

import Foundation

class Config {
  static let apiKey = "AIzaSyBPpyFJ9ERU4oOIWO-IgtdybVv2JRsmd14"
  
  static var selectedFavoriteBrand: String? {
    get { UserDefaults.standard.string(forKey: "selectedFavoriteBrand") }
    set { UserDefaults.standard.set(newValue, forKey: "selectedFavoriteBrand") }
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
