//
//  ThemeAwareViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/27.
//

import UIKit

/// Dark Mode Controller
class ThemeAwareViewController: UIViewController {
  
  // MARK: - Properties
  
  let ThemeManager: ThemeManager = .shared
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    applyTheme()
  }
}

// MARK: - Setup Theme

extension ThemeAwareViewController {
  func applyTheme() {
    do{
      try ThemeManager.updateTheme(for: self.view)
//      updateSubviewsTheme(view: self.view) 目前先不用
    } catch {
      print(ThemeManagerError.themeNotInitialized)
    }
    
    print("目前主體為: \(UITraitCollection.current.userInterfaceStyle.rawValue == 1 ? "Light" : "Dark")")
  }
  ///功能為更新所有的 subview 需要修改
//  private func updateSubviewsTheme(view: UIView){ //
//    view.reloadInputViews()
//    for subview in view.subviews {
//      if let label = subview as? UILabel {
//        label.textColor = ThemeManager.currentTextColor // 更新子視圖文字顏色
//      }
//      updateSubviewsTheme(view: subview) // 遞歸處理子視圖
//    }
//  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection) //FIX - 這是Ios 17 以前的寫法
    // 檢查顏色外觀是否正確
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      applyTheme()
      
    }
  }
  
}

// MARK: - Error
extension ThemeAwareViewController{
  enum ThemeManagerError: Error {
    case themeNotFound
    case themeNotInitialized
  }
}
