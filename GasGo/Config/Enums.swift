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
  case stationCardCollectionViewCell = "StationCardCollectionViewCell"
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

enum GasStationBrand: String, CaseIterable {
  case shell
  case opet
  case petrolOfisi
  case bp
  case totalEnergies
  case aytemiz
  case milangaz
  case lukoil
  case sunpet
  case kadoil
  case turkiyePetrolleri
  case alpet
  case gulf
  case other
  case moil
  
  var displayName: String {
    switch self {
    case .shell:
      return "Shell"
    case .opet:
      return "Opet"
    case .petrolOfisi:
      return "Petrol Ofisi"
    case .bp:
      return "BP"
    case .totalEnergies:
      return "TotalEnergies"
    case .aytemiz:
      return "Aytemiz"
    case .milangaz:
      return "Milangaz"
    case .lukoil:
      return "Lukoil"
    case .sunpet:
      return "Sunpet"
    case .kadoil:
      return "Kadoil"
    case .turkiyePetrolleri:
      return "Türkiye Petrolleri"
    case .alpet:
      return "Alpet"
    case .gulf:
      return "Gulf"
    case .moil:
      return "Moil"
    case .other:
      return "Diğer"
    }
  }
  
  var logo: UIImage {
    switch self {
    case .shell:
      return Styles.Image.shell
    case .opet:
      return Styles.Image.opet
    case .petrolOfisi:
      return Styles.Image.petrolOfisi
    case .bp:
      return Styles.Image.bp
    case .totalEnergies:
      return Styles.Image.totalEnergies
    case .aytemiz:
      return Styles.Image.aytemiz
    case .milangaz:
      return Styles.Image.milangaz
    case .lukoil:
      return Styles.Image.lukoil
    case .sunpet:
      return Styles.Image.sunpet
    case .kadoil:
      return Styles.Image.kadoil
    case .turkiyePetrolleri:
      return Styles.Image.turkiyePetrolleri
    case .alpet:
      return Styles.Image.alpet
    case .gulf:
      return Styles.Image.gulf
    case .moil:
      return Styles.Image.moil
    case .other:
      return Styles.Image.other
    }
  }
}

extension GasStationBrand {
  init(matching name: String) {
    let lowercasedName = name.lowercased()
    
    if lowercasedName.contains("shell") {
      self = .shell
    } else if lowercasedName.contains("opet") {
      self = .opet
    } else if lowercasedName.contains("petrol ofisi") {
      self = .petrolOfisi
    } else if lowercasedName.contains("bp") {
      self = .bp
    } else if lowercasedName.contains("total") {
      self = .totalEnergies
    } else if lowercasedName.contains("aytemiz") {
      self = .aytemiz
    } else if lowercasedName.contains("milangaz") {
      self = .milangaz
    } else if lowercasedName.contains("lukoil") {
      self = .lukoil
    } else if lowercasedName.contains("sunpet") {
      self = .sunpet
    } else if lowercasedName.contains("kadoil") {
      self = .kadoil
    } else if lowercasedName.contains("türkiye petrolleri") || lowercasedName.contains("tp") {
      self = .turkiyePetrolleri
    } else if lowercasedName.contains("alpet") {
      self = .alpet
    } else if lowercasedName.contains("gulf") {
      self = .gulf
    } else if lowercasedName.contains("moil") {
      self = .moil
    } else {
      self = .other
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
