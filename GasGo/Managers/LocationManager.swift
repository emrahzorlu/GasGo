//
//  LocationManager.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import CoreLocation
import UIKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()
  
  private let locationManager = CLLocationManager()
  private(set) var currentLocation: CLLocationCoordinate2D?
  var locationUpdated: ((CLLocationCoordinate2D) -> Void)?
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.last?.coordinate else { return }
    self.currentLocation = coordinate
    
    if let handler = locationUpdated {
      locationUpdated = nil
      handler(coordinate)
    }
    
    locationManager.stopUpdatingLocation()
  }
  
  func distanceFromCurrentLocation(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance? {
    guard let current = currentLocation else { return nil }
    let fromLocation = CLLocation(latitude: current.latitude, longitude: current.longitude)
    let toLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    return fromLocation.distance(from: toLocation)
  }
  
  func openNavigation(to destination: CLLocationCoordinate2D, withName name: String? = nil) {
    let coordinate = "\(destination.latitude),\(destination.longitude)"
    let encodedName = name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Destination"
    let urlString = "http://maps.apple.com/?daddr=\(coordinate)&q=\(encodedName)&dirflg=d"
    
    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}
