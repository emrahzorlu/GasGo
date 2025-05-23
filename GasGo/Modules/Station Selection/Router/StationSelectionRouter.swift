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
  
  static func setupModule(fromSettings: Bool = false) -> StationSelectionViewController {
    let viewController = StationSelectionViewController()
    let presenter = StationSelectionPresenter()
    let router = StationSelectionRouter()
    let interactor = StationSelectionInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    presenter.isFromSettings = fromSettings
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
  
  func dismiss() {
    view?.dismiss(animated: true)
  }
}

extension StationSelectionRouter: StationSelectionWireframe {
  func routeToHome() {
    Config.didFinishOnboarding = true
    
    let tabBar = MainTabBarController()
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
      window.rootViewController = tabBar
      window.makeKeyAndVisible()
    }
  }
}
