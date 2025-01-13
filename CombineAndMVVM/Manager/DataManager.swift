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

   var popularWords: [String: Int] = [:]

  /// For combine can calcellables
  var cancellables = Set<AnyCancellable>()

  // MARK: - Initializer

  override init() {
    super.init()
    loadPopularWords()
  }
}

// MARK: - Data Fetching

extension DataManager {
  /// 根據單字抓取資料，並返回 `AnyPublisher`，支援泛型解析
  /// - Parameter word: 要抓取的單字
  /// - Returns: 泛型 `AnyPublisher`，若發生錯誤則回傳自訂錯誤類型 `DatafetchError`
  func performFetchData(for word: String) -> AnyPublisher<WordData, DatafetchError>  {
    let endpoint = Endpoint.general(for: word)
    return fetchData(endpoint: endpoint)
  }
}

// MARK: - Popular Words Methods

extension DataManager {
  private func loadPopularWords() {
    if let path = Bundle.main.path(forResource: "words_dictionary", ofType: "json"),
       let data = try? Data(contentsOf: URL(fileURLWithPath: path))
    {
      if let words = try? JSONDecoder().decode([String: Int].self, from: data) {
        popularWords = words
      }
    }
  }
  
}

// MARK: - Popular Words Publisher

extension DataManager {
  /// 建立熱門單字的 Publisher，並根據輸入的單字列表依序抓取對應的資料
  /// - Parameter array: 要抓取資料的單字列表
  /// - Returns: 傳送包含 `WordData` 的 Publisher，若發生錯誤將自動回傳空資料
//  func createPopularWordsPublisher(_ array: [String]) -> AnyPublisher<[WordData], DatafetchError> {
//    Publishers.Sequence(sequence: array.enumerated())
//      .flatMap { [weak self] index, word -> AnyPublisher<(Int, WordData), DatafetchError> in
//        guard let self = self else {
//          //          return Just((index, WordData.empty)).eraseToAnyPublisher()
//          return Fail(outputType: (Int, WordData).self, failure: .unknownError).eraseToAnyPublisher()
//        }
//        return self.fetchData(endpoint: Endpoint.general(for: word))
//          .map { (index, $0) } // 包含索引與資料，便於後續排序
//        //          .replaceError(with: (index, WordData.empty)) // 發生錯誤時回傳空資料
//          .eraseToAnyPublisher()
//      }
//      .collect()
//      .map { results in
//        results.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
//      }
//      .eraseToAnyPublisher()
//  }
  /// 建立熱門單字的 Publisher，並根據輸入的單字列表依序抓取對應的資料
      /// - Parameter array: 要抓取資料的單字列表
      /// - Returns: 待修改
  func createPopularWordsPublisher(_ array: [String]) -> AnyPublisher<[PopularWordResult], DataViewModel.WordDetailStateError> {
    Publishers.Sequence(sequence: array.enumerated())
      .flatMap { [weak self] index, word -> AnyPublisher<PopularWordResult, DataViewModel.WordDetailStateError> in
        guard let self = self else {
          return Fail(outputType: PopularWordResult.self, failure: .otherError).eraseToAnyPublisher()
        }
        return self.fetchData(endpoint: Endpoint.general(for: word))
          .mapError({ apiError -> DataViewModel.WordDetailStateError in
            switch apiError {
            case .invalidResponse:
                return .networkError
            case .invalidData:
                return .notFouundData
            case .networkError:
                return .networkError
            case .unknownError:
                return .otherError
            }
          })
          .map { wordData in
            // 成功時返回資料、無錯誤描述，以及原始索引
            return PopularWordResult(index: index, wordData: wordData, errorDescription: nil)
          }
          .catch { error -> Just<PopularWordResult> in
            // 錯誤時返回空資料、錯誤描述，以及原始索引
            let errorDescription = error.description
            let emptyData = WordData.empty
            return Just(PopularWordResult(index: index, wordData: emptyData, errorDescription: error.description))
          }
          .setFailureType(to: DataViewModel.WordDetailStateError.self)
          .eraseToAnyPublisher()
        
      }
      .collect()
      .map { results in
        results.sorted(by: { $0.index < $1.index })
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

extension DataManager{
  struct PopularWordResult {
      let index: Int
      let wordData: WordData
      let errorDescription: String?
  }
}
