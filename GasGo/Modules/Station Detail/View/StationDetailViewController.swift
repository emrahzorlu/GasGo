//
//  StationDetailViewController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 18.05.2025.
//
//

import UIKit
import SnapKit

final class StationDetailViewController: BaseViewController {
  var presenter: StationDetailPresentation!
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension StationDetailViewController: StationDetailView {
  func setupUI() {
    view.applyGradient(colors: [Styles.Color.gableGreen, Styles.Color.sanJuanBlue])
  }
}
