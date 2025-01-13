//
//  NetworkManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/13.
//

import Foundation
import Combine


class NetworkManager: NetworkService, NetworkErrorHandler, NetworkResponseHandler{
  
  private let session: URLSession
  
  init() {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = [
      "X-RapidAPI-Key": MySecret.APIKey,
      "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"
    ]
    self.session = URLSession(configuration: config)
  }
  /// 根據給定的端點從網絡上抓取數據
  func fetchData<T: Codable>(endpoint: Endpoint.RequestPath) -> AnyPublisher<T, NetworkError> {
    return session.dataTaskPublisher(for: endpoint.url)
      .tryMap { output in
        try self.handleResponse(output)
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { error in
        self.handleNetworkError(error)
      }
      .eraseToAnyPublisher()
  }
  
  
}
