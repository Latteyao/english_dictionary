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
      
  private let isMockEnabled: Bool = false
  private let session: URLSession = {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = [
      "X-RapidAPI-Key": MySecret.APIKey,
      "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"
    ]
    return URLSession(configuration: config)
  }()
}

// MARK: - Methods

extension WordApiManager {
  /// 從模擬數據管理器抓取單字數據
  func fetchMockData<T: Codable>(_ endpoint: Endpoint) -> AnyPublisher<T, DatafetchError> {
    let endpointURL = endpoint.request.url!.description
    var wordKey = ""
    switch endpoint {
    case .general(for: _):
      wordKey = endpointURL.replacingOccurrences(of: "https://wordsapiv1.p.rapidapi.com/words/", with: "")
      guard let mockResponseData = MockDataManager(rawValue: wordKey) else {
        return Fail(error: DatafetchError.invalidData)
          .eraseToAnyPublisher()
      }
      do {
        // 假設 mockData 是 Data 類型，可以用來解碼成 WordData
        let decodedData = try JSONDecoder().decode(T.self, from: mockResponseData.stub)
        
        // 返回解碼後的資料
        return Just(decodedData) // 返回解碼的 WordData
          .setFailureType(to: DatafetchError.self) // 設置錯誤類型為 DatafetchError
          .eraseToAnyPublisher() // 返回 AnyPublisher
      } catch {
        // 如果解碼過程出錯，返回失敗的 Publisher
        return Fail(error: DatafetchError.invalidData)
          .eraseToAnyPublisher()
      }
    case .random:
      wordKey = "https://wordsapiv1.p.rapidapi.com/words/?random=true"
      guard let mockResponseData = MockDataManager(rawValue: wordKey) else {
        return Fail(error: DatafetchError.invalidData)
          .eraseToAnyPublisher()
      }
      do {
        // 假設 mockData 是 Data 類型，可以用來解碼成 WordData
        let decodedData = try JSONDecoder().decode(T.self, from: mockResponseData.stub)
              
        // 返回解碼後的資料
        return Just(decodedData) // 返回解碼的 WordData
          .setFailureType(to: DatafetchError.self) // 設置錯誤類型為 DatafetchError
          .eraseToAnyPublisher() // 返回 AnyPublisher
      } catch {
        // 如果解碼過程出錯，返回失敗的 Publisher
        return Fail(error: DatafetchError.invalidData)
          .eraseToAnyPublisher()
      }
    case .search(for: _):
      wordKey = endpointURL.replacingOccurrences(of: "https://wordsapiv1.p.rapidapi.com/words/?limit=100&letterPattern=", with: "")

      guard let mockResponseData = MockSearchManager(rawValue: wordKey) else {
        return Fail(error: DatafetchError.invalidData)
          .eraseToAnyPublisher()
      }
      do {
        // 假設 mockData 是 Data 類型，可以用來解碼成 ResponseModel
        let decodedData = try JSONDecoder().decode(T.self, from: mockResponseData.stub)
        
        // 返回解碼後的資料
        return Just(decodedData) // 返回解碼的 ResponseModel
          .setFailureType(to: DatafetchError.self) // 設置錯誤類型為 DatafetchError
          .eraseToAnyPublisher() // 返回 AnyPublisher
      } catch {
        // 如果解碼過程出錯，返回失敗的 Publisher
        return Fail(error: DatafetchError.invalidData)
          .eraseToAnyPublisher()
      }
    }
  }

  /// 根據給定的端點從網絡上抓取數據
  func fetchData<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, DatafetchError> {
    if isMockEnabled { return fetchMockData(endpoint) }
    let urlRequest = endpoint.request
    return session.dataTaskPublisher(for: urlRequest)
      .tryMap { output in
        guard let urlResponse = output.response as? HTTPURLResponse, 200 ... 299 ~= urlResponse.statusCode else {
          print(" InvalidResponse ")
          throw DatafetchError.invalidResponse
        }
        return output.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { error in
        if let decodingError = error as? DecodingError {
          print("Error decoding JSON: \(decodingError.localizedDescription)")
          return .invalidResponse
        }
        if let urlError = error as? URLError {
          print("Error fetching data: \(urlError.localizedDescription)")
          return .networkError
        }
        return .unknownError
      }
      .eraseToAnyPublisher()
  }

  /// 通過完成處理器從網絡上抓取數據
  func fetch<T: Codable>(endpoint: Endpoint, completion: @escaping (T?) -> Void) {
    let task = session.dataTask(with: endpoint.request) { data, response, error in
      if let error = error {
        print("Error fetching data: \(error.localizedDescription)")
        completion(nil)
      }
      if let httpResponse = response as? HTTPURLResponse {
        guard 200 ... 299 ~= httpResponse.statusCode else {
          print("Error StatusCode: \(httpResponse.statusCode)")
          return completion(nil)
        }
      }
        
      guard let data = data else {
        print("No data fetching")
        return completion(nil)
      }
        
      do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        DispatchQueue.main.async {
          completion(decodedData)
        }
          
      } catch {
        print("Error decoding JSON: \(error)")
        print("Failed JSON: \(String(describing: String(data: data, encoding: .utf8)))")
        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
    task.resume()
  }
}

// MARK: - Enum Definitions

extension WordApiManager {
  // MARK: - Endpoint Enum

  enum Endpoint {
    case general(for: String)
    case random
    case search(for: String)
    
    var request: URLRequest {
      switch self {
      case .general(for: let word):
        return URLRequest(url: URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)")!)
      case .random:
        return URLRequest(url: URL(string: "https://wordsapiv1.p.rapidapi.com/words/?random=true")!)
      case .search(for: let word):
        return URLRequest(url: URL(string: "https://wordsapiv1.p.rapidapi.com/words/?limit=100&letterPattern=\(word)")!)
      }
    }
  }

  // MARK: - Mock Data Enums

  enum MockDataManager: String {
    case example
    case popular
    case word
    case w
    case wo
    case wor
  }
  
  enum MockSearchManager: String {
    case w
    case wo
    case wor
    case word
  }

  // MARK: - Error Handling Enum

  enum DatafetchError: Error {
    case invalidResponse
    case invalidData
    case networkError
    case unknownError
  }
}


