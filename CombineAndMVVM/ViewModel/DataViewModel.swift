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
  
  @Published var errorState: String!
  
 
//  var popularWords: [String] = ["example", "word", "popular"]
  
  var popularWords: [String] = []
  
  var popularWordsErrorState: [String] = []

  private let dataManager = DataManager.shared

  

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
//      popularWords.shuffle()
    popularWords = []
    popularWordsErrorState = []
    for word in dataManager.popularWords.shuffled()[0...2] {
      popularWords.append(word.key)
    }
    
    
  }
  
  /// 更新檢視層資料
  /// - Parameters:
  ///   - fallbackWord: 當資料的 `word` 為空時的備援字
  ///   - data: 原始的 `WordData`
  func newViewData(fallbackWord: String, form data: WordData) {
    viewData = updateWordIfNil(from: fallbackWord, in: data)
  }
  
  ///清除 viewModel 資料與錯誤狀態
  private func clearViewData(){
    viewData = .empty
    errorState = nil
  }
  
  private func clearRandomDataAndPopularWordsErrorStates(){
    // 清空數據與錯誤狀態
       randomData.removeAll()
       popularWordsErrorState.removeAll()
  }
  
  /// 更新 `WordData.word`，若為空則使用備援字
  /// - Parameters:
  ///   - fallbackWord: 當 `word` 為空時的備援字
  ///   - data: 要檢查和更新的 `WordData`
  /// - Returns: 更新後的 `WordData`
  private func updateWordIfNil(from fallbackWord: String, in data: WordData) -> WordData {
      var updatedData = data
      if updatedData.word == nil {
          updatedData.word = fallbackWord
      }
      return updatedData
  }
}

// MARK: - Fetch Methods
extension DataViewModel {
  /// 拉取單一單字資料
  /// - Parameter word: 要拉取的單字
  func fetchData(word: String){
    clearViewData() // 清除 viewModel 狀態
    dataManager.performFetchData(for: word)
      .mapError(mapApiError)
      .flatMap { [weak self] wordData in
        guard let self = self else {
          return Fail<WordData, DataViewModel.WordDetailStateError>(error: WordDetailStateError.otherError).eraseToAnyPublisher()
        }
        return validateWordData(wordData)
      }
      .catch({ [weak self] error -> AnyPublisher<WordData, Never> in
        self?.viewData.word = word // 資料沒有 View 還能顯示目標字
        self?.errorState = error.description
        print("Error massage: \(error.description)")
        return Empty(completeImmediately: true).eraseToAnyPublisher()
      })
      .sink(receiveValue: { [weak self] wordData in
        print("Word: \(wordData.word ?? "nil")")
        self?.viewData = wordData
      })
      .store(in: &cancellables)
    
  }
  
  /// 拉取所有熱門單字的資料，並更新 `randomData`
//  func fetchAllpopularWords() async {
//    print(popularWords)
//    dataManager.createPopularWordsPublisher(popularWords)
//      .receive(on: DispatchQueue.main) // 在主執行緒上接收資料
//      .sink { completion in
//        switch completion {
//        case .finished:
//          print("All popular words have been fetched")
//        case .failure(let error):
//          print("An error occurred while fetching popular words: \(error)")
//        }
//      } receiveValue: { [weak self] dataArray in
//        // 更新 `randomData`，避免強循環
//        self?.randomData.append(contentsOf: dataArray)
//      }
//      .store(in: &cancellables) // 儲存訂閱以便後續釋放
//  }
  
  
  func fetchAllpopularWords(){
    // 清空數據與錯誤狀態
    clearRandomDataAndPopularWordsErrorStates()
    dataManager.createPopularWordsPublisher(popularWords)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .finished:
          print("All popular words have been fetched")
        case .failure(let error):
          print("An error occurred while fetching popular words: \(error)")
        }
      } receiveValue: { [ weak self ] results in
        // 根據原始索引排序
        results.forEach { _, wordData, errorDescription in
          self?.randomData.append(wordData) // 成功資料放在 randomData
          if let errorDescription = errorDescription{
            self?.popularWordsErrorState.append(errorDescription) // 錯誤描述放在 popularWordsErrorState
          }
          else {
            self?.popularWordsErrorState.append("") // 成功的資料也放一個 "Success" 表示成功
          }
        }
    }
    
   
      .store(in: &cancellables) // 儲存訂閱
  }
  
//  private func fetchDataPublisher(word: String) -> AnyPublisher<WordData, WordDetailStateError>{
//    Future { [ weak self ] promise in
//      self?.fetchData(word: <#T##String#>)
//    }
//  }
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

// MARK: - Error methon
extension DataViewModel{
  
  // 將 API 錯誤映射為 WordDetailStateError
  private func  mapApiError(_ apiError: WordApiManager.DatafetchError) -> WordDetailStateError {
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
}
  // 驗證 WordData 並返回 Publisher
  private func validateWordData(_ wordData: WordData) -> AnyPublisher<WordData, WordDetailStateError> {
//            self.viewData.word = wordData.word
            if wordData.word == nil, wordData.word == "" {
              return Fail(outputType: WordData.self, failure: .notFouundData)
                .eraseToAnyPublisher()
            }
            if wordData.results == nil {
              return Fail(outputType: WordData.self, failure: .notFoundAnnotation)
                .eraseToAnyPublisher()
            }
            return Just(wordData)
              .setFailureType(to: WordDetailStateError.self)
              .eraseToAnyPublisher()
          }
  // 捕獲錯誤並更新狀態
  private func handleWordDetailError(_ error: WordDetailStateError, errorState: inout WordDetailStateError?) -> AnyPublisher<WordData, Never> {
      errorState = error
      print("Error message: \(error.description)")
      return Empty(completeImmediately: true).eraseToAnyPublisher()
  }
  }


// MARK: - 設定視圖狀態
extension DataViewModel{
  
  
  enum WordDetailStateError:String, Error{
    case notFouundData
    case notFoundAnnotation
    case networkError
    case otherError
    
    var description: String {
      switch self {
      case .notFoundAnnotation: return "找不到註解"
      case .networkError: return "網路錯誤"
      case .otherError: return "其他錯誤"
      case .notFouundData: return "無資料"
        
      }
    }
  }
  
}
