//
//  AppDelegate.swift
//  GasGo
//
//  Created by Burak Eryavuz on 22.03.2025.
//

import UIKit
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var orientationLock = UIInterfaceOrientationMask.portrait

  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
      return self.orientationLock
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    
    GMSServices.provideAPIKey(Config.apiKey)
    GMSPlacesClient.provideAPIKey(Config.apiKey)
    window?.rootViewController = LaunchRouter.setupModule()
    window?.makeKeyAndVisible()
    
    return true
  }
}

