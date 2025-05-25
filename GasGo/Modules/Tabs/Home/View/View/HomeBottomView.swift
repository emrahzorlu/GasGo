//
//  HomeBottomView.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import SnapKit
import GoogleMaps

final class HomeBottomView: UIView {
  private let collectionView: UICollectionView
  private var stations: [NearbyPlaceEntity] = []
  
  var didScrollToStation: ((NearbyPlaceEntity) -> Void)?
  var directionTapped: ((NearbyPlaceEntity) -> Void)?
  var detailTapped: ((NearbyPlaceEntity) -> Void)?
  
  override init(frame: CGRect) {
    let layout = SnappingFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    super.init(frame: frame)
    
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = .clear
    addSubview(collectionView)
    
    collectionView.backgroundColor = .clear
    collectionView.isPagingEnabled = false
    collectionView.decelerationRate = .fast
    collectionView.register(StationCardCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCellIdentifier.stationCardCollectionViewCell.rawValue)
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func updateStations(_ stations: [NearbyPlaceEntity]) {
    self.stations = stations
    collectionView.reloadData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func scrollToItem(at index: Int) {
    let indexPath = IndexPath(item: index, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      notifyCurrentCenteredItem()
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    notifyCurrentCenteredItem()
  }
  
  private func notifyCurrentCenteredItem() {
    let xCenter = collectionView.contentOffset.x + (collectionView.bounds.width / 2)
    let yCenter = collectionView.bounds.height / 2
    let center = CGPoint(x: xCenter, y: yCenter)
    
    guard let indexPath = collectionView.indexPathForItem(at: center) else { return }
    let station = stations[indexPath.item]
    didScrollToStation?(station)
  }
}

extension HomeBottomView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return stations.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CollectionViewCellIdentifier.stationCardCollectionViewCell.rawValue,
      for: indexPath) as? StationCardCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let station = stations[indexPath.item]
    let brand = GasStationBrand(matching: station.name)
    let logo = brand.logo
    let distance = station.drivingDistanceInMetersText
    let isOpen = station.isOpenNow ?? false
    
    cell.configure(
      name: station.name,
      address: station.address,
      distance: distance,
      rating: station.rating.map { String($0) },
      reviewCount: station.userRatingsTotal.map { String($0) },
      isOpen: isOpen,
      logo: logo
    )
    
    cell.directionTapped = { [weak self] in
      guard let self = self else { return }
      
      let station = self.stations[indexPath.item]
      self.directionTapped?(station)
    }
    
    cell.detaildTapped = { [weak self] in
      guard let self = self else { return }
      
      let station = self.stations[indexPath.item]
      self.detailTapped?(station)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width - 40, height: 200)
  }
}
