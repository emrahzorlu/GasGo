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
  
  private var selectedPlaceID: String?
  
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
  
  private let myLocationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "location.fill"), for: .normal)
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
  
  // MARK: Lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    presenter.viewWillAppear()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteBrandChanged), name: .favoriteBrandChanged, object: nil)
    
    presenter.viewDidLoad()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .favoriteBrandChanged, object: nil)
  }
  
  private func reloadMarkers() {
    mapManager?.clearMarkers()
    
    for station in stationList {
      let brand = GasStationBrand(matching: station.name)
      
      let isSelected = station.id == selectedPlaceID
      
      let icon = MarkerFactory.buildMarkerIcon(for: brand, isFavorite: false, isSelected: isSelected)
      mapManager?.addMarker(at: station.coordinate, title: station.name, icon: icon, placeID: station.id)
    }
  }
  
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
  
  @objc private func handleFavoriteBrandChanged() {
    mapView.clear()
    
    presenter.refreshStations()
  }
  
  @objc private func emergencyButtonTapped() {
    generateSelectionFeedback()
    
    presenter.emergencyButtonTapped()
  }
  
  @objc private func myLocationButtonTapped() {
    generateSelectionFeedback()
    mapManager?.moveCameraToMyLocation()
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
    view.addSubview(myLocationButton)
    view.addSubview(bottomView)
    view.addSubview(loadingView)
    
    openSettingsButton.addTarget(self, action: #selector(openSettingsTapped), for: .touchUpInside)
    myLocationButton.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    
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
      self?.selectedPlaceID = station.id
      self?.reloadMarkers()
      
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
    let selected = Config.selectedFavoriteBrand ?? ""
    let normalizedSelected = selected.replacingOccurrences(of: " ", with: "").lowercased()
    let normalizedCurrent = brand.rawValue.replacingOccurrences(of: " ", with: "").lowercased()
    let shouldHighlight = normalizedSelected == normalizedCurrent
    
    print("Favori brand: \(Config.selectedFavoriteBrand ?? "-")")
    print("shouldHighlight: \(shouldHighlight)")
    let icon = MarkerFactory.buildMarkerIcon(for: brand, isFavorite: shouldHighlight)
    mapManager?.addMarker(at: coordinate, title: title, icon: icon, placeID: placeID)
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
      $0.trailing.equalToSuperview().inset(12)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
      $0.width.height.equalTo(56)
    }
    
    myLocationButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(12)
      $0.top.equalTo(emergencyButton.snp.bottom).offset(12)
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
  }
  
  func showStations(_ stations: [NearbyPlaceEntity]) {
    stationList = stations
    bottomView.updateStations(stations)
  }
  
  func startLoading() {
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
    myLocationButton.isHidden = true
    mapLoadingLabel.text = "Harita yükleniyor..."
    mapLoadingPlaceholderView.isHidden = false
  }
  
  func stopLoading() {
    loadingView.stopAnimating()
    mapView.isHidden = false
    myLocationButton.isHidden = false
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
    
    if let placeID = marker.userData as? String {
      selectedPlaceID = placeID
      reloadMarkers()
    }
    mapManager?.moveCamera(to: marker.position)
    bottomView.isHidden = false
    scrollToStation(placeID: placeID)
    
    return true
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    bottomView.isHidden = true
    selectedPlaceID = nil
    reloadMarkers()
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationPermissionStatus()
  }
}
