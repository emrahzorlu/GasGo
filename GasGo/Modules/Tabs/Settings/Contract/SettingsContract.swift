//
//  SettingsContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation

protocol SettingsView: BaseView {
  func setupUI()
}

protocol SettingsPresentation: AnyObject {
  func viewDidLoad()
  
  func handleSettingSelection(setting: SettingsType)
}

protocol SettingsInteractorInput: AnyObject {
  
}

protocol SettingsInteractorOutput: AnyObject {
  
}

protocol SettingsWireframe: AnyObject {
  func routeToStationSelection()
}
