//
//  OnboardingCollectionViewCell.swift
//  GasGo
//
//  Created by Emrah Zorlu on 11.05.2025.
//

import UIKit
import SnapKit
import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {
  private let animationView: LottieAnimationView = {
    let animationView = LottieAnimationView()
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    return animationView
  }()
  
  private let titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = Styles.font(family: .outfit, weight: .medium, size: 24)
    titleLabel.textColor = .black
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    return titleLabel
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(animationView)
    contentView.addSubview(titleLabel)
    
    animationView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalToSuperview().multipliedBy(0.75)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(animationView.snp.bottom).offset(0)
      make.leading.trailing.equalToSuperview().inset(16)
    }
  }

  
  func configure(with title: String, subtitle: String, animationName: String) {
    titleLabel.text = title
    animationView.animation = LottieAnimation.named(animationName)
    animationView.play()
  }
}
