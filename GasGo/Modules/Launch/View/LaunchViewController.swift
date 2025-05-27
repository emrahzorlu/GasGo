//
//  LaunchViewController.swift
//  GasGo
//
//  Created by Burak Eryavuz on 22.03.2025.
//
//

import UIKit
import SnapKit
import CoreLocation

final class LaunchViewController: BaseViewController {
  private let imageView = UIImageView(image: UIImage(named: "GasGoIcon"))
  var presenter: LaunchPresentation!
  private let locationManager = CLLocationManager()
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    view.addSubview(imageView)
    locationManager.requestWhenInUseAuthorization()

    imageView.snp.makeConstraints {
      $0.width.height.equalTo(300)
      $0.center.equalToSuperview()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    presenter.viewDidAppear()
  }
}

extension LaunchViewController: LaunchView {
  
}
