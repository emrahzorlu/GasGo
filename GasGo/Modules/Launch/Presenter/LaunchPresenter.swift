//
//  LaunchPresenter.swift
//  GasGo
//
//  Created by Burak Eryavuz on 22.03.2025.
//  
//

import Foundation

final class LaunchPresenter {
  weak var view: LaunchView?
  var router: LaunchWireframe!
  var interactor: LaunchInteractorInput!
}

extension LaunchPresenter: LaunchPresentation {
  func viewDidAppear() {
    router.routeAfterLaunch()
  }
}

extension LaunchPresenter: LaunchInteractorOutput {
  
}
