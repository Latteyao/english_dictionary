//
//  DetailWordCollectionCellView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/8/2.
//

import Foundation
import UIKit

class DetailWordCollectionCellView: UICollectionViewCell {
  
  // MARK: - Properties
  /// 背景
  var background: UIView = {
    var view = UIView()
    view.backgroundColor = .systemGray
    view.layer.cornerRadius = 15
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  /// 定義Label
  var definitionLabel: UILabel = {
    var label = UILabel()
    label.text = "Definition:"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  /// 定義敘述Label
  var definitionDescriptionLabel: UILabel = {
    var label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var derivationLabel: UILabel = {
    var label = UILabel()
    label.text = "Derivation:"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var derivationDescriptionLabel: UILabel = {
    var label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var exmpleLabel: UILabel = {
    var label = UILabel()
    label.text = "Example:"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var exmpleDescriptionLabel: UILabel = {
    var label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var hasTypesLabel: UILabel = {
    var label = UILabel()
    label.text = "HasTypes:"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var hasTypesDescriptionLabel: UILabel = {
    var label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var partOfSpeechLabel: UILabel = {
    var label = UILabel()
    label.text = "PartOfSpeech:"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var partOfSpeechDescriptionLabel: UILabel = {
    var label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var synonymsLabel: UILabel = {
    var label = UILabel()
    label.text = "Synonyms:"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var synonymsDescriptionLabel: UILabel = {
    var label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var typeOfLabel: UILabel = {
    var label = UILabel()
    label.text = "TypeOf:"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var typeOfDescriptionLabel: UILabel = {
    var label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var vstackView: UIStackView = .init()
  
  /// 箭頭按鈕
  var chevronButton: UIButton = {
    var button = UIButton()
    button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
//    button.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
    return button
  }()
  
  /// 按鈕Bool
  var isExpanded: Bool = false
  
  // MARK: - Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAllViews()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Configuration

extension DetailWordCollectionCellView {
  /// 設置所有 View
  private func setupAllViews() {
    let hStackView = setupHstack()
    vstackView = setupVstack()
    contentView.addSubview(background)
    contentView.addSubview(hStackView)
    contentView.addSubview(vstackView)
    setupAllConstraints(topView: hStackView, stackView: vstackView)
  }
  /// 設置 HstackView
  private func setupHstack() -> UIStackView {
    let view = UIStackView(arrangedSubviews: [definitionLabel, UIView(), chevronButton])
    view.axis = .horizontal
    view.spacing = 4
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  /// 設置 VstackView
  private func setupVstack() -> UIStackView {
    let view = UIStackView(arrangedSubviews: [definitionDescriptionLabel,
                                               derivationLabel,
                                               derivationDescriptionLabel,
                                               exmpleLabel,
                                               exmpleDescriptionLabel,
                                               hasTypesLabel,
                                               hasTypesDescriptionLabel,
                                               partOfSpeechLabel,
                                               partOfSpeechDescriptionLabel,
                                               synonymsLabel,
                                               synonymsDescriptionLabel,
                                               typeOfLabel,
                                               typeOfDescriptionLabel])
    view.axis = .vertical
    view.spacing = 2
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true // 顯示上有問題 目前預設先藏起來 使用toggle開關來顯示
    view.distribution = .equalSpacing
    return view
  }
  
  //FIX - 撰寫命名與解釋
  func configure(with item: WordResult) {
    definitionDescriptionLabel.attributedText = (item.definition ?? "none").asIndentedAttributedString()
    derivationDescriptionLabel.attributedText = (item.derivation?.joined(separator: "\n") ?? "none").asIndentedAttributedString()
    exmpleDescriptionLabel.attributedText = (item.examples?.joined(separator: "\n") ?? "none").asIndentedAttributedString()
    hasTypesDescriptionLabel.attributedText = (item.hasTypes?.joined(separator: ", ") ?? "none").asIndentedAttributedString()
    partOfSpeechDescriptionLabel.attributedText = (item.partOfSpeech ?? "none").asIndentedAttributedString()
    synonymsDescriptionLabel.attributedText = (item.synonyms?.joined(separator: ", ") ?? "none").asIndentedAttributedString()
    typeOfDescriptionLabel.attributedText = (item.typeOf?.joined(separator: ", ") ?? "none").asIndentedAttributedString()
  }
  
  
}
// MARK: - Animation

extension DetailWordCollectionCellView{
  /// 控制 chevronButton 轉的角度
  func updateChevronDirection(isExpanded: Bool) {
      UIView.animate(withDuration: 0.3) {
        self.chevronButton.transform = isExpanded ? CGAffineTransform(rotationAngle: 1.6) : .identity
      }
  }

}

// MARK: - Constraints

extension DetailWordCollectionCellView {
  /// 設置所有相對位置
  private func setupAllConstraints(topView: UIStackView, stackView: UIStackView) {
    setupTopViewAndStackView(top: topView, stack: stackView)
    setupbackgroundConstraint()
    setupchevronButton()
  }
  
  ///設置 top and stack View 的相對位置
  private func setupTopViewAndStackView(top topView: UIStackView,stack  stackView: UIStackView){
    NSLayoutConstraint.activate([
      topView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//      topView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
      topView.heightAnchor.constraint(lessThanOrEqualToConstant: 50)
    ])
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 4),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
  
  /// 設置 background 相對位置
  private func setupbackgroundConstraint() {
    NSLayoutConstraint.activate([
      background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      background.topAnchor.constraint(equalTo: contentView.topAnchor),
      background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  /// 設置 chevronButton 相對位置
  private func setupchevronButton() {
    NSLayoutConstraint.activate([
      chevronButton.topAnchor.constraint(equalTo: definitionLabel.topAnchor),
      chevronButton.bottomAnchor.constraint(equalTo: definitionLabel.bottomAnchor),
      chevronButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      chevronButton.widthAnchor.constraint(equalToConstant: 24),
      chevronButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 24)
    ])
  }
}


