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
    return UITraitCollection.current.userInterfaceStyle == .dark ? .white : .brown
  }
  
  /// 主題變更的 Publisher
  private let themeChangeSubject = PassthroughSubject<Void, Never>()
  
  var themeDidChange: AnyPublisher<Void, Never> {
          return themeChangeSubject.eraseToAnyPublisher()
      }
}

// MARK: - Methods
extension ThemeManager {
  /// 發送主題更新通知
  func notifyThemeChange() {
    themeChangeSubject.send()
  }
}

