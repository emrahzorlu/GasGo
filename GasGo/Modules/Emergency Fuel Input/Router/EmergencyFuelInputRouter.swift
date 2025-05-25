//
//  EmergencyFuelInputRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//  
//

import Foundation
import UIKit

final class EmergencyFuelInputRouter {
  weak var view: UIViewController?
  
  static func setupModule(with stations: [NearbyPlaceEntity]) -> EmergencyFuelInputViewController {
    let viewController = EmergencyFuelInputViewController()
    let presenter = EmergencyFuelInputPresenter()
    let router = EmergencyFuelInputRouter()
    let interactor = EmergencyFuelInputInteractor()
    
    viewController.presenter =  presenter
    
    presenter.stations = stations
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension EmergencyFuelInputRouter: EmergencyFuelInputWireframe {
  func routeToEmergencyStationResult(for value: Double, with stations: [NearbyPlaceEntity]) {
    let emergencyStationResultViewController = EmergencyStationResultRouter.setupModule(for: value, with: stations)
    
    view?.navigationController?.pushViewController(emergencyStationResultViewController, animated: true)
  }
  
  func pop() {
    view?.navigationController?.popViewController(animated: true)
  }
}
