//
//  EmergencyStationResultContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//  
//

import Foundation
import CoreLocation

protocol EmergencyStationResultView: BaseView {
  func setupUI()
  
  func displaySections(_ sections: [StationSection])
}

protocol EmergencyStationResultPresentation: AnyObject {
  func viewDidLoad()
  
  func didSelectStation(with placeID: String)
  
  func backButtonTapped()
}

protocol EmergencyStationResultInteractorInput: AnyObject {

}

protocol EmergencyStationResultInteractorOutput: AnyObject {

}

protocol EmergencyStationResultWireframe: AnyObject {
  func navigateToStationDetail(with placeID: String)
  
  func pop()
}
