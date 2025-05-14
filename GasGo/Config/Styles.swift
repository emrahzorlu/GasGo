//
//  Styles.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.04.2025.
//

import Foundation
import UIKit

class Styles {
  enum FontFamily: String {
    case outfit = "Outfit"
  }
  
  enum FontWeight: String {
    case thin = "Thin" // 100
    case light = "Light" // 300
    case regular = "Regular" // 400
    case medium = "Medium" // 500
    case semiBold = "SemiBold" // 600
    case bold = "Bold" // 700
    case extraBold = "ExtraBold" // 800
    case black = "Black" // 900
  }
  
  static func font(family: FontFamily, weight: FontWeight, size: CGFloat) -> UIFont {
    let fontName = "\(family.rawValue)-\(weight.rawValue)"
    guard let customFont = UIFont(name: fontName, size: size) else {
      fatalError("Font \(fontName) is not loaded correctly. Please check Info.plist or font names.")
    }
    return customFont
  }
  
  enum Color {
    static let gradientStart = UIColor(hex: "42D0FF")
    static let gradientEnd = UIColor(hex: "5CE9FF")
    static let background = UIColor(hex: "161616")
    static let tabBackground = UIColor(hex: "202020")
    static let tabTint = UIColor(hex: "42D0FF")
    static let mineShaftBlack = UIColor(hex: "252525")
    static let dodgerBlue = UIColor(hex: "42D0FF")
    static let dodgerdDarkBlue = UIColor(hex: "4271FF")
    static let tundoraGray = UIColor(hex: "434343")
    static let silverChalice = UIColor(hex: "A0A0A0")
    static let wildStrawberryPink = UIColor(hex: "FF4081")
    static let darkBlue = UIColor(hex: "080781")
  }
  
  enum Image {
    static let shell = UIImage(named: "Shell")
    static let opet = UIImage(named: "Opet")
    static let petrolOfisi = UIImage(named: "PetrolOfisi")
    static let bp = UIImage(named: "BP")
    static let totalEnergies = UIImage(named: "TotalEnergies")
    static let aytemiz = UIImage(named: "Aytemiz")
    static let milangaz = UIImage(named: "Milangaz")
    static let lukoil = UIImage(named: "Lukoil")
    static let sunpet = UIImage(named: "Sunpet")
    static let kadoil = UIImage(named: "Kadoil")
    static let turkiyePetrolleri = UIImage(named: "TurkiyePetrolleri")
    static let alpet = UIImage(named: "Alpet")
    static let gulf = UIImage(named: "Gulf")
    static let other = UIImage(named: "Other")
  }
}

extension UIColor {
  convenience init(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let b = CGFloat(rgb & 0x0000FF) / 255.0
    
    self.init(red: r, green: g, blue: b, alpha: 1.0)
  }
}
