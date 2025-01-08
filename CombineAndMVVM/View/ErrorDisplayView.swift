//
//  ErrorDisplayView.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/4.
//

import Foundation
import UIKit

class ErrorDisplayView: UIView {
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

  private let iconImage: UIImageView = {
    let imageView = UIImageView()
    let image = UIImage(systemName: "xmark.circle")!
    imageView.image = image
    imageView.sizeToFit()
    imageView.tintColor = .systemGray2
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

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
  private func setupUI(with message: String) {
    backgroundColor = UIColor.black.withAlphaComponent(0.8)
    layer.cornerRadius = 8
    addSubview(iconImage)
    addSubview(messageLabel)
    messageLabel.text = message
  }
}

// MARK: - ParentView Configuration

extension ErrorDisplayView {
  func show(in parentView: UIView, duration: TimeInterval = 3) {
    translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(self)
    setupParentViewConstraints(in: parentView)
    alpha = 0
    setupAnimation(for: duration)
  }
}

// MARK: - Animation

extension ErrorDisplayView {
  private func setupAnimation(for duration: TimeInterval) {
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      UIView.animate(withDuration: 0.3) {
        self.alpha = 0
      } completion: { _ in
        self.removeFromSuperview()
      }
    }
  }
}

// MARK: - Constraints

extension ErrorDisplayView {
  private func setupConstraints() {
    setupIconImageConstraints()
    setupMessageLabelConstraints()
  }

  private func setupIconImageConstraints() {
    NSLayoutConstraint.activate([
      //      iconImage.topAnchor.constraint(equalTo: topAnchor, constant: 12),
//      iconImage.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -12),
//      iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//      iconImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      iconImage.centerXAnchor.constraint(equalTo: centerXAnchor),
      iconImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),
      iconImage.widthAnchor.constraint(equalToConstant: 80),
      iconImage.heightAnchor.constraint(equalToConstant: 80)
    ])
  }

  private func setupMessageLabelConstraints() {
    NSLayoutConstraint.activate([
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      messageLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 8),
      messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }

  private func setupParentViewConstraints(in parentView: UIView) {
    NSLayoutConstraint.activate([
      self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
      self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
      self.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
      self.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
    ])
  }
}


