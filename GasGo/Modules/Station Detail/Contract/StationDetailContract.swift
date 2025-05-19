//
//  StationDetailContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//  
//

import Foundation

protocol StationDetailView: BaseView {
  func setupUI()
}

protocol StationDetailPresentation: AnyObject {
  func viewDidLoad()
}

protocol StationDetailInteractorInput: AnyObject {
  func getDetails()
}

protocol StationDetailInteractorOutput: AnyObject {
  func gotDetails(with details: [PlaceDetailEntity])
}

protocol StationDetailWireframe: AnyObject {
  
}
