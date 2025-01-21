//
//  WordCollectionViewCellDelegate.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/5.
//

import Foundation
import UIKit

// MARK: - WordCollectionViewCellDelegate Protocol

protocol WordCollectionViewCellDelegate: AnyObject {
  //按下按鈕事件
  func didTapWordButton(in cell: WordCollectionViewCell)
  func didTapReroll()
}
