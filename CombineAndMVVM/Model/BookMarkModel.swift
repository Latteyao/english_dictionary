//
//  BookMarkModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/29.
//

import Foundation
// MARK: - 書籤資料模型

/// 用於保存書籤數據的結構，包含書籤的唯一標識符、標題和相關的單詞數據。
struct BookMarkData {
  let id: UUID
  let title: String
  let Data: WordData
  
  
  init(id: UUID,title: String, Data: WordData) {
    self.id = UUID()
    self.title = title
    self.Data = Data
  }
}
