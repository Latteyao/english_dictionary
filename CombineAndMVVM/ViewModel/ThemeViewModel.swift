//
//  ThemeViewModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/7.
//

import Foundation
import UIKit
import Combine

class ThemeViewModel {
  
  @Published private(set) var currentBackgroundColor: UIColor
  
  @Published private(set) var currentTextColor: UIColor
  
  private var themeManager: ThemeManager
  
  private var cancellables = Set<AnyCancellable>()
  
  init(themeManager: ThemeManager = ThemeManager()) {
    self.themeManager = themeManager
    self.currentBackgroundColor = themeManager.currentBackgroundColor
    self.currentTextColor = themeManager.currentTextColor
    
    // 訂閱主題變更通知
    NotificationCenter.default.publisher(for: ThemeManager.themeDidChangeNotification)
      .sink { [weak self] _ in
        self?.updateThemeColors()
      }
      .store(in: &cancellables)
    
  }
  
  
}

extension ThemeViewModel{
  
  private func updateThemeColors() {
    currentBackgroundColor = themeManager.currentBackgroundColor
    currentTextColor = themeManager.currentTextColor
  }
}
