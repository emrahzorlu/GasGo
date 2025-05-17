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

    tabBar.tintColor = UIColor(hex: "#F5A623")
    tabBar.unselectedItemTintColor = UIColor(hex: "#F5A623").withAlphaComponent(0.7)
    setupTabs()
  }
  
  private func setupTabs() {
    let homeVC = HomeRouter.setupModule()
    homeVC.tabBarItem = UITabBarItem(
      title: "Home",
      image: UIImage(systemName: "house"),
      selectedImage: UIImage(systemName: "house.fill")
    )
    
    let favVC = FavouritesRouter.setupModule()
    favVC.tabBarItem = UITabBarItem(
      title: "Favoriler",
      image: UIImage(systemName: "heart"),
      selectedImage: UIImage(systemName: "heart.fill")
    )
    
    let settingsVC = SettingsRouter.setupModule()
    settingsVC.tabBarItem = UITabBarItem(
      title: "Ayarlar",
      image: UIImage(systemName: "gearshape"),
      selectedImage: UIImage(systemName: "gearshape.fill")
    )
    
    viewControllers = [
      UINavigationController(rootViewController: homeVC),
      UINavigationController(rootViewController: favVC),
      UINavigationController(rootViewController: settingsVC)
    ]
  }
}
