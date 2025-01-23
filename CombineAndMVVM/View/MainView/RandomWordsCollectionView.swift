//
//  RandomWordsCollectionView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/11.
//

import Foundation
import UIKit

/// 管理RandomWordsCollectionView
class RandomWordsCollectionView: UIView {
  // MARK: - Properties
  
  var collectionView: UICollectionView!
  
  weak var delegate: WordCollectionViewCellDelegate?
  
  // MARK: - UI Elements
  
  /// 標題
  let headerLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20)
    label.text = "隨機詞彙"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  /// 隨機按鈕
  let randomButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
    button.tintColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  /// 分隔線
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Initializer
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupCollectionView()
    randomButtonAction()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Configuration

extension RandomWordsCollectionView {
  /// 設置 CollectionView 和其他 UI 元素的配置
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
  
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .systemGray
    collectionView.layer.cornerRadius = 15
    collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: "WordCell")
    backgroundColor = .gray
    layer.cornerRadius = 20
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(collectionView)
    addSubview(headerLabel)
    addSubview(randomButton)
    addSubview(separatorView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    setupConstraints()
  }
  /// 調整子視圖的布局
  override func layoutSubviews() {
    super.layoutSubviews()
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//      layout.itemSize = CGSize(width: frame.width / 3 - 10, height: frame.height - 30)
      layout.itemSize = CGSize(width: frame.width - 30, height: frame.height / 3 - 30)
    }
  }
}

// MARK: - Button Action

extension RandomWordsCollectionView {
  /// 設置隨機按鈕的動作
  func randomButtonAction() {
    randomButton.addTarget(self, action: #selector(reroll), for: .touchUpInside)
  }
  /// 隨機按鈕被點擊時觸發的方法
  @objc func reroll() {
    // 通知 delegate 重新載入數據
    delegate?.didTapReroll()
    // 重新載入 CollectionView 的數據
    collectionView.reloadData()
  }
}

// MARK: - CollectionView Delegate Methods

extension RandomWordsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCollectionViewCell
    return cell
  }
}

// MARK: - Constraints

extension RandomWordsCollectionView {
  /// 設置所有子視圖的約束
  private func setupConstraints() {
    setupHeaderLabelConstraints()
    setupRandomButtonConstraints()
    setupSeparatorViewConstraints()
    setupCollectionViewConstraints()
  }
  /// 設置 headerLabel 的約束
  private func setupHeaderLabelConstraints() {
    NSLayoutConstraint.activate([
      headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      headerLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -8),
      headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8)
      
    ])
  }
  /// 設置 randomButton 的約束
  private func setupRandomButtonConstraints() {
    NSLayoutConstraint.activate([
      randomButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      randomButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -8),
      randomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
    ])
  }
  /// 設置 separatorView 的約束
  private func setupSeparatorViewConstraints() {
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
      separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  /// 設置 collectionView 的約束
  private func setupCollectionViewConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }
}
