//
//  StationDetailPresenter.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//
//

import Foundation

final class StationDetailPresenter {
  weak var view: StationDetailView?
  var router: StationDetailWireframe!
  var interactor: StationDetailInteractorInput!
}

extension StationDetailPresenter: StationDetailPresentation {
  func viewDidLoad() {
    interactor.getDetails()
    
    view?.setupUI()
  }
}

extension StationDetailPresenter: StationDetailInteractorOutput {
  func gotDetails(with details: [PlaceDetailEntity]) {
    
  }
}
