//
//  FavouritesTableViewCell.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//


import UIKit
import SnapKit

class FavouritesTableViewCell: UITableViewCell {
  
  private let containerView = UIView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = .clear
    
    containerView.backgroundColor = .secondarySystemBackground
    containerView.layer.cornerRadius = 12
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOpacity = 0.1
    containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    containerView.layer.shadowRadius = 4
    selectionStyle = .none
    
    titleLabel.font = Styles.font(family: .outfit, weight: .semiBold, size: 16)
    titleLabel.textColor = Styles.Color.buttercupYellow.withAlphaComponent(0.75)
    subtitleLabel.font = Styles.font(family: .outfit, weight: .medium, size: 14)
    subtitleLabel.textColor = .gray
    subtitleLabel.numberOfLines = 2
    
    contentView.addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(subtitleLabel)
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(12)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.left.right.equalToSuperview().inset(16)
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.left.right.bottom.equalToSuperview().inset(16)
    }
  }
  
  func configure(with entity: FavouriteStationEntity) {
    titleLabel.text = entity.name
    subtitleLabel.text = entity.address ?? "Adres bilgisi bulunamadı"
  }
}
