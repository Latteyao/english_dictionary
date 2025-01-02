//
//  String.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/15.
//

import Foundation
import UIKit

extension String {
  
  func asIndentedAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 14 // 首行縮排
        paragraphStyle.headIndent = 14 // 其他行的縮排
        paragraphStyle.lineSpacing = 4 // 行距
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 16) // 字體大小
        ]
        
    return NSAttributedString(string: self, attributes: attributes)
    }
  
  func emptyOrNil() -> String {
    self.isEmpty || self == "" || self == " " ? "❎" : self
    
  }
}

// MARK: - 設定視圖狀態

enum ViewState {
    case idle
    case loading
    case loaded
    case error(String)
}
// MARK: - 活動指示器
var activityIndicator: UIActivityIndicatorView = {
  var activityIndicator = UIActivityIndicatorView(style: .medium)
  activityIndicator.hidesWhenStopped = true
  return activityIndicator
}()

var currentState: ViewState = .loading {
    didSet {
        updateViewState()
    }
}
// MARK: - 更新視圖狀態
func updateViewState() {
    switch currentState {
    case .loading:
        // 顯示加載狀態
        activityIndicator.startAnimating()
    case .loaded:
        // 更新 UI 並隱藏加載狀態
        activityIndicator.stopAnimating()
    case .error(let message):
        // 顯示錯誤訊息
        activityIndicator.stopAnimating()
        
    case .idle:
      break
    }
}
