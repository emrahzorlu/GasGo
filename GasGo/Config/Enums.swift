//
//  Enums.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.04.2025.
//

import Foundation
import UIKit

enum CollectionViewCellIdentifier: String {
  case onboardingCollectionViewCell = "OnboardingCollectionViewCell"
}

enum TableViewCellIdentifier: String {
  case settingsTableViewCell = "SettingsTableViewCell"
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

enum SettingsGroup {
  case appFeedback
  case legalInfo
  
  var settingTypes: [SettingsType] {
    switch self {
    case .appFeedback:
      let settingsTypes: [SettingsType] = [.rateUs, .feedback, .share]
      return settingsTypes
    case .legalInfo:
      return [.privacyPolicy, .terms]
    }
  }
}

enum SettingsType {
  case rateUs
  case feedback
  case share
  case privacyPolicy
  case terms
  
  var title: String {
    switch self {
    case .rateUs:
      return "Bizi değerlendir"
    case .feedback:
      return "Geri Dönüş Bırak"
    case .share:
      return "Paylaş"
    case .privacyPolicy:
      return "Gizlikik Sözleşmesi"
    case .terms:
      return "Kullanım Koşulları"
    }
  }
  
  var icon: UIImage? {
    switch self {
    case .rateUs:
      return UIImage(named: "RateUs")?.withTintColor(UIColor(hex: "#F5A623"))
    case .feedback:
      return UIImage(named: "LeaveFeedback")?.withTintColor(UIColor(hex: "#F5A623"))
    case .share:
      return UIImage(named: "Share")?.withTintColor(UIColor(hex: "#F5A623"))
    case .privacyPolicy:
      return UIImage(named: "PrivacyPolicy")?.withTintColor(UIColor(hex: "#F5A623"))
    case .terms:
      return UIImage(named: "TermsOfUse")?.withTintColor(UIColor(hex: "#F5A623"))
    }
  }
}
