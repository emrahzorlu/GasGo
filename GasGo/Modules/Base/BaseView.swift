//
//  BaseView.swift
//  Videa
//
//  Created by Andaç Tercan on 07.11.2024.
//

import UIKit

protocol BaseView: AnyObject {
  func setTitle(_ title: String)
  
  func showLoading()
  func hideLoading()
  
//  func showAlertView(with message: String, alertType: AlertType, in viewController: UIViewController)
  
  func generateNotificationFeedback(with style: UINotificationFeedbackGenerator.FeedbackType)
  func generateImpactFeedback(with style: UIImpactFeedbackGenerator.FeedbackStyle)
  func generateSelectionFeedback()
}

extension BaseView where Self: UIViewController {
  func setTitle(_ title: String) {
    self.title = title
    
    navigationItem.title = title
  }
  
  func showLoading() {
    //    LoadingView.shared.show(with: view)
  }
  
  func hideLoading() {
    //    LoadingView.shared.dismiss()
  }
  
  func generateNotificationFeedback(with style: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator()
      .notificationOccurred(style)
  }
  
  func generateImpactFeedback(with style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style)
      .impactOccurred()
  }
  
  func generateSelectionFeedback() {
    UISelectionFeedbackGenerator()
      .selectionChanged()
  }
}

extension BaseView {
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
