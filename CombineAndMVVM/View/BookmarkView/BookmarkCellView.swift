//
//  BookmarkCellView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/29.
//

import UIKit

// 自訂的 BookmarkCellView，用於顯示單個書籤
class BookmarkCellView: UITableViewCell {
  // MARK: - Properties

  /// 顯示書籤文字的標籤
  let wordLabel: UILabel = {
    let label = UILabel()
//    label.textColor = ThemeManager.shared.currentTextColor // Fix 需要修改
    label.text = "word"
    label.font = .systemFont(ofSize: 20)
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: - Initializer

  /// 初始化 BookmarkCellView，設定樣式和重用標識
  /// - Parameters:
  ///   - style: 單元格樣式
  ///   - reuseIdentifier: 重用標識
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: "bookmarkCell")
    viewSetup() // 設置view
    setupConstraints() // 設定位置
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Configuration

extension BookmarkCellView {
  /// 設置子視圖，將 wordLabel 添加到 contentView 中
  private func viewSetup() {
    contentView.addSubview(wordLabel)
  }

  /// 配置 Cell 的內容
  /// - Parameter word: 書籤的文字
  func configure(with word: String) {
    wordLabel.text = word
  }
}

// MARK: - Constraints

extension BookmarkCellView {
  /// 設定所有子視圖的約束
  private func setupConstraints() {
    setupWordLabelConstraints()
  }

  /// 設置 wordLabel 的具體約束，確保其在 Cell 中的位置和大小
  private func setupWordLabelConstraints() {
    NSLayoutConstraint.activate([
      wordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      wordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
      wordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
