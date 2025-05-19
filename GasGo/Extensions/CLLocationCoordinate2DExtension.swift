//
//  CLLocationCoordinate2DExtension.swift
//  GasGo
//
//  Created by Emrah Zorlu on 19.05.2025.
//

import CoreLocation

extension CLLocationCoordinate2D {
  func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
    let from = CLLocation(latitude: self.latitude, longitude: self.longitude)
    let to = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    return from.distance(from: to)
  }
}
