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

  init(themeViewModel: ThemeViewModel) {
    self.themeViewModel = themeViewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
          // 使用預設的 ThemeViewModel 進行初始化，或者您可以選擇傳入其他 ThemeViewModel
          self.themeViewModel = ThemeViewModel(themeManager: .shared)
          super.init(coder: coder)
      }
  
  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupThemeBinding()
  }
}

// MARK: - Setup Theme
extension BaseThemedViewController {
  private func setupThemeBinding() {
    themeViewModel.$currentBackgroundColor
      .sink { [weak self] color in
        self?.view.backgroundColor = color
      }
      .store(in: &cancellables)
    
    themeViewModel.$currentTextColor
      .sink { [weak self] color in
        self?.updateTextColor(color)
      }
      .store(in: &cancellables)
  }
  
  private func updateTextColor(_ color: UIColor) {
    for subview in view.subviews {
      if let label = subview as? UILabel {
        label.textColor = color
      }
    }
  }
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection) // FIX - 這是Ios 17 以前的寫法
    // 檢查顏色外觀是否正確
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      setupThemeBinding()
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
