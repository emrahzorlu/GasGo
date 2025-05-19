//
//  UIViewExtension.swift
//  GasGo
//
//  Created by Emrah Zorlu on 14.05.2025.
//

import UIKit

extension UIView {
  func applyGradient(
    colors: [UIColor],
    locations: [NSNumber]? = nil,
    startPoint: CGPoint = .init(x: 0, y: 0),
    endPoint: CGPoint = .init(x: 1, y: 1)
  ) {
    layer.sublayers?
      .filter { $0.name == "gradientBackground" }
      .forEach { $0.removeFromSuperlayer() }
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.name = "gradientBackground"
    gradientLayer.frame = bounds
    gradientLayer.colors = colors.map { $0.cgColor }
    gradientLayer.locations = locations
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    gradientLayer.cornerRadius = layer.cornerRadius 
    
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
