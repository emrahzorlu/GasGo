//
//  FavouritesViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import Foundation
import UIKit
import SnapKit

final class FavouritesViewController: BaseViewController {
  var presenter: FavouritesPresentation!
  private let tableView = UITableView()
  private var favourites: [FavouriteStationEntity] = []
  
  private let emptyStateLabel: UILabel = {
    let label = UILabel()
    label.text = "Henüz favori istasyonun yok"
    label.font = Styles.font(family: .outfit, weight: .regular, size: 30)
    label.textColor = .white.withAlphaComponent(0.6)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.isHidden = true
    return label
  }()
  
  private let emptyStateImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "star.slash.fill"))
    imageView.tintColor = .white.withAlphaComponent(0.6)
    imageView.contentMode = .scaleAspectFit
    imageView.isHidden = true
    return imageView
  }()
  
  // MARK: Lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    presenter.viewDidAppear()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension FavouritesViewController: FavouritesView {
  func setupUI() {
    view.applyGradient(colors: [Styles.Color.gableGreen, Styles.Color.sanJuanBlue])

    let titleLabel = UILabel()
    titleLabel.text = "Favoriler"
    titleLabel.font = Styles.font(family: .outfit, weight: .semiBold, size: 42)
    titleLabel.textColor = .white

    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      make.leading.equalToSuperview().offset(16)
    }

    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    view.addSubview(emptyStateImageView)
    view.addSubview(emptyStateLabel)

    emptyStateImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-40)
      make.width.height.equalTo(100)
    }

    emptyStateLabel.snp.makeConstraints { make in
      make.top.equalTo(emptyStateImageView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(25)
    }
    
    tableView.register(StationCardTableViewCell.self, forCellReuseIdentifier: TableViewCellIdentifier.stationCardTableViewCell.rawValue)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
  }
  
  func showFavourites(_ favourites: [FavouriteStationEntity]) {
    self.favourites = favourites
    
    let isEmpty = favourites.isEmpty
    emptyStateLabel.isHidden = !isEmpty
    emptyStateImageView.isHidden = !isEmpty
    tableView.isHidden = isEmpty == true
    
    tableView.reloadData()
  }
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favourites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.stationCardTableViewCell.rawValue, for: indexPath) as? StationCardTableViewCell else {
      return UITableViewCell()
    }

    let favourite = favourites[indexPath.row]
    let model = StationCardModel(
      icon: GasStationBrand(matching: favourite.name).logo,
      title: favourite.name,
      address: favourite.address,
      distanceText: nil,
      style: .favorite
    )
    
    cell.configure(with: model)
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let itemToDelete = favourites[indexPath.row]
      presenter.removeFromFavourites(placeID: itemToDelete.id)
      favourites.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedFavourite = favourites[indexPath.row]
    
    presenter.statinSelected(station: selectedFavourite)
  }
}
