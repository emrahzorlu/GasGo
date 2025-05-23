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
    view?.setupUI()
  }
  
  func handleSettingSelection(setting: SettingsType) {
    switch setting {
    case .rateUs:
      return
    case .feedback:
      return
    case .share:
      return
    case .privacyPolicy:
      return
    case .terms:
      return
    case .chooseStations:
      router.routeToStationSelection()
    }
  }
}

extension SettingsPresenter: SettingsInteractorOutput {
  
}
