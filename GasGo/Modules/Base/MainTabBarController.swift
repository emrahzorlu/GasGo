//
//  MainTabBarController.swift
//  GasGo
//
//  Created by Emrah Zorlu on 17.05.2025.
//

import UIKit
import SnapKit

final class CustomTabBar: UITabBar {
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    var size = super.sizeThatFits(size)
    size.height = 90
    return size
  }
}

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setValue(CustomTabBar(), forKey: "tabBar")
    
    let topBorder = UIView()
    topBorder.backgroundColor = UIColor.white.withAlphaComponent(0.15)
    tabBar.addSubview(topBorder)
    topBorder.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    tabBar.tintColor = Styles.Color.buttercupYellow
    tabBar.unselectedItemTintColor = Styles.Color.buttercupYellow.withAlphaComponent(0.7)
    
    let tabBarBackgroundOverlay = UIView()
    tabBarBackgroundOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    tabBarBackgroundOverlay.isUserInteractionEnabled = false
    tabBar.viewWithTag(999)?.removeFromSuperview()
    tabBarBackgroundOverlay.tag = 999
    tabBar.insertSubview(tabBarBackgroundOverlay, at: 0)
    tabBarBackgroundOverlay.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    setupTabs()
  }
  
  private func setupTabs() {
    let homeVC = HomeRouter.setupModule()
    homeVC.tabBarItem = UITabBarItem(
      title: "Ana Sayfa",
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
