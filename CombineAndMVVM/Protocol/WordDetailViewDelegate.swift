//
//  WordDetailViewDelegate.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/18.
//

import Foundation

protocol WordDetailViewDelegate: AnyObject {
  func wordDateilViewDidTapBookmarkbutton(_ title: String, data: WordData)
}
