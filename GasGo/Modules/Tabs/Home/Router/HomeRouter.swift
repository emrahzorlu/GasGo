//
//  HomeRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation
import UIKit

final class HomeRouter {
  weak var view: UIViewController?
  
  static func setupModule() -> HomeViewController {
    let viewController = HomeViewController()
    let presenter = HomePresenter()
    let router = HomeRouter()
    let fetcher = HomeFetcher()
    let directionsFetcher = DirectionsFetcher()
    let interactor = HomeInteractor(fetcher: fetcher, directionsFetcher: directionsFetcher)
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension HomeRouter: HomeWireframe {
  func routeToStationDetail(with placeID: String) {
    let stationDetailViewController = StationDetailRouter.setupModule(placeID: placeID)
    
    view?.navigationController?.pushViewController(stationDetailViewController, animated: true)
  }
  
  func routeToEmergency(with stations: [NearbyPlaceEntity]) {
    let emergencyFuelInputViewController = EmergencyFuelInputRouter.setupModule(with: stations)
    
    view?.navigationController?.pushViewController(emergencyFuelInputViewController, animated: true)
  }
}
