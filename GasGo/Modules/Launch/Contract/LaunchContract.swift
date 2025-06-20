//
//  LaunchContract.swift
//  GasGo
//
//  Created by Burak Eryavuz on 22.03.2025.
//  
//

import Foundation

protocol LaunchView: BaseView {
  
}

protocol LaunchPresentation: AnyObject {
  func viewDidAppear()
}

protocol LaunchInteractorInput: AnyObject {
  
}

protocol LaunchInteractorOutput: AnyObject {
  
}

protocol LaunchWireframe: AnyObject {
  func routeAfterLaunch()
}
