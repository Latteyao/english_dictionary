//
//  SearchManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/13.
//

import Combine
import Foundation
import UIKit

class SearchManager: WordApiManager {
  // MARK: - Singleton

  static let shared = SearchManager()
  
  // MARK: - Properties
  
  private var cancellables = Set<AnyCancellable>()
}

// MARK: - Search Methods
extension SearchManager {
  /// 執行搜尋
    /// - Parameters:
    ///   - query: 搜尋字串
    ///   - completion: 回呼結果，包含成功或失敗狀態
  func performSearch(with query: String, completion: @escaping (Result<ResponseModel, DatafetchError>) -> Void) {
    let endpoint = Endpoint.search(for: query)
    fetchData(endpoint: endpoint)
      .handleEvents()
      .sink { completionResult in
        switch completionResult {
        case .failure(let error):
          completion(.failure(error))
        case .finished:
          print("Successfully fetched data for word: \(query)")
        }
      } receiveValue: { results in
        completion(.success(results))
//        print("success \(results)")
      }
      .store(in: &cancellables)
  }
}

// MARK: - Search Results State
extension SearchManager {
  
  /// 搜尋結果的狀態
  enum SearchResultsState {
    case success(ResponseModel)
    case failure(DatafetchError)
  }
}
