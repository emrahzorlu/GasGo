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
  
  private var currentIndex: Int = 0
}

extension OnboardingPresenter: OnboardingPresentation {
  func viewDidLoad() {
    view?.setupUI()
  }
  
  func continueButtonTapped() {
    let nextIndex = currentIndex + 1
    if nextIndex < OnboardingType.allCases.count {
      currentIndex = nextIndex
      let indexPath = IndexPath(item: currentIndex, section: 0)
      view?.scrollToItem(at: indexPath)
      
      view?.updatePageControl(for: currentIndex)
    } else {
      router.routeToStationSelection()
    }
  }
}

extension OnboardingPresenter: OnboardingInteractorOutput {
  
}
