//
//  ErrorDisplayView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/4.
//

import Foundation
import UIKit
// 自訂的 ErrorDisplayView，用於顯示錯誤訊息
class ErrorDisplayView: UIView {
  // MARK: - Properties

  // 顯示錯誤訊息的標籤
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // 顯示錯誤圖示的圖片視圖
  private let iconImage: UIImageView = {
    let imageView = UIImageView()
    let image = UIImage(systemName: "xmark.circle")!
    imageView.image = image
    imageView.sizeToFit()
    imageView.tintColor = .systemGray2
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  // MARK: - Initializer

  init(message: String) {
    super.init(frame: .zero)
    setupUI(with: message)
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Configuration

extension ErrorDisplayView {
  /// 設置視圖的 UI 元素
  /// - Parameter message: 要顯示的錯誤訊息
  private func setupUI(with message: String) {
    backgroundColor = UIColor.black.withAlphaComponent(0.8) // 設定背景顏色及透明度
    layer.cornerRadius = 8 // 設定圓角
    addSubview(iconImage) // 添加錯誤圖示到視圖
    addSubview(messageLabel) // 添加訊息標籤到視圖
    messageLabel.text = message // 設定訊息標籤的文字
  }
}

// MARK: - ParentView Configuration

extension ErrorDisplayView {
  /// 顯示錯誤視圖在指定的父視圖中
  /// - Parameters:
  ///   - parentView: 要顯示錯誤視圖的父視圖
  ///   - duration: 錯誤視圖顯示的持續時間，預設為3秒
  func show(in parentView: UIView, duration: TimeInterval = 3) {
    translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(self) // 將錯誤視圖添加到父視圖中
    setupParentViewConstraints(in: parentView) // 設定錯誤視圖在父視圖中的約束
    alpha = 0 // 初始透明度為0
    setupAnimation(for: duration) // 設定顯示和隱藏的動畫
  }
}

// MARK: - Animation

extension ErrorDisplayView {
  /// 設定顯示和隱藏錯誤視圖的動畫
  /// - Parameter duration: 錯誤視圖顯示的持續時間
  private func setupAnimation(for duration: TimeInterval) {
    // 顯示動畫
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1 // 將透明度設為1，顯示視圖
    }
    // 延遲一段時間後執行隱藏動畫
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      UIView.animate(withDuration: 0.3) {
        self.alpha = 0 // 將透明度設為0，隱藏視圖
      } completion: { _ in
        self.removeFromSuperview() // 動畫完成後移除視圖
      }
    }
  }
}

// MARK: - Constraints

extension ErrorDisplayView {
  /// 設置所有子視圖的約束
  private func setupConstraints() {
    setupIconImageConstraints()
    setupMessageLabelConstraints()
  }

  /// 設置 iconImage 的約束
  private func setupIconImageConstraints() {
    NSLayoutConstraint.activate([
      iconImage.centerXAnchor.constraint(equalTo: centerXAnchor),
      iconImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),
      iconImage.widthAnchor.constraint(equalToConstant: 80),
      iconImage.heightAnchor.constraint(equalToConstant: 80)
    ])
  }

  /// 設置 messageLabel 的約束
  private func setupMessageLabelConstraints() {
    NSLayoutConstraint.activate([
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      messageLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 8),
      messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }

  /// 設置 ParentView 的約束
  /// - Parameter parentView: 父視圖
  private func setupParentViewConstraints(in parentView: UIView) {
    NSLayoutConstraint.activate([
      centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
      centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
      widthAnchor.constraint(lessThanOrEqualToConstant: 200),
      heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
    ])
  }
}
