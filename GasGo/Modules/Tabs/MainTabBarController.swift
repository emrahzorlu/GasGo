//
//  MainTabBarController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
  }
  
  private func setupTabs() {
    let homeVC = HomeRouter.setupModule()
    homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    
    let favVC = FavouritesRouter.setupModule()
    favVC.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    
    let settingsVC = SettingsRouter.setupModule()
    settingsVC.tabBarItem = UITabBarItem(title: "Ayarlar", image: UIImage(systemName: "person"), tag: 2)
    
    viewControllers = [
      UINavigationController(rootViewController: homeVC),
      UINavigationController(rootViewController: favVC),
      UINavigationController(rootViewController: settingsVC)
    ]
  }
}
