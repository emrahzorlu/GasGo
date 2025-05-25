//
//  EmergencyFuelInputPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//  
//

import Foundation

final class EmergencyFuelInputPresenter {
  weak var view: EmergencyFuelInputView?
  var router: EmergencyFuelInputWireframe!
  var interactor: EmergencyFuelInputInteractorInput!
  
  var stations: [NearbyPlaceEntity] = []
}

extension EmergencyFuelInputPresenter: EmergencyFuelInputPresentation {
  func viewDidLoad() {
    view?.setupUI()
  }
  
  func continueButtonTapped(km: Double) {
    router.routeToEmergencyStationResult(for: km, with: stations)
  }
  
  func backButtonTapped() {
    router.pop()
  }
}

extension EmergencyFuelInputPresenter: EmergencyFuelInputInteractorOutput {
  
}
