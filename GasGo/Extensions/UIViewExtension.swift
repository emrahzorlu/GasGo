//
//  UIViewExtension.swift
//  GasGo
//
//  Created by Emrah Zorlu on 14.05.2025.
//

import UIKit

extension UIView {
  func applyGradient(colors: [CGColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.bounds
    gradientLayer.colors = colors
    gradientLayer.locations = locations
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    gradientLayer.name = "gradientBackground"
    
    layer.sublayers?.removeAll(where: { $0.name == "gradientBackground" })
    
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
