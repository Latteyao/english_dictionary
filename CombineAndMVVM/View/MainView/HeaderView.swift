//
//  HeaderView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/23.
//

import UIKit

class HeaderView: UIView {
  
  // MARK: - UI Elements

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
  private func setupView() {
    backgroundColor = .systemBlue
    addSubview(headerTitleLabel)
  }
}

// MARK: - Constraints

extension HeaderView {
  private func configureConstraints() {
    setupHeaderTitleLabel()
  }

  private func setupHeaderTitleLabel() {
    NSLayoutConstraint.activate([
      headerTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      headerTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -4)
    ])
  }
}
