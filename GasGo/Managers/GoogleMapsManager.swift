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
    debugPrint("🛠 configureMap called")
    guard let mapView = mapView else { return }
    mapView.isMyLocationEnabled = true
    }
  
  func addMarker(at coordinate: CLLocationCoordinate2D, title: String? = nil, icon: UIImage? = nil, placeID: String? = nil) {
    debugPrint("📍 addMarker called at: \(coordinate.latitude), \(coordinate.longitude)")
    guard let mapView else { return }
    
    let marker = GMSMarker(position: coordinate)
    marker.title = title
    marker.icon = icon
    marker.userData = placeID
    marker.map = mapView
  }
  
  func moveCamera(to coordinate: CLLocationCoordinate2D, keepZoomLevel: Bool = true, zoom: Float = 13.0) {
    debugPrint("🎥 moveCamera called to: \(coordinate.latitude), \(coordinate.longitude) with zoom: \(zoom)")
    guard let mapView else { return }

    let currentZoom = mapView.camera.zoom
    let targetZoom = keepZoomLevel ? currentZoom : zoom
    let camera = GMSCameraUpdate.setCamera(GMSCameraPosition(target: coordinate, zoom: targetZoom))
    mapView.animate(with: camera)
  }
  
  func clearMarkers() {
    debugPrint("🧹 clearMarkers called")
    mapView?.clear()
  }
  
  func applyDarkStyle(from fileName: String = "dark_map_style") {
    debugPrint("🎨 applyDarkStyle called with file: \(fileName)")
    guard let mapView else { return }
    
    if let styleURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
      do {
        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } catch {
        debugPrint("❌ Harita teması yüklenemedi: \(error)")
      }
    } else {
      debugPrint("❌ JSON dosyası bulunamadı.")
    }
  }

  func moveCameraToMyLocation(zoom: Float = 15.0) {
    guard let mapView = mapView, let location = mapView.myLocation else {
      debugPrint("⚠️ Konum bilgisi alınamadı")
      return
    }

    let coordinate = location.coordinate
    debugPrint("🎯 moveCameraToMyLocation called → \(coordinate.latitude), \(coordinate.longitude)")

    let cameraUpdate = GMSCameraUpdate.setCamera(GMSCameraPosition(target: coordinate, zoom: zoom))
    mapView.animate(with: cameraUpdate)
  }
}
