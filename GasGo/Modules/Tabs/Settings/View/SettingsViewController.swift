//
//  SettingsViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation
import UIKit

final class SettingsViewController: BaseViewController {
  var presenter: SettingsPresentation!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension SettingsViewController: SettingsView {
  
}
