//
//  StationSelectionContract.swift
//  GasGo
//
//  Created by Emrah Zorlu on 14.05.2025.
//  
//

import Foundation

protocol StationSelectionView: BaseView {
  func setupUI()
}

protocol StationSelectionPresentation: AnyObject {
  func viewDidLoad()
  func saveButtonTapped()
}

protocol StationSelectionInteractorInput: AnyObject {
  
}

protocol StationSelectionInteractorOutput: AnyObject {
  
}

protocol StationSelectionWireframe: AnyObject {
  func routeToHome()
  
  func dismiss()
}
