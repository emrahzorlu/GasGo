//
//  StationSelectionViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 14.05.2025.
//
//

import Foundation
import UIKit
import SnapKit

final class StationSelectionViewController: BaseViewController {
  private let imageView = UIImageView(image: Styles.Image.phoneSelect)
  private let titleLabel = UILabel()
  private let favouriteStackView = UIStackView()
  private let favouriteLabel = UILabel()
  private let favouritePickerView = UIPickerView()
  private let firstAlternativeStackView = UIStackView()
  private let firstAlternativeLabel = UILabel()
  private let firstAlternativePickerView = UIPickerView()
  private let secondAlternativeStackView = UIStackView()
  private let secondAlternativeLabel = UILabel()
  private let secondAlternativePickerView = UIPickerView()
  private let selectionStackView = UIStackView()
  private let saveButton = UIButton()
  
  var presenter: StationSelectionPresentation!
  
  let fuelBrands = [
    "Shell",
    "Petrol Ofisi",
    "BP",
    "TotalEnergies",
    "Aytemiz",
    "Milangaz",
    "Lukoil",
    "Sunpet",
    "Kadoil",
    "TP (Türkiye Petrolleri)",
    "Alpet",
    "Gulf",
    "Diğer"
  ]
  
  var selectedBrand1: String?
  var selectedBrand2: String?
  var selectedBrand3: String?
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
    
    // Set default brand selections so initial pickers differ
    setInitialBrandSelections(
      favorite: fuelBrands[0],
      alternative1: fuelBrands[1],
      alternative2: fuelBrands[2]
    )
  }
  
  func setInitialBrandSelections(favorite: String, alternative1: String, alternative2: String) {
    selectedBrand1 = favorite
    selectedBrand2 = alternative1
    selectedBrand3 = alternative2
    
    favouritePickerView.reloadAllComponents()
    firstAlternativePickerView.reloadAllComponents()
    secondAlternativePickerView.reloadAllComponents()
    
    if let index1 = availableBrands(for: favouritePickerView).firstIndex(of: selectedBrand1 ?? "") {
      favouritePickerView.selectRow(index1, inComponent: 0, animated: false)
    }
    if let index2 = availableBrands(for: firstAlternativePickerView).firstIndex(of: selectedBrand2 ?? "") {
      firstAlternativePickerView.selectRow(index2, inComponent: 0, animated: false)
    }
    if let index3 = availableBrands(for: secondAlternativePickerView).firstIndex(of: selectedBrand3 ?? "") {
      secondAlternativePickerView.selectRow(index3, inComponent: 0, animated: false)
    }
  }
  
  @objc private func saveButtonTapped() {
    Config.selectedFavoriteBrand = selectedBrand1
    Config.selectedAlternativeBrand1 = selectedBrand2
    Config.selectedAlternativeBrand2 = selectedBrand3
    
    presenter.saveButtonTapped()
    print("Saved to Config:")
    print("Favorite: \(Config.selectedFavoriteBrand ?? "nil")")
    print("Alternative 1: \(Config.selectedAlternativeBrand1 ?? "nil")")
    print("Alternative 2: \(Config.selectedAlternativeBrand2 ?? "nil")")
  }
}

extension StationSelectionViewController: StationSelectionView {
  func setupUI() {
    view.applyGradient(colors: [Styles.Color.darkBlue, UIColor.white])
    favouritePickerView.delegate = self
    favouritePickerView.dataSource = self
    firstAlternativePickerView.delegate = self
    firstAlternativePickerView.dataSource = self
    secondAlternativePickerView.delegate = self
    secondAlternativePickerView.dataSource = self
    
    favouriteStackView.axis = .horizontal
    favouriteStackView.spacing = 8
    
    setupImageView()
    setupTitleLabel()
    setupFavouriteLabel()
    setupFavouritePickerView()
    setupFirstAlternativeLabel()
    setupFirstAlternativePickerView()
    setupSecondAlternativeLabel()
    setupSecondAlternativePickerView()
    setupSaveButton()
    
    view.addSubview(selectionStackView)
    selectionStackView.axis = .vertical
    selectionStackView.spacing = 16
    selectionStackView.alignment = .fill
    selectionStackView.distribution = .fillEqually
    
    selectionStackView.addArrangedSubview(favouriteStackView)
    selectionStackView.addArrangedSubview(firstAlternativeStackView)
    selectionStackView.addArrangedSubview(secondAlternativeStackView)
    
    setupConstraints()
    
    [favouriteStackView, firstAlternativeStackView, secondAlternativeStackView].forEach {
      $0.axis = .horizontal
      $0.spacing = 8
      $0.alignment = .fill
      $0.distribution = .fill
    }
  }
  
  func setupConstraints() {
    imageView.snp.makeConstraints { make in
      make.height.equalToSuperview().multipliedBy(0.35)
      make.top.equalToSuperview().offset(24)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(4)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    saveButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(62)
    }
    
    selectionStackView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalTo(saveButton.snp.top).offset(-24)
    }
  }
  
  func setupImageView() {
    view.addSubview(imageView)
    
    imageView.contentMode = .scaleAspectFit
  }
  
  func setupTitleLabel() {
    view.addSubview(titleLabel)
    
    titleLabel.attributedText = NSAttributedString(string: "Şimdi favori istasyonunu ve iki alternatik istasyonunu seçip yola çıkalım!", attributes: [
      .font: Styles.font(family: .outfit, weight: .medium, size: 22),
      .foregroundColor: UIColor.white
    ])
    
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
  }
  
  func setupFavouriteLabel() {
    favouriteStackView.addArrangedSubview(favouriteLabel)
    
    favouriteLabel.attributedText = NSAttributedString(string: "Favori:", attributes: [
      .font: Styles.font(family: .outfit, weight: .medium, size: 20),
      .foregroundColor: UIColor.white
    ])
    favouriteLabel.setContentHuggingPriority(.required, for: .horizontal)
    favouriteLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  func setupFavouritePickerView() {
    view.addSubview(favouriteStackView)
    favouriteStackView.addArrangedSubview(favouritePickerView)
  }
  
  func setupFirstAlternativeLabel() {
    firstAlternativeStackView.addArrangedSubview(firstAlternativeLabel)
    
    firstAlternativeLabel.attributedText = NSAttributedString(string: "1. Alternatif:", attributes: [
      .font: Styles.font(family: .outfit, weight: .medium, size: 20),
      .foregroundColor: UIColor.white
    ])
    firstAlternativeLabel.setContentHuggingPriority(.required, for: .horizontal)
    firstAlternativeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  func setupFirstAlternativePickerView() {
    view.addSubview(firstAlternativeStackView)
    firstAlternativeStackView.addArrangedSubview(firstAlternativePickerView)
    
    firstAlternativePickerView.delegate = self
    firstAlternativePickerView.dataSource = self
    
    firstAlternativeStackView.axis = .horizontal
    firstAlternativeStackView.spacing = 8
  }
  
  func setupSecondAlternativeLabel() {
    secondAlternativeStackView.addArrangedSubview(secondAlternativeLabel)
    
    secondAlternativeLabel.attributedText = NSAttributedString(string: "2. Alternatif:", attributes: [
      .font: Styles.font(family: .outfit, weight: .medium, size: 20),
      .foregroundColor: UIColor.white
    ])
    secondAlternativeLabel.setContentHuggingPriority(.required, for: .horizontal)
    secondAlternativeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  
  func setupSecondAlternativePickerView() {
    view.addSubview(secondAlternativeStackView)
    secondAlternativeStackView.addArrangedSubview(secondAlternativePickerView)
    
    secondAlternativePickerView.delegate = self
    secondAlternativePickerView.dataSource = self
    
    secondAlternativeStackView.axis = .horizontal
    secondAlternativeStackView.spacing = 8
  }
  
  func setupSaveButton() {
    view.addSubview(saveButton)
    
    let saveButtonAttributedTitle = NSAttributedString(string: "Kaydet", attributes: [
      .font: Styles.font(family: .outfit, weight: .semiBold, size: 22)
    ])
    
    saveButton.tintColor = .white
    saveButton.backgroundColor = .black
    saveButton.setAttributedTitle(saveButtonAttributedTitle, for: .normal)
    saveButton.layer.cornerRadius = 26
    saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
  }
}

extension StationSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return fuelBrands.filter { brand in
      if pickerView == favouritePickerView {
        return brand != selectedBrand2 && brand != selectedBrand3
      } else if pickerView == firstAlternativePickerView {
        return brand != selectedBrand1 && brand != selectedBrand3
      } else {
        return brand != selectedBrand1 && brand != selectedBrand2
      }
    }.count
  }
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let filtered = availableBrands(for: pickerView)
    let title = filtered[row]
    let attributes: [NSAttributedString.Key: Any] = [
      .font: Styles.font(family: .outfit, weight: .medium, size: 16),
      .foregroundColor: UIColor.black
    ]
    
    return NSAttributedString(string: title, attributes: attributes)
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let filtered = availableBrands(for: pickerView)
    let selected = filtered[row]
    
    if pickerView == favouritePickerView {
      selectedBrand1 = selected
    } else if pickerView == firstAlternativePickerView {
      selectedBrand2 = selected
    } else {
      selectedBrand3 = selected
    }
    
    favouritePickerView.reloadAllComponents()
    firstAlternativePickerView.reloadAllComponents()
    secondAlternativePickerView.reloadAllComponents()
    
    if let index1 = availableBrands(for: favouritePickerView).firstIndex(of: selectedBrand1 ?? "") {
      favouritePickerView.selectRow(index1, inComponent: 0, animated: false)
    }
    if let index2 = availableBrands(for: firstAlternativePickerView).firstIndex(of: selectedBrand2 ?? "") {
      firstAlternativePickerView.selectRow(index2, inComponent: 0, animated: false);
    }
    if let index3 = availableBrands(for: secondAlternativePickerView).firstIndex(of: selectedBrand3 ?? "") {
      secondAlternativePickerView.selectRow(index3, inComponent: 0, animated: false);
    }
  }
  
  private func availableBrands(for pickerView: UIPickerView) -> [String] {
    return fuelBrands.filter { brand in
      if pickerView == favouritePickerView {
        return brand != selectedBrand2 && brand != selectedBrand3
      } else if pickerView == firstAlternativePickerView {
        return brand != selectedBrand1 && brand != selectedBrand3
      } else {
        return brand != selectedBrand1 && brand != selectedBrand2
      }
    }
  }
}
