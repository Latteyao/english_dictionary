//
//  BaseThemedViewController.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/27.
//

import Combine
import UIKit

/// Dark Mode Controller
class BaseThemedViewController: UIViewController {
  // MARK: - Properties
  
  let themeViewModel: ThemeViewModel
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Initializer
  
  /// 初始化方法，接受一個 ThemeViewModel 實例
  /// - Parameter themeViewModel: 用於管理主題的 ViewModel，默認為新的
  init(themeViewModel: ThemeViewModel = ThemeViewModel()) {
    self.themeViewModel = themeViewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupThemeBinding()
  }
}

// MARK: - Setup Theme

extension BaseThemedViewController {
  
  /// 設置主題顏色的綁定，訂閱 ViewModel 中的顏色變化
  private func setupThemeBinding() {
    // 監聽當前背景色的變化，並更新視圖的背景顏色
    themeViewModel.$currentBackgroundColor
      .sink { [weak self] color in
        self?.view.backgroundColor = color
      }
      .store(in: &cancellables)
    // 監聽當前文字顏色的變化，並更新所有 UILabel 的文字顏色
    themeViewModel.$currentTextColor
      .sink { [weak self] color in
        self?.updateTextColor(color)
      }
      .store(in: &cancellables)
  }
  
  /// 更新視圖中所有 UILabel 的文字顏色
  /// - Parameter color: 新的文字顏色
  private func updateTextColor(_ color: UIColor) {
    for subview in view.subviews {
      if let label = subview as? UILabel {
        label.textColor = color
      }
    }
  }
  
  /// 當 trait collection 發生改變時呼叫的方法，用於檢查顏色外觀是否變更
    /// - Parameter previousTraitCollection: 之前的 trait collection
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection) // FIX - 這是Ios 17 以前的寫法
    // 檢查顏色外觀是否正確
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      // 如果顏色外觀有變化，可以在此處重新設置主題綁定
//      setupThemeBinding()
      return
    }
  }
  
}


// MARK: - Error

extension BaseThemedViewController {
  enum ThemeManagerError: Error {
    case themeNotFound
    case themeNotInitialized
  }
}
