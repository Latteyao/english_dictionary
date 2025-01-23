//
//  ThemeManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/26.
//

import Foundation
import UIKit
import Combine

/// Theme Manager
class ThemeManager: ThemeManaging {
  
  
  // MARK: - Singleton

  init() {}

  // MARK: - Properties

  /// 背景
  var currentBackgroundColor: UIColor {
    return UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
  }

  /// 字體顏色
  var currentTextColor: UIColor {
    return UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
  }

  /// 註冊 Notification
//  static let themeDidChangeNotification = Notification.Name("ThemeDidChangeNotification")
  
  /// 主題變更的 Publisher
  private let themeChangeSubject = PassthroughSubject<Void, Never>()
      var themeDidChange: AnyPublisher<Void, Never> {
          return themeChangeSubject.eraseToAnyPublisher()
      }
}

extension ThemeManager {
  // MARK: - Methods

  /// 更新樣式的邏輯，根據當前主題設置 UIView 的顏色
  /// - Parameter view: 要更新的視圖
  func applyTheme(to view: UIView) {
    view.backgroundColor = currentBackgroundColor
    for subview in view.subviews {
      if let label = subview as? UILabel {
        label.textColor = currentTextColor
      } else if let button = subview as? UIButton {
        button.setTitleColor(currentTextColor, for: .normal)
      } else {
        applyTheme(to: subview)
      }
    }
  }

  /// 發送主題更新通知
  func notifyThemeChange() {
//    NotificationCenter.default.post(name: ThemeManager.themeDidChangeNotification, object: nil)
    themeChangeSubject.send()
  }
}

