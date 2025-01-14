//
//  WordDataProvider.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/8/7.
//

import Combine
import Foundation

/// 負責管理「單字資料」的存取與抓取
/// 同時實作了本地資料協議 (WordDataService) 與網路抓取協議 (WordDataFetcher)
class WordDataProvider: WordDataService, WordDataFetcher {
  // MARK: - Singleton
  
  /// 網路服務，負責 API 請求
  private let networkService: NetworkService
  
  /// 本地單字讀取服務
  private let localWordService: LocalWordService
  
  /// 暴露給外部的熱門單字清單
  private(set) var popularWords: [String] = []
  
  // MARK: - Initializer
  
  init(networkService: NetworkService, localWordService: LocalWordService) {
    self.networkService = networkService
    self.localWordService = localWordService
    loadPopularWords() // 初始化時載入本地熱門單字
  }
}

// MARK: - Public Methods (WordDataFetcher)

extension WordDataProvider {
  /// 針對特定單字進行網路抓取
  /// - Parameter endpoint: API 路徑
  /// - Returns: 傳回「單字資料」或「網路錯誤」的 Publisher
  func fetchWord(endpoint: Endpoint.RequestPath) -> AnyPublisher<WordData, NetworkError> {
    networkService.fetchData(endpoint)
  }
  
  /// 對傳入的多個單字進行並行網路請求，允許部份失敗
  /// - Parameter array: 字串陣列 (單字列表)
  /// - Returns: 傳回所有單字結果（成功/失敗）組成的陣列；不再往外拋錯，因此使用 `Never`
  func fetchPopularWords(at array: [String]) -> AnyPublisher<[PopularWordResult], Never> {
    // 將每個單字轉成各自的 Publisher，並在失敗時將錯誤包裝進 `PopularWordResult` 的 errorDescription
    let publishers = array.map { word in
      self.networkService
        .fetchData(Endpoint.RequestPath.general(for: word))
        .map { wordData in
          // 成功時: 帶回 wordData
          PopularWordResult(word: word, wordData: wordData, errorDescription: nil)
        }
        .catch { error -> Just<PopularWordResult> in
          // 失敗時: 將錯誤描述放入 errorDescription
          let result = PopularWordResult(word: word, wordData: nil, errorDescription: error.localizedDescription)
          return Just(result)
        }
        .eraseToAnyPublisher()
    }
    // 合併所有單字請求，收集結果為陣列
    return Publishers.MergeMany(publishers)
      .collect()
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Methods

extension WordDataProvider {
  /// 從本地檔案載入熱門單字
  
   func loadPopularWords() {
    popularWords = localWordService.loadPopularWords(from: "words_dictionary")
  }
}
