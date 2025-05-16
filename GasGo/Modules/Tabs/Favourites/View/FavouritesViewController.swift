//
//  FavouritesViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//  
//

import Foundation
import UIKit

final class FavouritesViewController: BaseViewController {
  var presenter: FavouritesPresentation!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension FavouritesViewController: FavouritesView {
  
}
