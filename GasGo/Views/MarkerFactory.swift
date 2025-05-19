//
//  MarkerFactory.swift
//  GasGo
//
//  Created by Emrah Zorlu on 19.05.2025.
//

import UIKit
import GoogleMaps

final class MarkerFactory {
  static func buildMarkerIcon(for brand: GasStationBrand) -> UIImage? {
    let size = CGSize(width: 60, height: 70)
    
    let container = UIView(frame: CGRect(origin: .zero, size: size))
    
    let background = UIImageView(image: Styles.Image.baseMarker)
    background.frame = container.bounds
    background.contentMode = .scaleAspectFit
    container.addSubview(background)
    
    let logoSize: CGFloat = 28
    let logo = UIImageView(image: brand.logo)
    logo.contentMode = .scaleAspectFit
    logo.frame = CGRect(
      x: (size.width - logoSize) / 2,
      y: (size.height - logoSize) / 2 - 4,
      width: logoSize,
      height: logoSize
    )
    container.addSubview(logo)
    
    return renderViewAsImage(view: container)
  }
  
  private static func renderViewAsImage(view: UIView) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    return renderer.image { ctx in
      view.layer.render(in: ctx.cgContext)
    }
  }
}
