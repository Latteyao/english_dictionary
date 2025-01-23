//
//  ThemeViewModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/7.
//

import Foundation
import UIKit
import Combine

// 主題管理的 ViewModel，負責處理應用程式的主題顏色變更
class ThemeViewModel: ObservableObject {
  
  // 當前的背景顏色，只有讀取權限
  @Published private(set) var currentBackgroundColor: UIColor
  
  // 當前的文字顏色，只有讀取權限
  @Published private(set) var currentTextColor: UIColor
  
   var themeManager: ThemeManaging
  
  private var cancellables = Set<AnyCancellable>()
  
  /// 初始化 ViewModel，注入主題管理器，並設定初始顏色和訂閱主題變更
    /// - Parameter themeManager: 用於管理主題的 ThemeManaging 實例，默認為 ThemeManager()
  init(themeManager: ThemeManaging = ThemeManager()) {
    self.themeManager = themeManager
    self.currentBackgroundColor = themeManager.currentBackgroundColor
    self.currentTextColor = themeManager.currentTextColor
    // 設置主題訂閱
    setupThemeSubscription()
  }
}

// MARK: - Methods

extension ThemeViewModel{
  /// 設置主題變更的訂閱，當主題變更時更新顏色
  private func setupThemeSubscription() {
    // 訂閱主題變更 Publisher
    themeManager.themeDidChange
      .receive(on: RunLoop.main) // 在主線程接收事件
      .sink { [weak self] in
        self?.updateThemeColors() // 更新主題顏色
      }
      .store(in: &cancellables) // 儲存訂閱，以管理其生命週期
  }
  
  /// 更新當前的背景顏色和文字顏色
  private func updateThemeColors() {
    currentBackgroundColor = themeManager.currentBackgroundColor
    currentTextColor = themeManager.currentTextColor
  }
}
