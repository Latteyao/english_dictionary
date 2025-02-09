//
//  SearchManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/13.
//

import Combine
import Foundation
import UIKit

class SearchManager {
  // MARK: - Singleton

//  static let shared = SearchManager()
  
  private let wordApiManager:WordApiManager
  
  // MARK: - Properties
  
  private var cancellables = Set<AnyCancellable>()
  
  init(wordApiManager: WordApiManager = WordApiManager(),
       cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
    self.wordApiManager = wordApiManager
    self.cancellables = cancellables
  }
  
}

// MARK: - Search Methods
extension SearchManager {
  /// 執行搜尋
    /// - Parameters:
    ///   - query: 搜尋字串
    ///   - completion: 回呼結果，包含成功或失敗狀態
  func performSearch(with query: String, completion: @escaping (Result<ResponseModel, NetworkError>) -> Void) {
    let endpoint = Endpoint.RequestPath.search(for: query)
    wordApiManager.fetchData(endpoint)
      .handleEvents(
        receiveSubscription: { _ in print("開始訂閱 API Call") },
        receiveOutput: { output in print("收到結果: \(output)") },
        receiveCompletion: { completion in print("請求完成: \(completion)") },
        receiveCancel: { print("請求被取消") }
      )
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
    case failure(NetworkError)
  }
}
