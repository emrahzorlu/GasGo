//
//  AlertView.swift
//  GasGo
//
//  Created by Emrah Zorlu on 25.05.2025.
//

import UIKit

enum AlertType {
  case success
  case failure
}

final class AlertView: UIView {

  private let titleLabel = UILabel()
  private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))

  init(type: AlertType, title: String) {
    super.init(frame: .zero)
    setupUI()
    configure(type: type, title: title)
    animateInAndOut()
    self.setContentHuggingPriority(.required, for: .horizontal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    layer.cornerRadius = 16
    clipsToBounds = true
    backgroundColor = .clear
    layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
    layer.borderWidth = 1

    blurView.layer.cornerRadius = 16
    blurView.clipsToBounds = true
    blurView.alpha = 1
    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
    addSubview(blurView)
    blurView.snp.makeConstraints { $0.edges.equalToSuperview() }

    titleLabel.textAlignment = .center
    titleLabel.textColor = .white
    titleLabel.font = .boldSystemFont(ofSize: 16)
    titleLabel.numberOfLines = 1

    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(16)
    }

    self.alpha = 0
  }

  private func configure(type: AlertType, title: String) {
    switch type {
    case .success:
      titleLabel.text = "✅ \(title)"
    case .failure:
      titleLabel.text = "❌ \(title)"
    }
  }

  private func animateInAndOut() {
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.alpha = 0
      }, completion: { _ in
        self.removeFromSuperview()
      })
    }
  }

  static func show(in parent: UIView, type: AlertType, title: String) {
    let alert = AlertView(type: type, title: title)
    parent.addSubview(alert)
    alert.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.equalTo(60)
    }
  }
}
