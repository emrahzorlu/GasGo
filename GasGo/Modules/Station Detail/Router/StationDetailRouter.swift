//
//  StationDetailRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//  
//

import Foundation
import UIKit

final class StationDetailRouter {
  weak var view: UIViewController?
  
  static func setupModule(placeID: String) -> StationDetailViewController {
    let viewController = StationDetailViewController()
    let presenter = StationDetailPresenter()
    let router = StationDetailRouter()
    let fetcher = StationDetailFetcher()
    let directionsFetcher = DirectionsFetcher()
    let interactor = StationDetailInteractor(fetcher: fetcher, directionsFetcher: directionsFetcher, placeId: placeID)
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension StationDetailRouter: StationDetailWireframe {
  func pop() {
    view?.navigationController?.popViewController(animated: true)
  }
}
