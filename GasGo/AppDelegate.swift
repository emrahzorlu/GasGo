//
//  AppDelegate.swift
//  GasGo
//
//  Created by Burak Eryavuz on 22.03.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window?.rootViewController = LaunchRouter.setupModule()
    window?.makeKeyAndVisible()
    
    return true
  }
}

