//
//  SettingsTableViewCell.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
  private let iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Styles.font(family: .outfit, weight: .regular, size: 17)
    label.textColor = .white
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  private func setupUI() {
    let cellColor = UIColor(hex: "#2C5364").withAlphaComponent(0.5)
    backgroundColor = cellColor
    
    contentView.addSubview(iconImageView)
    contentView.addSubview(titleLabel)
    
    accessoryType = .disclosureIndicator
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    iconImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(24)
    }
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImageView.snp.trailing).offset(12)
      make.centerY.equalToSuperview()
      make.trailing.lessThanOrEqualToSuperview().offset(-16)
    }
  }
  
  func configure(with type: SettingsType) {
    iconImageView.image = type.icon
    titleLabel.text = type.title
  }
}
