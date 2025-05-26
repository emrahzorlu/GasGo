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
    let viewController = LaunchViewController()
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
  func routeAfterLaunch() {
    if Config.didFinishOnboarding {
      let mainTabbarController = MainTabBarController()
      mainTabbarController.modalPresentationStyle = .fullScreen
      
      view?.present(mainTabbarController, animated: true)
    } else {
      let onboardingViewController = OnboardingRouter.setupModule()
      onboardingViewController.modalPresentationStyle = .fullScreen
      
      view?.present(onboardingViewController, animated: true)
    }
  }
}
