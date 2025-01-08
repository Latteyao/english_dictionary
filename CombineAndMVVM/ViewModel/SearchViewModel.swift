//
//  SearchViewModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/13.
//

import Combine
import Foundation
import UIKit

class SearchViewModel: ObservableObject {
  // MARK: - Properties
  
  /// 搜尋結果
  @Published var searchResults: ResponseModel = .init(query: Query(letterPattern: "", limit: "50", page: 0), results: .init(total: 1, data: [""]))
  
  /// 狀態
//  @Published var state: ViewState = .idle
  
  //紀錄
  var lastQuery: String?
  
  /// 錯誤訊息
  @Published var errorMessage: String?
  
  /// 搜尋管理器 (單例模式)
  let searchManager = SearchManager.shared
}

// MARK: - Methods

extension SearchViewModel {
  /// 執行搜尋功能
  /// - Parameters:
  ///   - query: 搜尋的關鍵字
  ///   - completion: 搜尋完成後的回呼
  func search(query: String, completion: @escaping () -> Void) {
    guard !query.isEmpty else { return }
    guard query != lastQuery else { return } //判斷跟上一次搜尋是否相同
//    state = .loading
    
    errorMessage = nil
    lastQuery = query // 把搜尋的結果放到 lastQuery
    searchManager.performSearch(with: query.lowercased()) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        switch result {
        case .success(let results):
          self.searchResults = results
          self.searchResults.results.data?.insert(query.lowercased(), at: 0) // 直接讓被搜尋的字放在第一列
//          self.state = .loaded
          completion()
        case .failure(let error):
          self.errorMessage = "Search is fail：\(error.localizedDescription)"
//          self.state = .error("data fetch failed")
        }
      }
    }
  }

  /// 清除搜尋結果
  func clearSearchResults() {
    searchResults = .init(query: Query(letterPattern: "",
                                       limit: "50", page: 0),
                          results: .init(total: 1, data: [""]))
    errorMessage = nil
  }
}
