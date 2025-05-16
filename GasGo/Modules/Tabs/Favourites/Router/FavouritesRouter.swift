//
//  FavouritesRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation
import UIKit

final class FavouritesRouter {
  weak var view: UIViewController?
  
  static func setupModule() -> FavouritesViewController {
    let viewController = FavouritesViewController()
    let presenter = FavouritesPresenter()
    let router = FavouritesRouter()
    let interactor = FavouritesInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension FavouritesRouter: FavouritesWireframe {
  
}
