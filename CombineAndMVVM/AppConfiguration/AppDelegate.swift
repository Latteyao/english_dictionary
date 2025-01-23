//
//  AppDelegate.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/6/26.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate{


  var window: UIWindow?
  private var cancellables = Set<AnyCancellable>()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Set navigation bar delegate
//    UINavigationBar.appearance().delegate = self
    
    // 創建 UIWindow 並設定初始畫面
//            window = UIWindow(frame: UIScreen.main.bounds)
//            let launchViewController = LaunchViewController()
//            window?.rootViewController = launchViewController
//            window?.makeKeyAndVisible()
//
//    // 訂閱啟動完成事件
//           launchViewController.launchCompletion
//               .sink { [weak self] in
//                   self?.navigateToMainView()
//               }
//               .store(in: &cancellables)
    
    // Override point for customization after application launch.
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

extension AppDelegate:UINavigationBarDelegate{
  // MARK: - UINavigationBarDelegate
  func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
//    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    return true
  }
}


extension AppDelegate{
  
  private func navigateToMainView() {
          // 設置主界面
          let tabBarController = TabBarController()
          guard let window = window else { return }
          UIView.transition(
              with: window,
              duration: 0.7,
              options: .transitionCrossDissolve,
              animations: {
                  self.window?.rootViewController = tabBarController
              },
              completion: nil
          )
      }
}
