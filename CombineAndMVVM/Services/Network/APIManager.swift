//
//  APIManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/6/27.
//

import Combine
import Foundation

/// 管理 API 請求和模擬數據抓取的類別
class WordApiManager {
  // MARK: - Properties

  private let isMockEnabled: Bool
  
  private let mockDataManager: MockDataService
  
  private let networkManager: NetworkService
  
  init(mockDataManager: MockDataService, networkManager:NetworkService, isMockEnabled: Bool = false) {
    self.mockDataManager = mockDataManager
    self.networkManager = networkManager
    self.isMockEnabled = isMockEnabled
  }
  
  func fetchData<T: Codable>(_ endpoint:Endpoint.RequestPath) -> AnyPublisher<T,NetworkError>{
    guard isMockEnabled else {
      return mockDataManager.fetchMockData(endpoint)
    }
    return networkManager.fetchData(endpoint)
  }

}


// MARK: - Error Handling Enum


enum NetworkError: Error {
  case invalidResponse
  case invalidData
  case networkFailure
  case unknown
}



