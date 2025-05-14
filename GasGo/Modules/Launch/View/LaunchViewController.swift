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
    view.backgroundColor = .orange
    
    presenter.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    let vc = OnboardingRouter.setupModule()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }
}

extension LaunchViewController: LaunchView {
  
}
