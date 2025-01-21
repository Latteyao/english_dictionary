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
  
  init(mockDataManager: MockDataService = MockDataManager(),
       networkManager:NetworkService = NetworkManager(),
       isMockEnabled: Bool = false) {
    self.mockDataManager = mockDataManager
    self.networkManager = networkManager
    self.isMockEnabled = isMockEnabled
  }
  
  func fetchData<T: Codable>(_ endpoint:Endpoint.RequestPath) -> AnyPublisher<T,NetworkError>{
    guard isMockEnabled else {
      print("Mode is Mock")
      return mockDataManager.fetchMockData(endpoint)
    }
    print("Mode is Network")
    return networkManager.fetchData(endpoint)

  }

}


// MARK: - Error Handling Enum


enum NetworkError:String, Error {
  case invalidResponse = "Invalid HTTP response"
  case invalidData = "Invalid data"
  case networkFailure = "Network failure"
  case unknown = "Unknown error"
}



