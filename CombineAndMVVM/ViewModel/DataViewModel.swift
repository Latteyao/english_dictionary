//
//  DataViewModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/20.
//

import Combine
import Foundation

/// DataViewModel 負責處理資料邏輯與檢視層的互動
class DataViewModel: ObservableObject {
  // MARK: - Properties

  @Published var randomData: [PopularWordResult] = []

  @Published var detailState = WordDetailState(wordData: .empty, error: nil)
  
  private let wordDataProvider: WordDataProvider

  private var cancellables: Set<AnyCancellable> = []
  
  // MARK: - Initializer
  
  init(wordDataProvider: WordDataProvider = WordDataProvider()) {
    self.wordDataProvider = wordDataProvider
    fetchPopularWords()
  }
}

extension DataViewModel {
  // MARK: - 重新骰熱門單字

  func reloadPopularWords() {
    // 1. 重置狀態
    resetState()

    // 2. 讓 WordDataProvider 重新載入 / 洗牌 popularWords

    wordDataProvider.loadPopularWords()


    // 3. 用最新的 popularWords 進行抓取
    fetchPopularWords()
  }

  func fetchPopularWords() {
    wordDataProvider.fetchPopularWords(at: wordDataProvider.popularWords)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] popularWordResults in
        // popularWordResults 是 [PopularWordResult]
        // 你可根據錯誤或成功狀態進行處理
        // 若使用「部分失敗」策略，就不會拋錯出來
        self?.randomData = popularWordResults

        // 如果要顯示錯誤，可再遍歷 errorDescription
        let errors = popularWordResults.compactMap { $0.errorDescription }
        if !errors.isEmpty {
//          self?.errorState = errors.joined(separator: "\n")
        }
      }
      .store(in: &cancellables)
  }

  func fetchSingleWord(_ word: String) {
    resetState()
    wordDataProvider.fetchWord(endpoint: .general(for: word))
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case .failure(let networkError):
          self?.detailState.error = networkError.localizedDescription
        case .finished:
          break
        }
      }, receiveValue: { [weak self] wordData in
        guard let self = self else { return }
        self.detailState.wordData = wordData
        // 如果原本有錯誤，需要清掉錯誤
        self.detailState.error = nil
      })
      .store(in: &cancellables)
  }

  // MARK: - 重置狀態（viewData 和 errorState）

  func resetState() {
    detailState = WordDetailState(wordData: .empty, error: nil)
  }
  
  func loadRandomDataToDetailState(form index:PopularWordResult){
    resetState()
    detailState.wordData = index.wordData ?? .empty
    detailState.error = index.errorDescription
    detailState.wordData.word = index.word // 不讓畫面的主要字空白
  }
  
  func loadDataToDetailState(form wordData: WordData){
    resetState()
    detailState.wordData = wordData
  }
}
