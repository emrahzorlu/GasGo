//
//  OnboardingContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 11.05.2025.
//  
//

import Foundation

protocol OnboardingView: BaseView {
  func setupUI()
  
  func scrollToItem(at indexPath: IndexPath)
  func updatePageControl(for page: Int)
}

protocol OnboardingPresentation: AnyObject {
  func viewDidLoad()
  
  func continueButtonTapped()
}

protocol OnboardingInteractorInput: AnyObject {
  
}

protocol OnboardingInteractorOutput: AnyObject {
  
}

protocol OnboardingWireframe: AnyObject {
  func routeToStationSelection()
}
