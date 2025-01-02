//
//  ThemeManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/26.
//

import Foundation
import UIKit

/// Theme Manager
class ThemeManager {
  // MARK: - Singleton

  static let shared = ThemeManager()

  // MARK: - Properties

  var currentBackgroundColor: UIColor {
    return UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
  }
    
  var currentTextColor: UIColor {
    return UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
  }
}

extension ThemeManager {
  // MARK: - Methods
     
  /// 更新樣式的邏輯，根據當前主題設置 UIView 的顏色
  /// - Parameter view: 要更新的視圖
  /// - Throws: 如果更新過程中出現錯誤，會拋出錯誤
  func updateTheme(for view: UIView) throws {
    view.backgroundColor = currentBackgroundColor
    if let label = view as? UILabel {
      print("label")
      label.textColor = currentTextColor
    }
    if let button = view as? UIButton {
      print("button")
      button.setTitleColor(currentTextColor, for: .normal)
    }
  }
}
