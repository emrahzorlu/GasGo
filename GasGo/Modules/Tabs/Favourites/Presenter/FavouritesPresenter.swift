//
//  FavouritesPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation

final class FavouritesPresenter {
  weak var view: FavouritesView?
  var router: FavouritesWireframe!
  var interactor: FavouritesInteractorInput!
}

extension FavouritesPresenter: FavouritesPresentation {
  func viewDidLoad() {
    
  }
}

extension FavouritesPresenter: FavouritesInteractorOutput {
  
}
