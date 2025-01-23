//
//  ThemeManaging.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/23.
//

import Foundation
import Combine
import UIKit

protocol ThemeManaging {
  
  var currentBackgroundColor: UIColor { get }
  var currentTextColor: UIColor { get }

  func applyTheme(to view: UIView)
  func notifyThemeChange()

  var themeDidChange: AnyPublisher<Void, Never> { get }
}

