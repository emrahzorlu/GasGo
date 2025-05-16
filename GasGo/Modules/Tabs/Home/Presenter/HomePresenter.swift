//
//  HomePresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation

final class HomePresenter {
  weak var view: HomeView?
  var router: HomeWireframe!
  var interactor: HomeInteractorInput!
}

extension HomePresenter: HomePresentation {
  func viewDidLoad() {
    
  }
}

extension HomePresenter: HomeInteractorOutput {
  
}
