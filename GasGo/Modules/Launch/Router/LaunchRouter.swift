//
//  LaunchRouter.swift
//  GasGo
//
//  Created by Burak Eryavuz on 22.03.2025.
//  
//

import Foundation
import UIKit

final class LaunchRouter {
  weak var view: UIViewController?
  
  static func setupModule() -> LaunchViewController {
    let viewController = UIStoryboard.viewController(fromStoryboard: "Launch") as! LaunchViewController
    let presenter = LaunchPresenter()
    let router = LaunchRouter()
    let interactor = LaunchInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension LaunchRouter: LaunchWireframe {
  
}
