//
//  EmergencyFuelInputViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//
//

import Foundation
import UIKit

final class EmergencyFuelInputViewController: BaseViewController {
  private let questionLabel: UILabel = {
    let label = UILabel()
    label.text = "Aracında kaç kilometre gidebileceğin benzinin kaldı ?"
    label.font = Styles.font(family: .outfit, weight: .semiBold, size: 40)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  private let slider: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 0
    slider.maximumValue = 10
    slider.value = 0
    return slider
  }()
  
  private let valueLabel: UILabel = {
    let label = UILabel()
    label.text = "0 km"
    label.font = Styles.font(family: .outfit, weight: .bold, size: 32)
    label.textAlignment = .center
    return label
  }()
  
  private let continueButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Devam", for: .normal)
    button.isEnabled = false
    button.backgroundColor = .black
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 26
    button.titleLabel?.font = Styles.font(family: .outfit, weight: .semiBold, size: 28)
    return button
  }()
  
  var presenter: EmergencyFuelInputPresentation!
  
  // MARK: Lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    tabBarController?.tabBar.isHidden = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: backImage,
      style: .plain,
      target: self,
      action: #selector(backButtonTapped)
    )
    navigationItem.leftBarButtonItem?.tintColor = .black
    
    presenter.viewDidLoad()
  }
  
  @objc private func sliderValueChanged(_ sender: UISlider) {
    let rawValue = Double(sender.value)
    let formattedValue = String(format: "%.1f", rawValue)
    valueLabel.text = "\(formattedValue) km"
    let enabled = rawValue > 0
    continueButton.isEnabled = enabled
    continueButton.backgroundColor = enabled ? UIColor.black : UIColor.black.withAlphaComponent(0.5)
  }
  
  @objc private func continueButtonTapped() {
    generateSelectionFeedback()
    
    let value = Double(round(slider.value * 10) / 10)
    
    presenter.continueButtonTapped(km: value)
  }
  
  @objc private func backButtonTapped() {
    generateSelectionFeedback()
    
    navigationController?.popViewController(animated: true)
  }
}

extension EmergencyFuelInputViewController: EmergencyFuelInputView {
  func setupUI() {
    let gradientColors = [
      UIColor(red: 255/255, green: 94/255, blue: 98/255, alpha: 1.0),
      UIColor(red: 255/255, green: 175/255, blue: 64/255, alpha: 1.0)
    ]
    view.applyGradient(colors: gradientColors)
    
    setupQuestionLabel()
    setupSlider()
    setupValueLabel()
    setupContinueButton()
    setupConstraints()
  }
  
  private func setupQuestionLabel() {
    questionLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(questionLabel)
  }
  
  private func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      image.draw(in: CGRect(origin: .zero, size: size))
    }
  }
  
  private func setupSlider() {
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.minimumTrackTintColor = UIColor(red: 180/255, green: 0/255, blue: 40/255, alpha: 1.0)
    slider.maximumTrackTintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
    
    if let fuelImage = UIImage(systemName: "drop.fill") {
      let resized = resizeImage(fuelImage, to: CGSize(width: 24, height: 30))
      slider.setThumbImage(resized.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    view.addSubview(slider)
    slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
  }
  
  private func setupValueLabel() {
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(valueLabel)
  }
  
  private func setupContinueButton() {
    continueButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(continueButton)
    continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    questionLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(160)
      $0.left.right.equalToSuperview().inset(16)
    }
    slider.snp.makeConstraints {
      $0.top.equalTo(questionLabel.snp.bottom).offset(32)
      $0.left.right.equalToSuperview().inset(40)
    }
    valueLabel.snp.makeConstraints {
      $0.top.equalTo(slider.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    continueButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(58)
    }
  }
}
