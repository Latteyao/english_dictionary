//
//  TabBarController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/9.
//

import Foundation
import UIKit

// 自訂的 TabBarController，管理應用的主要頁籤
class TabBarController: UITabBarController, UITabBarControllerDelegate {
  // MARK: - Properties
 
  // 初始化 DataViewModel，負責處理主要數據相關的邏輯
  private let dataViewModel = DataViewModel()
  
  // 初始化 BookmarkViewModel，負責處理書籤相關的邏輯
  private let bookmarkViewModel = BookmarkViewModel()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBarUI()
    let homeVC = MainViewController(viewModel: dataViewModel, bookmarkViewModel: bookmarkViewModel)
    let bookmarkVC = BookmarkViewController(viewModel: dataViewModel, bookmarkViewModel: bookmarkViewModel)
    let firstNavigationController = UINavigationController(rootViewController: homeVC)
    let bookmarkNavigationController = UINavigationController(rootViewController: bookmarkVC)
    
    firstNavigationController.tabBarItem = UITabBarItem(title: "dictionary", image: UIImage(systemName: "text.book.closed"), tag: 0)
    bookmarkNavigationController.tabBarItem = UITabBarItem(title: "Bookmark", image: UIImage(systemName: "bookmark.fill"), tag: 1)
    
    viewControllers = [firstNavigationController, bookmarkNavigationController]
    delegate = self // 设置代理
  }
}

// MARK: - UI Configuration

extension TabBarController {
  // 自訂 Tab Bar 的外觀樣式
  private func setupTabBarUI() {
    tabBar.backgroundColor = .systemGray6
    tabBar.tintColor = .brown
    tabBar.layer.cornerRadius = 10
    tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    tabBar.clipsToBounds = true
    tabBar.layer.masksToBounds = false
    tabBar.layer.shadowColor = UIColor.black.cgColor
    tabBar.layer.shadowOpacity = 0.2 // 陰影要這樣畫，不然會太耗效能
    tabBar.layer.shadowPath = UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: 10.0).cgPath
  }
  
}
// MARK: - Tabbar
extension TabBarController{
  // 處理用戶切換 Tab 時的行為
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    // 當選擇書籤 Tab 時，重新載入書籤數據
    if let navigationController = viewControllers?[1] as? UINavigationController,
           let bookmarkVC = navigationController.topViewController as? BookmarkViewController {
            bookmarkVC.bookmarkViewModel.fetchBookmarks() // 重新加载书签数据
            print("Tab switched to BookmarkViewController")
        }
    
  }
}
