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
  }
  
  @objc private func backButtonTapped() {
    generateSelectionFeedback()
    
    presenter.backButtonTapped()
  }
  
  func displaySections(_ sections: [StationSection]) {
    self.sections = sections
    
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
