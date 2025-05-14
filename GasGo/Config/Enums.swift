//
//  Enums.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.04.2025.
//

import Foundation

enum CollectionViewCellIdentifier: String {
  case onboardingCollectionViewCell = "OnboardingCollectionViewCell"
}

enum OnboardingType: CaseIterable {
  case welcome
  case favorites
  case emergency
  
  var title: String {
    switch self {
    case .welcome:
      return "GasGo ile yakıt ihtiyacında sana en yakın ve uygun benzin istasyonunu harita üzerinden bul."
    case .favorites:
      return "Favori istasyonlarını seç. Sana özel yönlendirmeler al."
    case .emergency:
      return "Yakıtın azaldığında panik yok! Acil modla senin için en uygun senaryoyu bulalım."
    }
  }
  
  var animationName: String {
    switch self {
    case .welcome:
      return "Animation1"
    case .favorites:
      return "Animation2"
    case .emergency:
      return "Animation3"
    }
  }
  
  var continueButtonTile: String {
    switch self {
    case .welcome:
      return "Devam"
    case .favorites:
      return "Devam"
    case .emergency:
      return "Tamamdır!"
    }
  }
}
