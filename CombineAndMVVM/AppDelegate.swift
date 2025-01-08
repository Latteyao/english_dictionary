//
//  AppDelegate.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/6/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate{


  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    let backImage = UIImage(systemName: "arrowshape.backward.fill")?.withRenderingMode(.alwaysOriginal)
//    let backIndicatorImage = backImage?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
//    
//    UINavigationBar.appearance().backIndicatorImage = backIndicatorImage
//    UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIndicatorImage
//    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
////
//    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
    
    // Set navigation bar delegate
    UINavigationBar.appearance().delegate = self
    
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

