//
//  WordCollectionViewCell.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/11.
//

import Foundation
import UIKit



class WordCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  weak var delegate: WordCollectionViewCellDelegate?
  
  let wordButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .black
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 10
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    buttonAction()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Configuration

extension WordCollectionViewCell {
  
  private func setupView() {
    contentView.addSubview(wordButton)
  }
  
  ///設定按鈕Title
   func configure(with word: String) {
    wordButton.setTitle(word, for: .normal)
  }
  
  
  
}
// MARK: - Button Actions
extension WordCollectionViewCell {
  
  private func buttonAction() {
    wordButton.addTarget(self, action: #selector(navigateToDictionaryPage), for: .touchUpInside)
  }
  
  /// 跳轉到字典頁面的邏輯
  @objc func navigateToDictionaryPage()  {
    delegate?.didTapWordButton(in: self)
  }
}



// MARK: - Constraints
extension WordCollectionViewCell{
  private func setupConstraints() {
    setupWordButtonConstraints()
  }
  
  private func setupWordButtonConstraints() {
    
    NSLayoutConstraint.activate([
      wordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      wordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      wordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      wordButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}


