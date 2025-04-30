//
//  BaseViewController.swift
//  Videa
//
//  Created by Andaç Tercan on 07.11.2024.
//

import UIKit

class BaseViewController: UIViewController {
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  func getWindow() -> UIWindow! {
    if #available(iOS 13.0, *) {
      let keyWindow = UIApplication.shared.connectedScenes
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }.first

      return keyWindow
    }

    return (UIApplication.shared.delegate as! AppDelegate).window
  }
}

// MARK: - UI Gesture Recognizer Delegate
extension BaseViewController: UIGestureRecognizerDelegate {
  var gestureRecognizerShouldReceive: Bool {
    return false
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return gestureRecognizerShouldReceive
  }
}
