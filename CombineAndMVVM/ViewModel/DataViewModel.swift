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
  
  @Published var errorState: WordDetailStateError!
  
 
//  var popularWords: [String] = ["example", "word", "popular"]
  
  var popularWords: [String] = []

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
    for word in dataManager.popularWords.shuffled()[0...2] {
      popularWords.append(word.key)
    }
    
    
  }
  
  /// 更新檢視層資料
  /// - Parameter data: 新的 `WordData`
  func newViewData(Data: WordData) {
    viewData = Data
    
  }
  ///清除 viewModel 資料與錯誤狀態
  private func clearViewData(){
    viewData = .empty
    errorState = nil
  }
}

// MARK: - Fetch Methods

extension DataViewModel {
  /// 拉取單一單字資料
   /// - Parameter word: 要拉取的單字
  func fetchData(word: String){
    clearViewData() // 清除 viewModel 狀態
    dataManager.performFetchData(for: word)
      .mapError { apiError -> WordDetailStateError in
        switch apiError{
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
      .flatMap { wordData -> AnyPublisher<WordData, WordDetailStateError> in
        self.viewData.word = wordData.word
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
      .catch({ [weak self] error -> AnyPublisher<WordData, Never> in
        self?.errorState = error
        print("Error massage: \(error.description)")
        return Empty(completeImmediately: true).eraseToAnyPublisher()
      })
    
//      .sink { completion in
//        switch completion{
//        case .finished:
//          break
//        case .failure(_):
//          break
//        }
//      } receiveValue: { [weak self] wordData in
//        self?.viewData = .empty
//        self?.viewData = wordData
//        self?.errorState = nil // 清除之前的错误状态
//      }
      .sink(receiveValue: { [weak self] wordData in
        print("Word: \(wordData.word ?? "nil")")
        self?.viewData = wordData
      })
      .store(in: &cancellables)

  }
  
  func errorHandler(data: WordData,completion: @escaping () -> Void) -> String? {
    return ""
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
        // 更新 `randomData`，避免強循環
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
