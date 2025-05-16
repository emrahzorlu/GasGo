//
//  SettingsRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation
import UIKit

final class SettingsRouter {
  weak var view: UIViewController?
  
  static func setupModule() -> SettingsViewController {
    let viewController = SettingsViewController()
    let presenter = SettingsPresenter()
    let router = SettingsRouter()
    let interactor = SettingsInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension SettingsRouter: SettingsWireframe {
  
}
