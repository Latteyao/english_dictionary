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

  @Published var randomData: [WordData] = []

  @Published var viewData: WordData = .empty
  
  var popularWords: [String] = ["example", "word", "popular"]

  private let dataManager = DataManager.shared

  var errorMessage: String = ""

  /// For combine can calcellables
  var cancellables: Set<AnyCancellable> = []
}

// MARK: - Random Data Methods

extension DataViewModel {
  
  /// 隨機化熱門單字並重置隨機資料
  func rollDice() {
    resetRandomData()
    shufflePopularWords()
  }
  /// 清空現有資料
  private func resetRandomData() {
      randomData = []
  }
  /// 隨機排列熱門單字
  private func shufflePopularWords() {
      popularWords.shuffle()
  }
  
  /// 更新檢視層資料
  /// - Parameter data: 新的 `WordData`
  func newViewData(Data: WordData) {
    viewData = Data
    
  }
}

// MARK: - Fetch Methods

extension DataViewModel {
  /// 拉取單一單字資料
   /// - Parameter word: 要拉取的單字
   /// - Returns: 包含 `WordData` 的 `AnyPublisher`，若失敗則返回 `DatafetchError`
  func fetchData(word: String) -> AnyPublisher<WordData, WordApiManager.DatafetchError> {
    dataManager.performFetchData(for: word)
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  /// 拉取所有熱門單字的資料，並更新 `randomData`
  func fetchAllpopularWords() async {
    print(popularWords)
    dataManager.createPopularWordsPublisher(popularWords)
      .receive(on: DispatchQueue.main) // 在主執行緒上接收資料
      .sink { completion in
        switch completion {
        case .finished:
          print("All popular words have been fetched")
        case .failure(let error):
          print("An error occurred while fetching popular words: \(error)")
        }
      } receiveValue: { [weak self] dataArray in
        // 更新 `randomData`，避免強參考循環
        self?.randomData.append(contentsOf: dataArray)
      }
      .store(in: &cancellables) // 儲存訂閱以便後續釋放
  }
  }


extension DataViewModel {
  /// 提供一個靜態屬性 empty
  static let empty = WordData(
          word: "",
          frequency: 0,
          syllables: Syllables(count: 0, list: [""]),
          pronunciation: Pronunciation(all: ""),
          results: []
      )

}
