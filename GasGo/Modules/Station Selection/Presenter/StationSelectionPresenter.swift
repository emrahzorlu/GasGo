//
//  StationSelectionPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 14.05.2025.
//  
//

import Foundation

final class StationSelectionPresenter {
  weak var view: StationSelectionView?
  var router: StationSelectionWireframe!
  var interactor: StationSelectionInteractorInput!
  var isFromSettings: Bool = false
}

extension StationSelectionPresenter: StationSelectionPresentation {
  func viewDidLoad() {
    view?.setupUI()
  }
  
  func saveButtonTapped() {
    if isFromSettings {
      router.dismiss()
    } else {
      router.routeToHome()
    }
  }
}

extension StationSelectionPresenter: StationSelectionInteractorOutput {
  
}
