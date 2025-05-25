//
//  StationDetailViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//
//

import UIKit
import SnapKit

final class StationDetailViewController: BaseViewController {
  private var isFavorite: Bool = false
  private let titleLabel = UILabel()
  private let favButtonContainerView = UIView()
  private let favButton = UIButton()
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  private let isOpenNowView = UIView()
  private let isOpenNowStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.alignment = .center
    return stackView
  }()
  private let isOpenNowLabel = UILabel()
  private let rankingLabel = UILabel()
  private let adressImageView = UIImageView()
  private let adressLabel = UILabel()
  private let phoneImageView = UIImageView()
  private let phoneLabel = UILabel()
  
  private let evChargingInfoImageView = UIImageView()
  private let evChargingInfoLabel = UILabel()
  
  private let marketInfoImageView = UIImageView()
  private let marketInfoLabel = UILabel()
  
  private let carWashInfoImageView = UIImageView()
  private let carWashInfoLabel = UILabel()
  
  private let nearbyRestaurantInfoImageView = UIImageView()
  private let nearbyRestaurantInfoLabel = UILabel()
  
  private let adressInfoStackView = UIStackView()
  private let phoneInfoStackView = UIStackView()
  private let evChargingInfoStackView = UIStackView()
  private let marketInfoStackView = UIStackView()
  private let carWashInfoStackView = UIStackView()
  private let nearbyRestaurantInfoStackView = UIStackView()
  
  private let getDirectionsButton = UIButton()
  
  var presenter: StationDetailPresentation!
  
  private var currentPhotoReferences: [String] = []
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(view.snp.height).multipliedBy(0.18)
    }
    
    adressInfoStackView.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    
    adressImageView.snp.makeConstraints { $0.width.height.equalTo(24) }
    
    phoneInfoStackView.snp.makeConstraints {
      $0.top.equalTo(adressInfoStackView.snp.bottom).offset(12)
      $0.leading.equalTo(adressImageView.snp.leading).offset(4)
    }
    
    phoneImageView.snp.makeConstraints { $0.width.height.equalTo(24) }
    
    isOpenNowStackView.snp.makeConstraints{
      $0.top.equalTo(phoneInfoStackView.snp.bottom).offset(12)
      $0.leading.equalTo(phoneImageView.snp.leading).offset(4)
    }
    
    isOpenNowView.snp.makeConstraints { $0.width.height.equalTo(14) }
    
    rankingLabel.snp.makeConstraints {
      $0.leading.equalTo(isOpenNowStackView.snp.trailing).offset(48)
      $0.top.equalTo(phoneInfoStackView.snp.bottom).offset(12)
    }
    
    getDirectionsButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(52)
    }
  }
  
  private func setupTitleLabel() {
    view.addSubview(titleLabel)
    
    titleLabel.textColor = UIColor.white
    titleLabel.numberOfLines = 2
  }
  
  private func setupFavButton() {
    let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
    let heartImage = UIImage(systemName: "heart", withConfiguration: config)
    favButton.setImage(heartImage, for: .normal)
    favButton.imageView?.contentMode = .scaleAspectFit
    favButton.tintColor = Styles.Color.buttercupYellow
    favButton.backgroundColor = .darkGray.withAlphaComponent(0.5)
    favButton.layer.cornerRadius = 18
    favButton.clipsToBounds = true
    favButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
    
    let barButtonItem = UIBarButtonItem(customView: favButton)
    navigationItem.rightBarButtonItem = barButtonItem
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 12
    layout.minimumInteritemSpacing = 12
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.collectionViewLayout = layout
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.decelerationRate = .fast
    collectionView.clipsToBounds = false
    collectionView.isPagingEnabled = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    view.addSubview(collectionView)
  }
  
  private func setupAddressInfoStackView() {
    view.addSubview(adressInfoStackView)
    adressInfoStackView.addArrangedSubview(adressImageView)
    adressInfoStackView.addArrangedSubview(adressLabel)
    
    adressInfoStackView.axis = .horizontal
    adressInfoStackView.alignment = .center
    adressInfoStackView.spacing = 8
    adressInfoStackView.distribution = .fill
    adressLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    adressLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    
    adressLabel.numberOfLines = 0
    adressImageView.image = UIImage(systemName: "mappin")
    adressImageView.tintColor = .darkGray
  }
  
  private func setupPhoneInfoStackView() {
    view.addSubview(phoneInfoStackView)
    
    phoneInfoStackView.addArrangedSubview(phoneImageView)
    phoneInfoStackView.addArrangedSubview(phoneLabel)
    
    phoneInfoStackView.axis = .horizontal
    phoneInfoStackView.alignment = .center
    phoneInfoStackView.spacing = 8
    phoneInfoStackView.distribution = .fill
    phoneLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    phoneLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    phoneImageView.image = UIImage(systemName: "phone")
    phoneImageView.tintColor = .darkGray
  }
  
  private func setupIsOpenNowStackView() {
    view.addSubview(isOpenNowStackView)
    isOpenNowStackView.addArrangedSubview(isOpenNowView)
    isOpenNowStackView.addArrangedSubview(isOpenNowLabel)
    
    isOpenNowView.backgroundColor = .green
    isOpenNowView.layer.cornerRadius = 7
    
    isOpenNowLabel.textColor = .white
    isOpenNowLabel.font = Styles.font(family: .outfit, weight: .medium, size: 16)
  }
  
  private func setupRankingLabel() {
    view.addSubview(rankingLabel)
    
    rankingLabel.textColor = .white
    rankingLabel.font = Styles.font(family: .outfit, weight: .medium, size: 16)
  }
  
  private func setupStationInfoStackViews() {
    let topRowStack = UIStackView(arrangedSubviews: [evChargingInfoStackView, marketInfoStackView])
    let bottomRowStack = UIStackView(arrangedSubviews: [carWashInfoStackView, nearbyRestaurantInfoStackView])
    let infoContainerStack = UIStackView(arrangedSubviews: [topRowStack, bottomRowStack])
    
    [topRowStack, bottomRowStack, infoContainerStack].forEach {
      $0.axis = .horizontal
      $0.alignment = .fill
      $0.distribution = .fillEqually
      $0.spacing = 12
    }
    
    infoContainerStack.axis = .vertical
    infoContainerStack.spacing = 12
    
    view.addSubview(infoContainerStack)
    infoContainerStack.snp.makeConstraints {
      $0.top.equalTo(rankingLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalToSuperview().multipliedBy(0.23)
    }
    
    [evChargingInfoStackView, marketInfoStackView, carWashInfoStackView, nearbyRestaurantInfoStackView].forEach {
      $0.axis = .vertical
      $0.alignment = .center
      $0.distribution = .fill
      $0.spacing = 4
      $0.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.6)
      $0.layer.cornerRadius = 8
      $0.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
      $0.isLayoutMarginsRelativeArrangement = true

      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOpacity = 0.2
      $0.layer.shadowOffset = CGSize(width: 0, height: 2)
      $0.layer.shadowRadius = 4
      $0.layer.masksToBounds = false
      $0.clipsToBounds = false
    }
    
    evChargingInfoStackView.addArrangedSubview(evChargingInfoImageView)
    evChargingInfoStackView.addArrangedSubview(evChargingInfoLabel)
    
    marketInfoStackView.addArrangedSubview(marketInfoImageView)
    marketInfoStackView.addArrangedSubview(marketInfoLabel)
    
    carWashInfoStackView.addArrangedSubview(carWashInfoImageView)
    carWashInfoStackView.addArrangedSubview(carWashInfoLabel)
    
    nearbyRestaurantInfoStackView.addArrangedSubview(nearbyRestaurantInfoImageView)
    nearbyRestaurantInfoStackView.addArrangedSubview(nearbyRestaurantInfoLabel)
    
    [evChargingInfoLabel, marketInfoLabel, carWashInfoLabel, nearbyRestaurantInfoLabel].forEach {
      $0.font = Styles.font(family: .outfit, weight: .medium, size: 14)
      $0.textColor = .white
      $0.textAlignment = .center
      $0.numberOfLines = 2
    }
    
    [evChargingInfoImageView, marketInfoImageView, carWashInfoImageView, nearbyRestaurantInfoImageView].forEach {
      $0.contentMode = .scaleAspectFit
      $0.tintColor = .white
      $0.snp.makeConstraints { $0.size.equalTo(28) }
    }
  }
  
  private func setupGetDirectionsButton() {
    view.addSubview(getDirectionsButton)
    
    getDirectionsButton.layer.cornerRadius = 20
    getDirectionsButton.backgroundColor = Styles.Color.buttercupYellow
    getDirectionsButton.titleLabel?.numberOfLines = 2
    getDirectionsButton.titleLabel?.textAlignment = .center
    
    getDirectionsButton.addTarget(self, action: #selector(getDirectionsButtonTapped), for: .touchUpInside)
  }
  
  @objc private func favButtonTapped() {
    generateSelectionFeedback()
    
    isFavorite.toggle()
    updateFavButtonAppearance(isFilled: isFavorite)
    if isFavorite {
      presenter.addCurrentStationToFavorites()
      AlertView.show(in: getWindow(), type: .success, title: "Favorilere Eklendi!")
    } else {
      presenter.removeCurrentStationFromFavorites()
      AlertView.show(in: getWindow(), type: .failure, title: "Favorilerden Kaldırıldı!")
    }
  }
  
  @objc private func backButtonTapped() {
    generateSelectionFeedback()

    navigationController?.popViewController(animated: true)
  }
  
  
  @objc private func getDirectionsButtonTapped() {
    generateSelectionFeedback()

    presenter.getDirectionsButtonTapped()
    
  }
  
  private func updateFavButtonAppearance(isFilled: Bool) {
    let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
    let newSymbolName = isFilled ? "heart.fill" : "heart"
    let newImage = UIImage(systemName: newSymbolName, withConfiguration: config)
    
    favButton.setImage(newImage, for: .normal)
    favButton.imageView?.image?.accessibilityIdentifier = newSymbolName
  }
}

extension StationDetailViewController: StationDetailView {
  func setupUI() {
    view.applyGradient(colors: [Styles.Color.gableGreen, Styles.Color.sanJuanBlue])
    
    collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCellIdentifier.stationDetailCollectionViewCell.rawValue)
    setupTitleLabel()
    
    let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: backImage,
      style: .plain,
      target: self,
      action: #selector(backButtonTapped)
    )
    navigationItem.leftBarButtonItem?.tintColor = Styles.Color.buttercupYellow
    
    setupFavButton()
    setupCollectionView()
    setupAddressInfoStackView()
    setupPhoneInfoStackView()
    setupIsOpenNowStackView()
    setupRankingLabel()
    setupStationInfoStackViews()
    setupGetDirectionsButton()
    setupConstraints()
  }
  
  func displayStationDetails(_ details: [PlaceDetailEntity]) {
    guard let detail = details.first else { return }
    configureView(with: detail)
  }

  func updateDistanceText(_ directions: DirectionsEntity?) {
      let topText = "Yol Tarifi Al"
    let bottomText = [directions?.distanceText, directions?.durationText].compactMap { $0 }.joined(separator: " • ")
      
      let fullText = "\(topText)\n\(bottomText)"
      
      let attributedString = NSMutableAttributedString(
        string: fullText,
        attributes: [
          .font: Styles.font(family: .outfit, weight: .semiBold, size: 20),
          .foregroundColor: UIColor.white
        ]
      )
      
      if let range = fullText.range(of: bottomText) {
        let nsRange = NSRange(range, in: fullText)
        attributedString.addAttributes([
          .font: Styles.font(family: .outfit, weight: .regular, size: 14),
          .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ], range: nsRange)
      }
      
      getDirectionsButton.setAttributedTitle(attributedString, for: .normal)
  }
  
  private func configureView(with detail: PlaceDetailEntity) {
    titleLabel.attributedText = NSAttributedString(
      string: detail.name,
      attributes: [.font: Styles.font(family: .outfit, weight: .bold, size: 28), .foregroundColor: UIColor.white]
    )
    adressLabel.attributedText = NSAttributedString(
      string: detail.address ?? "-",
      attributes: [.font: Styles.font(family: .outfit, weight: .regular, size: 18), .foregroundColor: UIColor.white]
    )
    phoneLabel.attributedText = NSAttributedString(
      string: detail.phone ?? "-",
      attributes: [.font: Styles.font(family: .outfit, weight: .regular, size: 18), .foregroundColor: UIColor.white]
    )
    isOpenNowLabel.attributedText = NSAttributedString(
      string: detail.isOpenNow == true ? "Şu An Açık" : "Şu An Kapalı",
      attributes: [.font: Styles.font(family: .outfit, weight: .medium, size: 18), .foregroundColor: UIColor.white]
    )
    isOpenNowView.backgroundColor = detail.isOpenNow == true ? .systemGreen : .systemRed
    rankingLabel.attributedText = NSAttributedString(
      string: {
        if let rating = detail.rating, let total = detail.totalRatings {
          return "\(rating) ⭐️ (\(total))"
        } else {
          return "Puan yok"
        }
      }(),
      attributes: [.font: Styles.font(family: .outfit, weight: .medium, size: 18), .foregroundColor: UIColor.white]
    )

    // Market Info
    let marketAvailable = detail.hasMarket
    marketInfoLabel.attributedText = NSAttributedString(
      string: marketAvailable ? "Market: Var" : "Market: Yok",
      attributes: [.font: Styles.font(family: .outfit, weight: .medium, size: 18), .foregroundColor: UIColor.white]
    )
    marketInfoStackView.backgroundColor = marketAvailable ? UIColor.systemGreen.withAlphaComponent(0.6) : UIColor.darkGray.withAlphaComponent(0.6)
    marketInfoImageView.image = UIImage(systemName: marketAvailable ? "cart.fill" : "cart")

    // Car Wash Info
    let carWashAvailable = detail.hasCarWash
    carWashInfoLabel.attributedText = NSAttributedString(
      string: carWashAvailable ? "Oto Yıkama: Var" : "Oto Yıkama: Yok",
      attributes: [.font: Styles.font(family: .outfit, weight: .medium, size: 18), .foregroundColor: UIColor.white]
    )
    carWashInfoStackView.backgroundColor = carWashAvailable ? UIColor.systemGreen.withAlphaComponent(0.6) : UIColor.darkGray.withAlphaComponent(0.6)
    carWashInfoImageView.image = UIImage(systemName: carWashAvailable ? "drop.fill" : "drop")

    // EV Charging Info
    let evChargeAvailable = detail.hasSmartCharge
    evChargingInfoLabel.attributedText = NSAttributedString(
      string: evChargeAvailable ? "Elektrikli Şarj: Var" : "Elektrikli Şarj: Yok",
      attributes: [.font: Styles.font(family: .outfit, weight: .medium, size: 18), .foregroundColor: UIColor.white]
    )
    evChargingInfoStackView.backgroundColor = evChargeAvailable ? UIColor.systemGreen.withAlphaComponent(0.6) : UIColor.darkGray.withAlphaComponent(0.6)
    evChargingInfoImageView.image = UIImage(systemName: evChargeAvailable ? "bolt.car.fill" : "bolt.car")

    // Nearby Restaurant Info
    let hasFoodNearby = detail.hasNearbyFood ?? false
    nearbyRestaurantInfoLabel.attributedText = NSAttributedString(
      string: hasFoodNearby ? "Yakında Restoran: Var" : "Yakında Restoran: Yok",
      attributes: [.font: Styles.font(family: .outfit, weight: .medium, size: 14), .foregroundColor: UIColor.white]
    )
    nearbyRestaurantInfoStackView.backgroundColor = hasFoodNearby ? UIColor.systemGreen.withAlphaComponent(0.6) : UIColor.darkGray.withAlphaComponent(0.6)
    nearbyRestaurantInfoImageView.image = UIImage(systemName: hasFoodNearby ? "fork.knife.circle.fill" : "fork.knife.circle")

    currentPhotoReferences = detail.photoReferences ?? []

    collectionView.reloadData()

    presenter.checkIfStationIsFavorite(id: detail.id) { [weak self] isFav in
      self?.isFavorite = isFav
      self?.updateFavButtonAppearance(isFilled: isFav)
    }
  }
}

extension StationDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentPhotoReferences.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CollectionViewCellIdentifier.stationDetailCollectionViewCell.rawValue,
      for: indexPath
    ) as? StationDetailCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let photoReference = currentPhotoReferences[indexPath.item]
    cell.configure(with: photoReference)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = collectionView.frame.height
    let width = height
    return CGSize(width: width, height: height)
  }
}
