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
    titleLabel.font = Styles.font(family: .outfit, weight: .semiBold, size: 30)
    titleLabel.textColor = Styles.Color.buttercupYellow

    let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    starImageView.tintColor = Styles.Color.buttercupYellow
    starImageView.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }

    let titleStackView = UIStackView(arrangedSubviews: [starImageView, titleLabel])
    titleStackView.axis = .horizontal
    titleStackView.spacing = 8
    titleStackView.alignment = .center

    view.addSubview(titleStackView)
    titleStackView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      make.leading.equalToSuperview().offset(16)
    }

    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(titleStackView.snp.bottom).offset(16)
      make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: "FavouritesTableViewCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
  }
  
  func showFavourites(_ favourites: [FavouriteStationEntity]) {
    self.favourites = favourites
    tableView.reloadData()
  }
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favourites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as? FavouritesTableViewCell else {
      return UITableViewCell()
    }
    let favourite = favourites[indexPath.row]
    cell.configure(with: favourite)
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
    
    if NetworkManager.shared.isConnectedToInternet {
      presenter.statinSelected(station: selectedFavourite)
    } else {
      //TODO: Show Alert
    }
  }
}
