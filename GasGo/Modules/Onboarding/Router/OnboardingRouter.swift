//
//  OnboardingRouter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 11.05.2025.
//  
//

import Foundation
import UIKit

final class OnboardingRouter {
  weak var view: UIViewController?
  
  static func setupModule() -> OnboardingViewController {
    let viewController = OnboardingViewController()
    let presenter = OnboardingPresenter()
    let router = OnboardingRouter()
    let interactor = OnboardingInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
}

extension OnboardingRouter: OnboardingWireframe {
  func routeToStationSelection() {
    let stationSelectionViewController = StationSelectionRouter.setupModule()
    
    stationSelectionViewController.modalPresentationStyle = .fullScreen
    
    view?.present(stationSelectionViewController, animated: true)
  }
}
