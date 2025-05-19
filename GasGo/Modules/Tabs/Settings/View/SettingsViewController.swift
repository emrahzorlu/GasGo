//
//  SettingsViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//
//

import UIKit
import SnapKit

final class SettingsViewController: BaseViewController {
  private let titleLabel = UILabel()
  private let tableView = UITableView(frame: .zero, style: .insetGrouped)
  private let settingGroups: [SettingsGroup] = [.appFeedback, .legalInfo]
  
  var presenter: SettingsPresentation!
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension SettingsViewController: SettingsView {
  func setupUI() {
    view.applyGradient(colors: [Styles.Color.gableGreen, Styles.Color.sanJuanBlue])
    
    setupTitle()
    setupTableView()
    setupConstarints()
  }
  
  func setupTitle() {
    view.addSubview(titleLabel)
    
    titleLabel.attributedText = NSAttributedString(string: "Ayarlar", attributes: [
      .font: Styles.font(family: .outfit, weight: .bold, size: 42),
      .foregroundColor: UIColor.white
    ])
  }
  
  func setupTableView() {
    view.addSubview(tableView)
    
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: TableViewCellIdentifier.settingsTableViewCell.rawValue)
  }
  
  func setupConstarints() {
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
    }
    tableView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return settingGroups.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingGroups[section].settingTypes.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.settingsTableViewCell.rawValue, for: indexPath) as? SettingsTableViewCell else {
      return UITableViewCell()
    }
    
    let type = settingGroups[indexPath.section].settingTypes[indexPath.row]
    cell.configure(with: type)
    cell.accessoryType = .disclosureIndicator
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let container = UIView()
    container.backgroundColor = .clear
    let label = UILabel()
    label.font = Styles.font(family: .outfit, weight: .semiBold, size: 22)
    label.textColor = .white
    let title: String
    switch settingGroups[section] {
    case .appFeedback: title = "Uygulama Geri Bildirimleri"
    case .legalInfo:   title = "Yasal Bilgiler"
    }
    
    label.text = title
    
    container.addSubview(label)
    
    label.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalToSuperview().offset(8)
      make.bottom.equalToSuperview().offset(-4)
    }
    return container
  }
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//    let selected = settingGroups[indexPath.section].settingTypes[indexPath.row]
//    presenter.didSelect(setting: selected)
//  }
}
