//
//  EmergencyStationResultRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 23.05.2025.
//
//

import Foundation
import UIKit

final class EmergencyStationResultRouter {
  weak var view: UIViewController?
  
  static func setupModule(for value: Double, with stations: [NearbyPlaceEntity]) -> EmergencyStationResultViewController {
    let viewController = EmergencyStationResultViewController()
    let presenter = EmergencyStationResultPresenter()
    let router = EmergencyStationResultRouter()
    let fetcher = HomeFetcher()
    let interactor = EmergencyStationResultInteractor()
    
    viewController.presenter =  presenter
    
    presenter.stations = stations
    presenter.value = value
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension EmergencyStationResultRouter: EmergencyStationResultWireframe {
  func navigateToStationDetail(with placeID: String) {
    let detailVC = StationDetailRouter.setupModule(placeID: placeID)
    
    view?.navigationController?.pushViewController(detailVC, animated: true)
  }
}
