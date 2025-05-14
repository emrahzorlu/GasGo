//
//  OnboardingPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 11.05.2025.
//  
//

import Foundation

final class OnboardingPresenter {
  weak var view: OnboardingView?
  var router: OnboardingWireframe!
  var interactor: OnboardingInteractorInput!
}

extension OnboardingPresenter: OnboardingPresentation {
  func viewDidLoad() {
    
  }
}

extension OnboardingPresenter: OnboardingInteractorOutput {
  
}
