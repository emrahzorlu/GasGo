//
//  StationCardTableViewCell.swift
//  GasGo
//
//  Created by Emrah Zorlu on 25.05.2025.
//

import UIKit
import SnapKit

enum StationCardStyle {
  case emergency
  case favorite
}

struct StationCardModel {
  let icon: UIImage?
  let title: String
  let address: String?
  let distanceText: String?
  let style: StationCardStyle

  var showButton: Bool {
    return style == .emergency
  }
}

final class StationCardTableViewCell: UITableViewCell {
  private let cardView = UIView()
  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()
  private let addressLabel = UILabel()
  private let distanceLabel = UILabel()
  private let detailButton = UIButton()
  private let routeButton = UIButton()
  private let buttonsStackView = UIStackView()
  private let infoStackView = UIStackView()
  
  var detailButtonTapped: (() -> Void)?
  var routeButtonTapped: (() -> Void)?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupUI() {
    backgroundColor = .clear
    selectionStyle = .none
    contentView.backgroundColor = .clear
    
    contentView.addSubview(cardView)
    setupCardView()
    setupButtonsStackView()
    setupIconImageView()
    setupTitleLabel()
    setupAddressLabel()
    setupDetailButton()
    setupRouteButton()
    setupInfoStackView()
    
    [iconImageView, infoStackView, distanceLabel, buttonsStackView].forEach {
      cardView.addSubview($0)
    }
    
    setupConstraints()
  }
  
  private func setupInfoStackView() {
    infoStackView.axis = .vertical
    infoStackView.alignment = .leading
    infoStackView.spacing = 8
    infoStackView.addArrangedSubview(titleLabel)
    infoStackView.addArrangedSubview(addressLabel)
  }
  
  func setupButtonsStackView() {
    buttonsStackView.axis = .vertical
    buttonsStackView.alignment = .center
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = 16
    
    buttonsStackView.addArrangedSubview(routeButton)
    buttonsStackView.addArrangedSubview(detailButton)
  }
  
  private func setupCardView() {
    cardView.backgroundColor = .black.withAlphaComponent(0.6)
    cardView.layer.cornerRadius = 16
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.1
    cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
    cardView.layer.shadowRadius = 8
    cardView.layer.masksToBounds = false
  }
  
  private func setupIconImageView() {
    iconImageView.contentMode = .scaleAspectFit
  }
  
  private func setupTitleLabel() {
    titleLabel.font = Styles.font(family: .outfit, weight: .bold, size: 16)
    titleLabel.numberOfLines = 2
    titleLabel.textColor = .white
  }
  
  private func setupAddressLabel() {
    addressLabel.font = Styles.font(family: .outfit, weight: .medium, size: 14)
    addressLabel.textColor = UIColor.white.withAlphaComponent(0.7)
    addressLabel.numberOfLines = 0
  }
  
  private func setupDetailButton() {
    detailButton.setTitle("Detayları Gör", for: .normal)
    detailButton.backgroundColor = Styles.Color.buttercupYellow
    detailButton.setTitleColor(.white, for: .normal)
    detailButton.layer.cornerRadius = 10
    detailButton.titleLabel?.font = Styles.font(family: .outfit, weight: .bold, size: 14)
    detailButton.addTarget(self, action: #selector(handleDetailButtonTapped), for: .touchUpInside)
  }
  
  private func setupRouteButton() {
    routeButton.setTitle("Yol Tarifi Al", for: .normal)
    routeButton.backgroundColor = .clear
    routeButton.layer.borderWidth = 1
    routeButton.layer.borderColor = Styles.Color.buttercupYellow.cgColor
    routeButton.setTitleColor(Styles.Color.buttercupYellow, for: .normal)
    routeButton.layer.cornerRadius = 10
    routeButton.titleLabel?.font = Styles.font(family: .outfit, weight: .bold, size: 14)
    routeButton.addTarget(self, action: #selector(handleRouteButtonTapped), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    cardView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(12)
    }
    
    iconImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(12)
      $0.centerY.equalTo(cardView.snp.centerY)
      $0.width.height.equalTo(50)
    }
    
    routeButton.snp.makeConstraints { $0.width.equalTo(120) }
    detailButton.snp.makeConstraints { $0.width.equalTo(120) }
    
    buttonsStackView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(12)
      $0.width.equalTo(140)
    }
  }
  
  func configure(with model: StationCardModel) {
    iconImageView.image = model.icon
    
    titleLabel.text = model.style == .emergency ? "\(model.title) • \(model.distanceText ?? "-")" : model.title
    addressLabel.text = model.address
    detailButton.isHidden = !model.showButton
    routeButton.isHidden = !model.showButton
    
    switch model.style {
    case .emergency:
      distanceLabel.isHidden = false
      detailButton.isHidden = !model.showButton
      routeButton.isHidden = !model.showButton
    case .favorite:
      distanceLabel.isHidden = true
      detailButton.isHidden = true
      routeButton.isHidden = true
    }
    
    infoStackView.snp.remakeConstraints {
      $0.leading.equalTo(iconImageView.snp.trailing).offset(10)
      if routeButton.isHidden && detailButton.isHidden {
        $0.trailing.equalTo(cardView.snp.trailing).inset(12)
      } else {
        $0.trailing.equalTo(buttonsStackView.snp.leading).offset(-10)
      }
      $0.centerY.equalToSuperview()
      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
    }
  }
  
  @objc private func handleDetailButtonTapped() {
    detailButtonTapped?()
  }
  
  @objc private func handleRouteButtonTapped() {
    routeButtonTapped?()
  }
}
