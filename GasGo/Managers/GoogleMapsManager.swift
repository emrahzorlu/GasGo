//
//  GoogleMapsManager.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import GoogleMaps

final class GoogleMapsManager {
  weak var mapView: GMSMapView?
  
  init(mapView: GMSMapView?) {
    self.mapView = mapView
    
    configureMap()
  }
  
  private func configureMap() {
    print("🛠 configureMap called")
    guard let mapView = mapView else { return }
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
    }
  
  func addMarker(at coordinate: CLLocationCoordinate2D, title: String? = nil, icon: UIImage? = nil, placeID: String? = nil) {
    print("📍 addMarker called at: \(coordinate.latitude), \(coordinate.longitude)")
    guard let mapView else { return }
    
    let marker = GMSMarker(position: coordinate)
    marker.title = title
    marker.icon = icon
    marker.userData = placeID
    marker.map = mapView
  }
  
  func moveCamera(to coordinate: CLLocationCoordinate2D, zoom: Float = 15.0) {
    print("🎥 moveCamera called to: \(coordinate.latitude), \(coordinate.longitude) with zoom: \(zoom)")
    guard let mapView else { return }
    
    let camera = GMSCameraUpdate.setCamera(GMSCameraPosition(target: coordinate, zoom: zoom))
    mapView.animate(with: camera)
  }
  
  func clearMarkers() {
    print("🧹 clearMarkers called")
    mapView?.clear()
  }
  
  func applyDarkStyle(from fileName: String = "dark_map_style") {
    print("🎨 applyDarkStyle called with file: \(fileName)")
    guard let mapView else { return }
    
    if let styleURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
      do {
        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } catch {
        print("❌ Harita teması yüklenemedi: \(error)")
      }
    } else {
      print("❌ JSON dosyası bulunamadı.")
    }
  }
}
