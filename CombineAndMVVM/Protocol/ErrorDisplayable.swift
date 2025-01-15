//
//  ErrorDisplayable.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/5.
//

import Foundation
import UIKit


protocol ErrorDisplayable {
  func showError(_ message: String?)
}

extension ErrorDisplayable where Self: UIViewController {
  func showError(_ message: String?) {
    if let message = message {
      let errorView = ErrorDisplayView(message: message)
      errorView.show(in: self.view)
    }
  }
}
