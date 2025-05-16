//
//  StationSelectionRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 14.05.2025.
//  
//

import Foundation
import UIKit

final class StationSelectionRouter {
  weak var view: UIViewController?
  
  static func setupModule() -> StationSelectionViewController {
    let viewController = StationSelectionViewController()
    let presenter = StationSelectionPresenter()
    let router = StationSelectionRouter()
    let interactor = StationSelectionInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension StationSelectionRouter: StationSelectionWireframe {
  
}
