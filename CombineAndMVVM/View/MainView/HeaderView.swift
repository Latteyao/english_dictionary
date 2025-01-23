//
//  HeaderView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/23.
//

import UIKit

// 自訂的 HeaderView，用於顯示標題
class HeaderView: UIView {
  
  // MARK: - UI Elements
  
  /// 標題標籤
  let headerTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "字典"
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 25)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: - Initializer

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    configureConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Configuration

extension HeaderView {
  /// 設置視圖的外觀，包括背景顏色和添加標題標籤
  private func setupView() {
    backgroundColor = .systemBlue
    addSubview(headerTitleLabel) // 將標題標籤添加到視圖中
  }
}

// MARK: - Constraints

extension HeaderView {
  /// 配置所有子視圖的約束
  private func configureConstraints() {
    setupHeaderTitleLabel() // 設置標題標籤的約束
  }
  /// 設置 headerTitleLabel 的位置
  private func setupHeaderTitleLabel() {
    NSLayoutConstraint.activate([
      headerTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      headerTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -4)
    ])
  }
}
