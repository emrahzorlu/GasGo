//
//  SettingsPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation

final class SettingsPresenter {
  weak var view: SettingsView?
  var router: SettingsWireframe!
  var interactor: SettingsInteractorInput!
}

extension SettingsPresenter: SettingsPresentation {
  func viewDidLoad() {
    
  }
}

extension SettingsPresenter: SettingsInteractorOutput {
  
}
