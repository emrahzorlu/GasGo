//
//  EmergencyStationResultViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//
//

import Foundation
import UIKit

final class EmergencyStationResultViewController: BaseViewController {
  var presenter: EmergencyStationResultPresentation!
  
  private let tableView = UITableView()
  private var sections: [StationSection] = []
  
  private let emptyStateView: UIView = {
    let container = UIView()
    container.isHidden = true
    
    let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    let label = UILabel()
    label.text = "Bu bölgede eşleşen istasyon bulunamadı."
    label.textColor = .white
    label.font = Styles.font(family: .outfit, weight: .regular, size: 24)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    
    container.addSubview(imageView)
    container.addSubview(label)
    
    imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-40)
      $0.width.height.equalTo(64)
    }
    
    label.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(32)
    }
    
    return container
  }()
  
  // MARK: Lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    tabBarController?.tabBar.isHidden = false
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(StationCardTableViewCell.self, forCellReuseIdentifier: TableViewCellIdentifier.stationCardTableViewCell.rawValue)
    tableView.separatorStyle = .none
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension EmergencyStationResultViewController: EmergencyStationResultView {
  func setupUI() {
    let gradientColors = [
      UIColor(red: 255/255, green: 94/255, blue: 98/255, alpha: 1.0),
      UIColor(red: 255/255, green: 175/255, blue: 64/255, alpha: 1.0)
    ]
    view.applyGradient(colors: gradientColors)
    
    
    let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)?
      .withTintColor(.white, renderingMode: .alwaysOriginal)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: backImage,
      style: .plain,
      target: self,
      action: #selector(backButtonTapped)
    )
    navigationItem.leftBarButtonItem?.tintColor = .black
    
    setupTableView()
    view.addSubview(emptyStateView)
    emptyStateView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  @objc private func backButtonTapped() {
    generateSelectionFeedback()
    
    presenter.backButtonTapped()
  }
  
  func displaySections(_ sections: [StationSection]) {
    self.sections = sections.map {
      switch $0 {
      case .favorite(let stations):
        return stations.isEmpty
        ? .favorite([NearbyPlaceEntity(
          id: "placeholder_favorite",
          name: "Favori istasyon bulunamadı",
          latitude: 0,
          longitude: 0,
          address: nil,
          iconURL: nil,
          rating: nil,
          userRatingsTotal: nil,
          isOpenNow: nil,
          distanceText: nil
        )])
        : .favorite(stations)
        
      case .alternative(let stations):
        return stations.isEmpty
        ? .alternative([NearbyPlaceEntity(
          id: "placeholder_alternative",
          name: "Alternatif istasyon bulunamadı",
          latitude: 0,
          longitude: 0,
          address: nil,
          iconURL: nil,
          rating: nil,
          userRatingsTotal: nil,
          isOpenNow: nil,
          distanceText: nil
        )])
        : .alternative(stations)
      }
    }
    
    let hasFavorites = self.sections.contains {
      if case .favorite(let stations) = $0 {
        return !stations.isEmpty && stations.first?.id != "placeholder_favorite"
      }
      return false
    }
    
    let hasAlternatives = self.sections.contains {
      if case .alternative(let stations) = $0 {
        return !stations.isEmpty && stations.first?.id != "placeholder_alternative"
      }
      return false
    }
    
    let shouldShowEmptyState = !hasFavorites && !hasAlternatives
    emptyStateView.isHidden = !shouldShowEmptyState
    tableView.isHidden = shouldShowEmptyState
    
    tableView.reloadData()
  }
}

extension EmergencyStationResultViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch sections[section] {
    case .favorite(let stations), .alternative(let stations):
      return stations.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.stationCardTableViewCell.rawValue, for: indexPath) as! StationCardTableViewCell
    let station: NearbyPlaceEntity
    switch sections[indexPath.section] {
    case .favorite(let stations), .alternative(let stations):
      station = stations[indexPath.row]
    }
    if station.id == "placeholder_favorite" || station.id == "placeholder_alternative" {
      let model = StationCardModel(
        icon: nil,
        title: station.name,
        address: "",
        distanceText: "",
        style: .empty
      )
      cell.configure(with: model)
      cell.detailButtonTapped = nil
      cell.routeButtonTapped = nil
      return cell
    }
    let brand = GasStationBrand(matching: station.name)
    let model = StationCardModel(
      icon: brand.logo,
      title: station.name,
      address: station.address ?? "-",
      distanceText: station.drivingDistanceInMetersText,
      style: .emergency
    )
    
    cell.configure(with: model)
    cell.detailButtonTapped = { [weak self] in
      self?.generateSelectionFeedback()
      
      self?.presenter.didSelectStation(with: station.id)
    }
    
    cell.routeButtonTapped = { [weak self] in
      self?.generateSelectionFeedback()
      
      LocationManager.shared.openNavigation(to: station.coordinate)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch sections[section] {
    case .favorite:
      return "Favori İstasyonlar"
    case .alternative:
      return "Alternatif İstasyonlar"
    }
  }
}

extension EmergencyStationResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let station: NearbyPlaceEntity
    switch sections[indexPath.section] {
    case .favorite(let stations), .alternative(let stations):
      station = stations[indexPath.row]
    }
    
    let isPlaceholder = station.id == "placeholder_favorite" || station.id == "placeholder_alternative"
    guard !isPlaceholder else { return }
    
    presenter.didSelectStation(with: station.id)
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel?.font = Styles.font(family: .outfit, weight: .semiBold, size: 28)
      header.textLabel?.textColor = .white
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 44
  }
}
