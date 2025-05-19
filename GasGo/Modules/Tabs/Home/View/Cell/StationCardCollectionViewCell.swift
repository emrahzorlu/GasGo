//
//  StationCardCollectionViewCell.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//

import UIKit
import SnapKit

final class StationCardCollectionViewCell: UICollectionViewCell {
  private let containerView = UIView()
  private let logoContainerView = UIView()
  private let logoImageView = UIImageView()
  
  private let nameLabel = UILabel()
  private let separatorLabel = UILabel()
  private let addressLabel = UILabel()
  private let openStatusView = UIView()
  private let openStatusLabel = UILabel()
  private let ratingLabel = UILabel()
  private let distanceLabel = UILabel()
  
  private let directionButton = UIButton(type: .system)
  private let detailButton = UIButton(type: .system)
  
  public var directionTapped: (() -> Void)?
  public var detaildTapped: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(name: String?, address: String?, distance: String?, rating: String?, reviewCount: String?, isOpen: Bool, logo: UIImage?) {
    nameLabel.text = name ?? "-"
    addressLabel.text = address ?? "-"
    distanceLabel.text = distance ?? "-"
    
    let ratingText = rating ?? "-"
    let reviewCountText = reviewCount ?? "-"
    ratingLabel.text = "\(ratingText) ⭐️ (\(reviewCountText))"
    
    openStatusLabel.text = isOpen ? "Şu an açık" : "Kapalı"
    openStatusView.backgroundColor = isOpen ? .green : .red
    logoImageView.image = logo
  }
  
  private func setupUI() {
    contentView.addSubview(containerView)
    containerView.backgroundColor = UIColor(red: 22/255, green: 25/255, blue: 33/255, alpha: 1)
    containerView.layer.cornerRadius = 16
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(8)
      $0.height.equalTo(200)
    }
    
    logoContainerView.backgroundColor = UIColor.white
    logoContainerView.layer.cornerRadius = 30
    logoContainerView.layer.borderWidth = 4
    logoContainerView.layer.borderColor = Styles.Color.buttercupYellow.cgColor
    logoContainerView.clipsToBounds = true
    containerView.addSubview(logoContainerView)
    logoContainerView.snp.makeConstraints {
      $0.size.equalTo(60)
      $0.leading.equalToSuperview().offset(12)
      $0.top.equalToSuperview().offset(8)
    }
    
    logoImageView.image = Styles.Image.shell
    logoImageView.contentMode = .scaleAspectFit
    logoContainerView.addSubview(logoImageView)
    logoImageView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(8)
    }
    
    nameLabel.font = Styles.font(family: .outfit, weight: .bold, size: 18)
    nameLabel.textColor = .white
    nameLabel.lineBreakMode = .byTruncatingTail
    nameLabel.numberOfLines = 1
    containerView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalTo(logoContainerView.snp.trailing).offset(12)
    }
    
    distanceLabel.font = Styles.font(family: .outfit, weight: .bold, size: 15)
    distanceLabel.textColor = .lightGray
    containerView.addSubview(distanceLabel)
    distanceLabel.snp.makeConstraints {
      $0.centerX.equalTo(logoContainerView)
      $0.top.equalTo(logoContainerView.snp.bottom).offset(6)
    }
    
    openStatusView.layer.cornerRadius = 4
    containerView.addSubview(openStatusView)
    openStatusView.snp.makeConstraints {
      $0.size.equalTo(8)
      $0.top.equalTo(nameLabel.snp.bottom).offset(13)
      $0.leading.equalTo(nameLabel.snp.leading)
    }
    
    openStatusLabel.font = Styles.font(family: .outfit, weight: .regular, size: 15)
    openStatusLabel.textColor = .white
    containerView.addSubview(openStatusLabel)
    openStatusLabel.snp.makeConstraints {
      $0.centerY.equalTo(openStatusView)
      $0.leading.equalTo(openStatusView.snp.trailing).offset(8)
    }
    
    ratingLabel.font = Styles.font(family: .outfit, weight: .medium, size: 17)
    ratingLabel.textColor = .white
    ratingLabel.lineBreakMode = .byTruncatingTail
    ratingLabel.numberOfLines = 1
    containerView.addSubview(ratingLabel)
    ratingLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(6)
      $0.leading.equalTo(openStatusLabel.snp.trailing).offset(20)
    }
    
    addressLabel.font = UIFont.systemFont(ofSize: 14)
    addressLabel.font = Styles.font(family: .outfit, weight: .regular, size: 16)
    addressLabel.textColor = .lightGray
    addressLabel.lineBreakMode = .byTruncatingTail
    addressLabel.numberOfLines = 2
    containerView.addSubview(addressLabel)
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(openStatusLabel.snp.bottom).offset(8)
      $0.leading.equalTo(nameLabel)
      $0.trailing.equalToSuperview().inset(2)
    }
    
    let directionButtonAttributedText = NSAttributedString(string: "Yol Tarifi Al" , attributes: [
      .font: Styles.font(family: .outfit, weight: .semiBold, size: 16)
    ])
    
    directionButton.setAttributedTitle(directionButtonAttributedText, for: .normal)
    directionButton.setTitleColor(Styles.Color.buttercupYellow, for: .normal)
    directionButton.layer.cornerRadius = 10
    directionButton.layer.borderWidth = 1
    directionButton.layer.borderColor = Styles.Color.buttercupYellow.cgColor
    containerView.addSubview(directionButton)
    directionButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(12)
      $0.leading.equalToSuperview().offset(12)
      $0.height.equalTo(44)
      $0.width.equalTo(160)
    }
    
    directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
    
    let detailButtonAttributedText = NSAttributedString(string: "Detayları Gör", attributes: [
      .font: Styles.font(family: .outfit, weight: .semiBold, size: 16)
    ])
    
    detailButton.setAttributedTitle(detailButtonAttributedText, for: .normal)
    detailButton.setTitleColor(.white, for: .normal)
    detailButton.backgroundColor = Styles.Color.buttercupYellow
    detailButton.layer.cornerRadius = 10
    containerView.addSubview(detailButton)
    detailButton.snp.makeConstraints {
      $0.bottom.equalTo(directionButton)
      $0.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(44)
      $0.width.equalTo(160)
    }
    
    detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
  }
  
  @objc private func directionButtonTapped() {
    directionTapped?()
  }
  
  @objc private func detailButtonTapped() {
    detaildTapped?()
  }
}
