//
//  BookmarkCellView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/29.
//

import UIKit

class BookmarkCellView: UITableViewCell {
  
  // MARK: - Properties
  
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
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: "bookmarkCell")
//    super.init(style: style, reuseIdentifier: nil)
    viewSetup() //設置view
    setupConstraints() // 設定位置
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
// MARK: - UI Configuration
extension BookmarkCellView{
  private func viewSetup(){
    contentView.addSubview(wordLabel)
  }
  
  func configure(with word: String) {
    wordLabel.text = word
 }
}

// MARK: - Constraints

extension BookmarkCellView{
  private func setupConstraints(){
    setupWordLabelConstraints()
  }
  
  private func setupWordLabelConstraints(){
    NSLayoutConstraint.activate([
      wordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      wordLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      wordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
      wordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
