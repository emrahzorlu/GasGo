//
//  EmergencyFuelInputContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//  
//

import Foundation

protocol EmergencyFuelInputView: BaseView {
  func setupUI()
}

protocol EmergencyFuelInputPresentation: AnyObject {
  func viewDidLoad()
  
  func continueButtonTapped(km: Double)
}

protocol EmergencyFuelInputInteractorInput: AnyObject {
  
}

protocol EmergencyFuelInputInteractorOutput: AnyObject {
  
}

protocol EmergencyFuelInputWireframe: AnyObject {
  func routeToEmergencyStationResult(for value: Double, with stations: [NearbyPlaceEntity])
}
