//
//  SceneDelegate.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 06/05/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

   var window: UIWindow?
   static let context = PersistenceController.preview.context

   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let winScene = (scene as? UIWindowScene) else { return }
      
      let walletListVC = WalletListVC()
      
      let currencies = Currencies.shared
      let currencyListVC = CurrencyListVC(currencies: currencies)
      
      let walletListNC = UINavigationController(rootViewController: walletListVC)
      let currencyListNC = UINavigationController(rootViewController: currencyListVC)
      
      let settingsVC = SettingsVC()
      let settingsNC = UINavigationController(rootViewController: settingsVC)

      let tabBarVC = UITabBarController()
      tabBarVC.setViewControllers([walletListNC, currencyListNC, settingsNC], animated: false)
      
      let tabBarItems = tabBarVC.tabBar.items!
      tabBarItems[0].image = UIImage(systemName: "creditcard.fill")
      tabBarItems[0].title = "Wallets"
      tabBarItems[1].image = UIImage(systemName: "dollarsign.circle")
      tabBarItems[1].title = "Currencies"
      tabBarItems[2].image = UIImage(systemName: "gearshape.fill")
      tabBarItems[2].title = "Settings"
      
      window = UIWindow(windowScene: winScene)
      window!.rootViewController = tabBarVC
      window!.makeKeyAndVisible()
   }

   func sceneDidDisconnect(_ scene: UIScene) {
      // Called as the scene is being released by the system.
      // This occurs shortly after the scene enters the background, or when its session is discarded.
      // Release any resources associated with this scene that can be re-created the next time the scene connects.
      // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
   }

   func sceneDidBecomeActive(_ scene: UIScene) {
      // Called when the scene has moved from an inactive state to an active state.
      // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
   }

   func sceneWillResignActive(_ scene: UIScene) {
      // Called when the scene will move from an active state to an inactive state.
      // This may occur due to temporary interruptions (ex. an incoming phone call).
   }

   func sceneWillEnterForeground(_ scene: UIScene) {
      // Called as the scene transitions from the background to the foreground.
      // Use this method to undo the changes made on entering the background.
   }

   func sceneDidEnterBackground(_ scene: UIScene) {
      // Called as the scene transitions from the foreground to the background.
      // Use this method to save data, release shared resources, and store enough scene-specific state information
      // to restore the scene back to its current state.
   }


}

