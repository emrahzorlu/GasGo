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
import CoreLocation
import Network

final class HomeViewController: BaseViewController {
  var presenter: HomePresentation!
  
  private var mapManager: GoogleMapsManager?
  private let mapView = GMSMapView()
  private let bottomView = HomeBottomView()
  private var stationList: [NearbyPlaceEntity] = []
  private let locationManager = CLLocationManager()
  
  private let emergencyButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("🚨", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
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
    label.textAlignment = .center
    label.textColor = .darkGray
    label.font = Styles.font(family: .outfit, weight: .semiBold, size: 20)
    return label
  }()
  
  private let locationWarningLabel: UILabel = {
    let label = UILabel()
    label.text = "📍 Konum izni verilmedi. En yakın istasyonları görebilmek için Ayarlar'dan izin vermelisin."
    label.textColor = .darkGray
    label.font = Styles.font(family: .outfit, weight: .regular, size: 16)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.isHidden = true
    return label
  }()
  
  private let openSettingsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Ayarları Aç", for: .normal)
    button.titleLabel?.font = Styles.font(family: .outfit, weight: .medium, size: 16)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = Styles.Color.buttercupYellow
    button.layer.cornerRadius = 8
    button.isHidden = true
    return button
  }()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
  
  @objc private func emergencyButtonTapped() {
    generateSelectionFeedback()
    
    presenter.emergencyButtonTapped()
  }

  @objc private func refreshButtonTapped() {
    generateSelectionFeedback()
    
    presenter.refreshStations()
  }

  
  @objc private func openSettingsTapped() {
    generateSelectionFeedback()
    
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url)
    }
  }
  
  private func checkLocationPermissionStatus() {
    let status = locationManager.authorizationStatus
    let isDenied = status == .denied || status == .restricted
    
    if isDenied {
      loadingView.stopAnimating()
      
      tabBarController?.tabBar.isUserInteractionEnabled = false
      locationWarningLabel.isHidden = false
      openSettingsButton.isHidden = false
      refreshButton.isHidden = true
      emergencyButton.isHidden = true
      mapView.isHidden = true
      mapLoadingLabel.text = isDenied ? "Harita Yüklenemiyor..." : "Harita yükleniyor..."
    }
    
    else {
      tabBarController?.tabBar.isUserInteractionEnabled = true

      locationWarningLabel.isHidden = true
      openSettingsButton.isHidden = true
    }
  }
}

extension HomeViewController: HomeView {
  func setupUI() {
    view.applyGradient(colors: [Styles.Color.gableGreen, Styles.Color.sanJuanBlue])
    
    mapView.alpha = 0
    view.addSubview(mapView)
    view.addSubview(mapLoadingPlaceholderView)
    mapLoadingPlaceholderView.addSubview(mapLoadingLabel)
    mapLoadingPlaceholderView.addSubview(locationWarningLabel)
    mapLoadingPlaceholderView.addSubview(openSettingsButton)
    view.addSubview(emergencyButton)
    view.addSubview(refreshButton)
    view.addSubview(bottomView)
    view.addSubview(loadingView)
    
    refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    openSettingsButton.addTarget(self, action: #selector(openSettingsTapped), for: .touchUpInside)
        
    loadingView.startAnimating()
    mapView.isHidden = true
    
    emergencyButton.addTarget(self, action: #selector(emergencyButtonTapped), for: .touchUpInside)
    
    bottomView.isHidden = true
    
    mapManager = GoogleMapsManager(mapView: mapView)
    mapManager?.applyDarkStyle()
    
    mapView.delegate = self
    locationManager.delegate = self
    
    bottomView.didScrollToStation = { [weak self] station in
      self?.generateSelectionFeedback()

      let coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
      self?.mapManager?.moveCamera(to: coordinate)
    }
    
    bottomView.directionTapped = { [weak self] station in
      guard self != nil else { return }
      self?.generateSelectionFeedback()
      
      let coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
      LocationManager.shared.openNavigation(to: coordinate, withName: station.name)
    }
    
    bottomView.detailTapped = { [weak self] station in
      guard self != nil else { return }
      self?.generateSelectionFeedback()
      
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
    
    locationWarningLabel.snp.makeConstraints {
      $0.top.equalTo(mapLoadingLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(20)
    }

    openSettingsButton.snp.makeConstraints {
      $0.top.equalTo(locationWarningLabel.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(100)
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
    refreshButton.isHidden = true
    emergencyButton.isHidden = true

    guard presenter.isInternetAvailable() else {
      let alert = UIAlertController(title: "İnternet Yok", message: "Lütfen internet bağlantınızı kontrol edin.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default) { [weak self] _ in
        self?.startLoading()
      })
      present(alert, animated: true)
      return
    }

    let status = locationManager.authorizationStatus
    if status == .denied || status == .restricted {
      checkLocationPermissionStatus()
      return
    }

    loadingView.startAnimating()
    mapView.isHidden = true
    mapLoadingLabel.text = "Harita yükleniyor..."
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

extension HomeViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationPermissionStatus()
  }
}
