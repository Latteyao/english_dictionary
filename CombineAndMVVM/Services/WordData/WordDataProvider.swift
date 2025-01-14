//
//  WordDataProvider.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/8/7.
//

import Combine
import Foundation

/// DataManager 負責處理資料抓取與發布邏輯
class WordDataProvider: WordDataService, WordDataFetcher {
  // MARK: - Singleton

  private let networkService: NetworkService
  private let localWordService: LocalWordService
  private(set) var popularWords: [String] = []
  
  // MARK: - Initializer
  
  init(networkService: NetworkService, localWordService: LocalWordService) {
    self.networkService = networkService
    self.localWordService = localWordService
    loadPopularWords()
  }
}
  
extension WordDataProvider {
  
  func fetchWord(endpoint: Endpoint.RequestPath) -> AnyPublisher<WordData, NetworkError> {
    networkService.fetchData(endpoint)
  }
  
  private func loadPopularWords() {
    popularWords = localWordService.loadPopularWords(from: "words_dictionary")
  }
  
  func fetchPopularWords(at array: [String]) -> AnyPublisher<[PopularWordResult], Never> {
    let publishers = array.map { word in
      self.networkService
        .fetchData(Endpoint.RequestPath.general(for: word))
        .map { wordData in
          PopularWordResult(word: word, wordData: wordData, errorDescription: nil)
        }
        .catch { error -> Just<PopularWordResult> in
          let result = PopularWordResult(word: word, wordData: nil, errorDescription: error.localizedDescription)
          return Just(result)
        }
        .eraseToAnyPublisher()
    }
    return Publishers.MergeMany(publishers)
      .collect() // 收集所有結果
      .eraseToAnyPublisher()
  }
}
