//
//  StationDetailCollectionViewCell.swift
//  GasGo
//
//  Created by Emrah Zorlu on 21.05.2025.
//

import UIKit
import SnapKit
import Kingfisher

class StationDetailCollectionViewCell: UICollectionViewCell {
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    return imageView
  }()
  
  let loadingIndicatorView = UIActivityIndicatorView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  func configure(with photoReference: String) {
    let maxWidth = 400
    let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxWidth)&photoreference=\(photoReference)&key=\(Config.apiKey)"

    if let url = URL(string: urlString) {
      imageView.kf.setImage(
        with: url,
        options: [.transition(.fade(0.2))]
      ) { [weak self] _ in
        self?.loadingIndicatorView.stopAnimating()
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    backgroundColor = .clear

    loadingIndicatorView.style = .large
    loadingIndicatorView.hidesWhenStopped = true
    loadingIndicatorView.color = .white
    loadingIndicatorView.startAnimating()
    
    imageView.layer.cornerRadius = 28
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    
    contentView.addSubview(imageView)
    contentView.addSubview(loadingIndicatorView)
    
    loadingIndicatorView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
