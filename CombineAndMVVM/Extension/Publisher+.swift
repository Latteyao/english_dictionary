//
//  Publisher+.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/8.
//

import Combine
import Foundation

extension Publisher where Output == WordData, Failure == DataManager.DatafetchError {
  /// 對 WordData 進行驗證並處理錯誤
  /// - Parameter errorHandler: 自定義的錯誤映射邏輯
  /// - Returns: 經過錯誤映射和數據驗證的 Publisher
  func validatedAndMapped(errorHandler: @escaping (DataManager.DatafetchError) -> DataViewModel.WordDetailStateError) -> AnyPublisher<WordData, DataViewModel.WordDetailStateError> {
    self
      .mapError { errorHandler($0) }
      
      .flatMap { wordData -> AnyPublisher<WordData, DataViewModel.WordDetailStateError> in
        // 驗證 wordData 的屬性是否符合要求
        if wordData.word?.isEmpty ?? true {
          return Fail(error: DataViewModel.WordDetailStateError.notFouundData).eraseToAnyPublisher()
        }
        if wordData.results == nil {
          return Fail(error: DataViewModel.WordDetailStateError.notFoundAnnotation).eraseToAnyPublisher()
        }
        return Just(wordData)
          .setFailureType(to: DataViewModel.WordDetailStateError.self)
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
