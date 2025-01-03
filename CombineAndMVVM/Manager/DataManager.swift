//
//  DataManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/8/7.
//

import Combine
import Foundation

/// DataManager 負責處理資料抓取與發布邏輯
class DataManager: WordApiManager, ObservableObject {
  // MARK: - Singleton

  static let shared = DataManager()
  
  // MARK: - Properties
  
  var allPopularWords: [String] = ["example", "word", "popular"]
  
  /// For combine can calcellables
  var cancellables = Set<AnyCancellable>()
}

// MARK: - Data Fetching

extension DataManager {
  /// 根據單字抓取資料，並返回 `AnyPublisher`，支援泛型解析
  /// - Parameter word: 要抓取的單字
  /// - Returns: 泛型 `AnyPublisher`，若發生錯誤則回傳自訂錯誤類型 `DatafetchError`
  func performFetchData<T: Codable>(for word: String) -> AnyPublisher<T, DatafetchError> {
    let endpoint = Endpoint.general(for: word)
    return fetchPublisher(endpoint: endpoint)
  }
}

// MARK: - Popular Words Publisher

extension DataManager {
  /// 建立熱門單字的 Publisher，並根據輸入的單字列表依序抓取對應的資料
  /// - Parameter array: 要抓取資料的單字列表
  /// - Returns: 傳送包含 `WordData` 的 Publisher，若發生錯誤將自動回傳空資料
  func createPopularWordsPublisher(_ array: [String]) -> AnyPublisher<[WordData], Never> {
    Publishers.Sequence(sequence: array.enumerated())
      .flatMap { [weak self] index, word -> AnyPublisher<(Int, WordData), Never> in
        guard let self = self else {
          return Just((index, WordData.empty)).eraseToAnyPublisher()
        }
        return self.fetchPublisher(endpoint: Endpoint.general(for: word))
          .map { (index, $0) } // 包含索引與資料，便於後續排序
          .replaceError(with: (index, WordData.empty)) // 發生錯誤時回傳空資料
          .eraseToAnyPublisher()
      }
      .collect()
      .map { results in
        results.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - Fetch Results State

extension DataManager {
  enum FetchDataResultsState {
    case success(ResponseModel) // 成功，並返回 ResponseModel
    case failure(DatafetchError) // 失敗，並返回 DatafetchError
  }
}
