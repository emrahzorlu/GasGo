//
//  LaunchViewController.swift
//  GasGo
//
//  Created by Burak Eryavuz on 22.03.2025.
//  
//

import Foundation
import UIKit

final class LaunchViewController: BaseViewController {
  var presenter: LaunchPresentation!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension LaunchViewController: LaunchView {
  
}
