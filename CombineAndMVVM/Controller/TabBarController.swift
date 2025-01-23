//
//  TabBarController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/9.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
  // MARK: - Properties
//  private let themeViewModel = ThemeViewModel()
 
  private let dataViewModel = DataViewModel()
  
  private let bookmarkViewModel = BookmarkViewModel()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() { // fix - Most add new view
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
  
//  override func viewWillAppear(_ animated: Bool) {
//    view.layoutIfNeeded()
//    view.layoutSubviews()
//    homeVC.navigationItem.searchController = homeVC.searchController
//    
//  }
  
}

// MARK: - UI Configuration

extension TabBarController {
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
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    if let navigationController = viewControllers?[1] as? UINavigationController,
           let bookmarkVC = navigationController.topViewController as? BookmarkViewController {
            bookmarkVC.bookmarkViewModel.fetchBookmarks() // 重新加载书签数据
            print("Tab switched to BookmarkViewController")
        }
    
  }
}
