//
//  HomeViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import UIKit
import SnapKit
import GoogleMaps

final class HomeViewController: BaseViewController {
  var presenter: HomePresentation!
  
  private var mapManager: GoogleMapsManager?
  private let mapView = GMSMapView()
  private let bottomView = HomeBottomView()
  private var stationList: [NearbyPlaceEntity] = []
  
  private let emergencyButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "light.beacon.max.fill"), for: .normal)
    button.tintColor = .red
    button.backgroundColor = .white
    button.layer.cornerRadius = 28
    button.clipsToBounds = true
    return button
  }()
  
  private let refreshButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
    button.tintColor = .darkGray
    button.backgroundColor = .white
    button.layer.cornerRadius = 28
    button.clipsToBounds = true
    return button
  }()
  
  private let loadingView: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.color = .white
    spinner.hidesWhenStopped = true
    return spinner
  }()
  
  private let mapLoadingPlaceholderView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray5
    return view
  }()
  
  private let mapLoadingLabel: UILabel = {
    let label = UILabel()
    label.text = "Harita yükleniyor..."
    label.textAlignment = .center
    label.textColor = .darkGray
    label.font = Styles.font(family: .outfit, weight: .semiBold, size: 20)
    return label
  }()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
  
  @objc private func emergencyButtonTapped() {
    presenter.emergencyButtonTapped()
  }

  @objc private func refreshButtonTapped() {
    presenter.refreshStations()
  }
}

extension HomeViewController: HomeView {
  func setupUI() {
    view.applyGradient(colors: [Styles.Color.gableGreen, Styles.Color.sanJuanBlue])
    
    mapView.alpha = 0
    view.addSubview(mapView)
    view.addSubview(mapLoadingPlaceholderView)
    mapLoadingPlaceholderView.addSubview(mapLoadingLabel)
    view.addSubview(emergencyButton)
    view.addSubview(refreshButton)
    view.addSubview(bottomView)
    view.addSubview(loadingView)
    
    refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        
    loadingView.startAnimating()
    mapView.isHidden = true
    
    emergencyButton.addTarget(self, action: #selector(emergencyButtonTapped), for: .touchUpInside)
    
    bottomView.isHidden = true
    
    mapManager = GoogleMapsManager(mapView: mapView)
    mapManager?.applyDarkStyle()
    
    mapView.delegate = self
    
    bottomView.didScrollToStation = { [weak self] station in
      let coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
      self?.mapManager?.moveCamera(to: coordinate)
    }
    
    bottomView.directionTapped = { [weak self] station in
      guard self != nil else { return }
      
      let coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
      LocationManager.shared.openNavigation(to: coordinate, withName: station.name)
    }
    
    bottomView.detailTapped = { [weak self] station in
      guard self != nil else { return }
      
      let placeID = station.id
      
      self?.presenter.detailButtonTapped(placeID: placeID)
    }
    
    UIView.animate(withDuration: 0.3) {
      self.mapView.alpha = 1
    }
    
    LocationManager.shared.locationUpdated = { [weak self] coordinate in
      self?.presenter.notifyCurrentLocation(coordinate)
    }
    
    setupConstarints()
  }
  
  func showMapAt(_ coordinate: CLLocationCoordinate2D) {
    mapManager?.moveCamera(to: coordinate)
  }
  
  func addMapMarker(at coordinate: CLLocationCoordinate2D, title: String?, placeID: String, brand: GasStationBrand) {
    let icon = MarkerFactory.buildMarkerIcon(for: brand)
    mapManager?.addMarker(at: coordinate, title: title, icon: icon, placeID: placeID)
    
    print("Marked addet for \(coordinate)")
  }
  
  func setupConstarints() {
    guard let mapView = mapManager?.mapView else { return }
    
    mapView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.trailing.leading.equalToSuperview()
    }
    
    bottomView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
      $0.height.equalTo(200)
    }
    
    emergencyButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
      $0.width.height.equalTo(56)
    }
    
    mapLoadingPlaceholderView.snp.makeConstraints { make in
      make.edges.equalTo(mapView)
    }
    
    mapLoadingLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().inset(24)
    }
    
    loadingView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    refreshButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.bottom.equalTo(emergencyButton.snp.top).offset(-12)
      $0.width.height.equalTo(56)
    }
  }
  
  func showStations(_ stations: [NearbyPlaceEntity]) {
    stationList = stations
    bottomView.updateStations(stations)
  }
  
  func startLoading() {
    loadingView.startAnimating()
    mapView.isHidden = true
    refreshButton.isHidden = true
    emergencyButton.isHidden = true
    mapLoadingPlaceholderView.isHidden = false
  }
  
  func stopLoading() {
    loadingView.stopAnimating()
    mapView.isHidden = false
    refreshButton.isHidden = false
    emergencyButton.isHidden = false
    mapLoadingPlaceholderView.isHidden = true
  }
  
  private func scrollToStation(placeID: String) {
    guard let index = stationList.firstIndex(where: { $0.id == placeID }) else { return }
    
    bottomView.scrollToItem(at: index)
  }
}

extension HomeViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let placeID = marker.userData as? String else { return false }
    
    mapManager?.moveCamera(to: marker.position)
    bottomView.isHidden = false
    scrollToStation(placeID: placeID)
    
    return true
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    bottomView.isHidden = true
  }
}
